// Two-way sync between the local database and Supabase.
//
//  push: every record marked dirty locally is upserted to Supabase.
//  pull: rows changed on the server since the last pull are copied down,
//        unless the local copy is newer and not yet pushed (last write wins).
//
// Runs when the app starts, when the network comes back, every few minutes,
// and shortly after local changes. Without Supabase config or without a
// signed-in user it does nothing, so the app stays fully usable offline.

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../local/local_db.dart';
import '../local/migrations.dart';
import '../repositories/settings_repository.dart';

enum SyncStatus { offline, signedOut, idle, syncing, error }

class SyncService {
  SyncService(this.local, this.client);

  final LocalDb local;

  /// Null when the app was built without Supabase settings.
  final SupabaseClient? client;

  /// Pull overlaps by this much so small clock differences never lose rows.
  static const _pullOverlap = Duration(minutes: 5);
  static const _pageSize = 500;

  final status = ValueNotifier<SyncStatus>(SyncStatus.idle);
  final lastSyncedAt = ValueNotifier<DateTime?>(null);
  final lastError = ValueNotifier<String?>(null);

  Timer? _debounce;
  Timer? _periodic;
  StreamSubscription<List<ConnectivityResult>>? _connectivity;
  StreamSubscription<AuthState>? _auth;
  Future<void>? _running;

  String? get _userId => client?.auth.currentUser?.id;

  void start() {
    if (client == null) {
      status.value = SyncStatus.signedOut;
      return;
    }
    _connectivity = Connectivity().onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) syncNow();
    });
    _auth = client!.auth.onAuthStateChange.listen((s) {
      if (s.event == AuthChangeEvent.signedIn) syncNow();
      if (s.event == AuthChangeEvent.signedOut) {
        status.value = SyncStatus.signedOut;
      }
    });
    _periodic = Timer.periodic(const Duration(minutes: 5), (_) => syncNow());
    syncNow();
  }

  /// Call after local writes; batches bursts of changes into one sync.
  void schedule() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 10), syncNow);
  }

  Future<void> syncNow() =>
      _running ??= _sync().whenComplete(() => _running = null);

  Future<void> _sync() async {
    final userId = _userId;
    if (client == null || userId == null) {
      status.value = SyncStatus.signedOut;
      return;
    }
    status.value = SyncStatus.syncing;
    try {
      for (final table in LocalDb.syncedTables) {
        await _push(table, userId);
        await _pull(table, userId);
      }
      lastSyncedAt.value = DateTime.now();
      lastError.value = null;
      status.value = SyncStatus.idle;
    } catch (e) {
      lastError.value = e.toString();
      status.value = SyncStatus.error;
      debugPrint('sync failed: $e');
    }
  }

  String _localKey(SyncedTable t, Map<String, Object?> row) =>
      t == LocalDb.userSettings
      ? SettingsRepository.key
      : row[t.keyColumn] as String;

  String _conflictColumns(SyncedTable t) => t.keyColumn == 'user_id'
      ? 'user_id'
      : t.keyColumn == 'id'
      ? 'id'
      : 'user_id,${t.keyColumn}';

  Future<void> _push(SyncedTable t, String userId) async {
    final dirty = await local.dirty(t);
    if (dirty.isEmpty) return;
    final rows = [
      for (final r in dirty) {...forUpload(r.value), 'user_id': userId},
    ];
    for (var i = 0; i < rows.length; i += _pageSize) {
      final page = rows.sublist(i, (i + _pageSize).clamp(0, rows.length));
      await client!.from(t.name).upsert(page, onConflict: _conflictColumns(t));
    }
    // Mark clean only if the record didn't change again while uploading.
    for (final r in dirty) {
      final current = await local.get(t, r.key);
      if (current != null && current['updated_at'] == r.value['updated_at']) {
        await local.putRemote(t, r.key, forUpload(current));
      }
    }
  }

  Future<void> _pull(SyncedTable t, String userId) async {
    final cursorKey = 'pulled_at:${t.name}';
    final cursor = await local.getMeta<String>(cursorKey);
    var since = cursor == null
        ? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)
        : DateTime.parse(cursor).subtract(_pullOverlap);
    String? newest = cursor;

    while (true) {
      final rows = await client!
          .from(t.name)
          .select()
          .eq('user_id', userId)
          .gt('updated_at', since.toIso8601String())
          .order('updated_at', ascending: true)
          .limit(_pageSize);
      for (final remote in rows) {
        final row = migrateLegacyRow(
          t,
          Map<String, Object?>.from(remote)..remove('user_id'),
        );
        final key = _localKey(t, row);
        final mine = await local.get(t, key);
        final mineIsNewer =
            mine != null &&
            mine[LocalDb.dirtyField] == true &&
            DateTime.parse(mine['updated_at'] as String)
                .isAfter(DateTime.parse(row['updated_at'] as String));
        if (!mineIsNewer) await local.putRemote(t, key, row);
        newest = row['updated_at'] as String;
      }
      if (rows.length < _pageSize) break;
      since = DateTime.parse(newest!);
    }
    if (newest != null) await local.setMeta(cursorKey, newest);
  }

  void dispose() {
    _debounce?.cancel();
    _periodic?.cancel();
    _connectivity?.cancel();
    _auth?.cancel();
  }
}
