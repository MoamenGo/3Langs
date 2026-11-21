import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/env.dart';
import 'core/providers.dart';
import 'data/local/local_db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Env.hasSupabase) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabasePublishableKey,
    );
  }
  final db = await LocalDb.open();

  runApp(
    ProviderScope(
      overrides: [localDbProvider.overrideWithValue(db)],
      child: const ThreeLangApp(),
    ),
  );
}
