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
import 'features/polyglot/controller.dart';
import 'features/polyglot/storage.dart';

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

  // The Polyglot Matrix restyle (2026-11-25) makes its theme the default
  // once for everyone; a theme picked after that is kept.
  if (await db.getMeta<int>('look_version') != 2) {
    await db.setMeta('theme', 'matrix');
    await db.setMeta('look_version', 2);
  }

  // Read the look before the first frame so the app opens in its theme.
  final startup = StartupState(
    settings: await SettingsRepository(db).get(),
    appTheme: AppTheme.parse(await db.getMeta<String>('theme')),
    themeMode: AppTheme.parseMode(await db.getMeta<String>('theme_mode')),
    glass: await db.getMeta<bool>('glass') == true,
  );

  final polyglot = await PolyglotStore.open(db);

  runApp(
    ProviderScope(
      overrides: [
        localDbProvider.overrideWithValue(db),
        startupStateProvider.overrideWithValue(startup),
        polyglotStoreProvider.overrideWithValue(polyglot),
      ],
      child: const ThreeLangApp(),
    ),
  );
}
