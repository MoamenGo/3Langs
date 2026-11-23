// Offline-first local storage. Every learner record lives here first; the
// sync service copies changed records to Supabase when the device is online.
//
// Each synced store keeps plain JSON maps (the same shape as the Supabase row)
// plus a local-only `_dirty` flag meaning "changed here, not pushed yet".

import 'package:sembast/sembast_memory.dart';

import 'db_factory.dart';

class SyncedTable {
  const SyncedTable(this.name, this.keyColumn, {this.appendOnly = false});

  /// Supabase table name, also used as the local store name.
  final String name;

  /// Column that identifies a row for one user (card_id, lesson_id, id...).
  final String keyColumn;

  /// Rows are never edited after creation (logs, sessions).
  final bool appendOnly;
}

class LocalDb {
  LocalDb._(this.db);
  final Database db;

  static const cardStates = SyncedTable('card_states', 'card_id');
  static const reviewLogs = SyncedTable('review_logs', 'id', appendOnly: true);
  static const lessonProgress = SyncedTable('lesson_progress', 'lesson_id');
  static const studySessions = SyncedTable(
    'study_sessions',
    'id',
    appendOnly: true,
  );
  static const writingSubmissions = SyncedTable('writing_submissions', 'id');
  static const userSettings = SyncedTable('user_settings', 'user_id');
  static const languageTracks = SyncedTable('language_tracks', 'lang');

  static const syncedTables = [
    userSettings,
    languageTracks,
    cardStates,
    reviewLogs,
    lessonProgress,
    studySessions,
    writingSubmissions,
  ];

  /// Local-only key/value store: sync cursors, device preferences.
  final meta = StoreRef<String, Object?>('meta');

  static const dirtyField = '_dirty';

  StoreRef<String, Map<String, Object?>> store(SyncedTable t) =>
      stringMapStoreFactory.store(t.name);

  static Future<LocalDb> open({String name = '3lang'}) async =>
      LocalDb._(await openAppDatabase(name));

  /// In-memory database for tests. Each call gets a fresh, empty database
  /// (memory databases with the same name share their data).
  static Future<LocalDb> memory() async => LocalDb._(
    await databaseFactoryMemory.openDatabase('test${_memoryCount++}'),
  );
  static var _memoryCount = 0;

  /// Saves a record changed on this device and marks it for upload.
  Future<void> putLocal(SyncedTable t, String key, Map<String, Object?> row) =>
      store(t).record(key).put(db, {...row, dirtyField: true});

  /// Saves a record that came from the server (already in sync).
  Future<void> putRemote(SyncedTable t, String key, Map<String, Object?> row) =>
      store(t).record(key).put(db, {...row, dirtyField: false});

  Future<Map<String, Object?>?> get(SyncedTable t, String key) =>
      store(t).record(key).get(db);

  Future<List<Map<String, Object?>>> all(
    SyncedTable t, {
    Filter? filter,
  }) async {
    final records = await store(t).find(db, finder: Finder(filter: filter));
    return records.map((r) => r.value).toList();
  }

  Stream<List<Map<String, Object?>>> watchAll(
    SyncedTable t, {
    Filter? filter,
  }) =>
      store(t)
          .query(finder: Finder(filter: filter))
          .onSnapshots(db)
          .map((rs) => rs.map((r) => r.value).toList());

  Future<List<RecordSnapshot<String, Map<String, Object?>>>> dirty(
    SyncedTable t,
  ) =>
      store(t)
          .find(db, finder: Finder(filter: Filter.equals(dirtyField, true)));

  Future<T?> getMeta<T>(String key) async =>
      await meta.record(key).get(db) as T?;
  Future<void> setMeta(String key, Object? value) =>
      meta.record(key).put(db, value);

  /// Wipes everything, used on sign-out so the next account starts clean.
  Future<void> clearAll() async {
    for (final t in syncedTables) {
      await store(t).delete(db);
    }
    await meta.delete(db);
  }
}

/// Strips local-only fields before a record is uploaded.
Map<String, Object?> forUpload(Map<String, Object?> row) =>
    Map.of(row)..remove(LocalDb.dirtyField);
