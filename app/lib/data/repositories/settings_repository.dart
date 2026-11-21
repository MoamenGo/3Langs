import 'package:sembast/sembast.dart';

import '../local/local_db.dart';
import '../models/learner.dart';

/// Settings are stored locally under one key and synced as the user's
/// single user_settings row.
class SettingsRepository {
  SettingsRepository(this.local);
  final LocalDb local;

  static const key = 'me';

  Stream<UserSettings> watch() => local
      .store(LocalDb.userSettings)
      .record(key)
      .onSnapshot(local.db)
      .map(
        (s) => s == null
            ? UserSettings(
                updatedAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
              )
            : UserSettings.fromJson(s.value),
      );

  Future<UserSettings> get() async {
    final row = await local.get(LocalDb.userSettings, key);
    return row == null
        ? UserSettings(
            updatedAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
          )
        : UserSettings.fromJson(row);
  }

  Future<void> save(UserSettings settings) =>
      local.putLocal(LocalDb.userSettings, key, settings.toJson());
}
