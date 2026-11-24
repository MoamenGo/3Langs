import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/env.dart';
import 'core/providers.dart';
import 'core/theme.dart';
import 'data/local/local_db.dart';
import 'data/local/migrations.dart';
import 'data/repositories/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Env.hasSupabase) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabasePublishableKey,
    );
  }
  final db = await LocalDb.open();
  await LocalMigrations(db).run();

  // Read the look before the first frame so the app opens in its theme.
  final startup = StartupState(
    settings: await SettingsRepository(db).get(),
    appTheme: AppTheme.parse(await db.getMeta<String>('theme')),
    themeMode: AppTheme.parseMode(await db.getMeta<String>('theme_mode')),
  );

  runApp(
    ProviderScope(
      overrides: [
        localDbProvider.overrideWithValue(db),
        startupStateProvider.overrideWithValue(startup),
      ],
      child: const ThreeLangApp(),
    ),
  );
}
