// One-time upgrades of data saved by older builds.
//
// Version 2 (three languages): content ids gained a language prefix
// (`a1.vocab.haus` became `de.a1.vocab.haus`), Dutch and Spanish stopped
// being explanation languages, and every learner got one track per language.

import 'package:sembast/sembast.dart';

import '../../core/lang/lang.dart';
import '../models/learner.dart';
import 'local_db.dart';

const localSchemaVersion = 2;
const _versionKey = 'local_schema_version';

/// Columns that hold a content id, per table.
const _idColumns = {
  'card_states': 'card_id',
  'review_logs': 'card_id',
  'lesson_progress': 'lesson_id',
  'writing_submissions': 'prompt_id',
};

/// Rewrites legacy content ids in one row, used for local data and for rows
/// pulled from a server that has not been migrated yet.
Map<String, Object?> migrateLegacyRow(SyncedTable t, Map<String, Object?> row) {
  final column = _idColumns[t.name];
  final value = column == null ? null : row[column];
  if (value is! String) return row;
  final migrated = ContentId.migrateLegacy(value);
  return migrated == value ? row : {...row, column!: migrated};
}

class LocalMigrations {
  LocalMigrations(this.local);
  final LocalDb local;

  Future<void> run({DateTime? now}) async {
    final version = await local.getMeta<int>(_versionKey) ?? 1;
    if (version < 2) await _toV2(now ?? DateTime.now().toUtc());
    await ensureTracks(now ?? DateTime.now().toUtc());
    await local.setMeta(_versionKey, localSchemaVersion);
  }

  Future<void> _toV2(DateTime now) async {
    final db = local.db;
    await db.transaction((txn) async {
      for (final t in LocalDb.syncedTables) {
        final column = _idColumns[t.name];
        if (column == null) continue;
        final store = local.store(t);
        for (final r in await store.find(txn)) {
          final row = migrateLegacyRow(t, r.value);
          if (identical(row, r.value)) continue;
          if (t.keyColumn == column) {
            // The id is the record key: move the record to its new key and
            // let the next sync upload it under that key.
            await store.record(r.key).delete(txn);
            await store.record(row[column]! as String).put(txn, {
              ...row,
              LocalDb.dirtyField: true,
            });
          } else {
            await store.record(r.key).put(txn, row);
          }
        }
      }
    });

    // Settings: keep German's level as the German track's level.
    final settings = await local.get(LocalDb.userSettings, 'me');
    final oldLevel = settings?['current_level'] as String?;
    if (oldLevel != null) {
      final de = LanguageTrack.defaultFor(
        Lang.de,
        now,
      ).copyWith(currentLevel: oldLevel);
      await local.putLocal(LocalDb.languageTracks, 'de', de.toJson());
    }
    if (settings != null) {
      final normalised = UserSettings.fromJson(settings).toJson();
      final changed =
          normalised['ui_language'] != settings['ui_language'] ||
          normalised['explanation_language'] !=
              settings['explanation_language'];
      await local.store(LocalDb.userSettings).record('me').put(local.db, {
        ...normalised,
        if (!changed) 'updated_at': settings['updated_at'],
        LocalDb.dirtyField: changed || settings[LocalDb.dirtyField] == true,
      });
    }
  }

  /// Every language gets a track, following the default start plan.
  Future<void> ensureTracks(DateTime now) async {
    for (final lang in Lang.values) {
      final existing = await local.get(LocalDb.languageTracks, lang.name);
      if (existing != null) continue;
      await local.store(LocalDb.languageTracks).record(lang.name).put(
        local.db,
        // Not dirty: defaults are not worth uploading until changed, and a
        // track pulled from another device should win over them.
        {
          ...LanguageTrack.defaultFor(lang, now).toJson(),
          LocalDb.dirtyField: false,
        },
      );
    }
  }
}

/// Filter for records of one language, by content id prefix.
Filter langFilter(String column, Lang lang) =>
    Filter.matches(column, '^${lang.name}\\.');
