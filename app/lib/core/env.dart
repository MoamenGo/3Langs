// Build-time configuration. Pass values with --dart-define, for example:
//   flutter run --dart-define=SUPABASE_URL=https://xyz.supabase.co \
//               --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_...
// Or put them in a file and use --dart-define-from-file=env.json (see
// env.example.json). Without Supabase values the app runs fully offline.

class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  /// Public LanguageTool API (free, about 20 requests a minute). Point this
  /// at a self-hosted LanguageTool server to remove the limit.
  static const languageToolUrl = String.fromEnvironment(
    'LANGUAGETOOL_URL',
    defaultValue: 'https://api.languagetool.org/v2',
  );

  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;
}
