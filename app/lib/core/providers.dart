// Dependency wiring with Riverpod. Screens read these providers instead of
// creating repositories themselves, which keeps them easy to test.

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/local/local_db.dart';
import '../data/models/content.dart';
import '../data/models/learner.dart';
import '../data/repositories/content_repository.dart';
import '../data/repositories/progress_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/srs_repository.dart';
import '../data/repositories/writing_repository.dart';
import '../data/sync/sync_service.dart';
import '../services/language_tool_service.dart';
import '../services/tts_service.dart';
import '../srs/fsrs.dart';
import 'env.dart';

/// Opened in main() before the app starts, then injected with an override.
final localDbProvider = Provider<LocalDb>(
  (ref) => throw UnimplementedError('override localDbProvider in main()'),
);

final supabaseProvider = Provider<SupabaseClient?>(
  (ref) => Env.hasSupabase ? Supabase.instance.client : null,
);

final contentRepositoryProvider = Provider(
  (ref) => ContentRepository(rootBundle),
);

final settingsRepositoryProvider = Provider(
  (ref) => SettingsRepository(ref.watch(localDbProvider)),
);

final settingsProvider = StreamProvider<UserSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

/// Explanation language, defaulting to English while settings load.
final explainLangProvider = Provider<ExplainLang>(
  (ref) =>
      ref.watch(settingsProvider).value?.explanationLanguage ?? ExplainLang.en,
);

final srsRepositoryProvider = Provider((ref) {
  final retention = ref.watch(settingsProvider).value?.desiredRetention ?? 0.9;
  return SrsRepository(
    ref.watch(localDbProvider),
    fsrs: Fsrs(desiredRetention: retention),
  );
});

final progressRepositoryProvider = Provider(
  (ref) => ProgressRepository(ref.watch(localDbProvider)),
);

final writingRepositoryProvider = Provider(
  (ref) => WritingRepository(ref.watch(localDbProvider)),
);

final syncServiceProvider = Provider((ref) {
  final service = SyncService(
    ref.watch(localDbProvider),
    ref.watch(supabaseProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

final ttsProvider = Provider((ref) => TtsService());
final languageToolProvider = Provider((ref) => LanguageToolService());

// ---- Content -------------------------------------------------------------

final levelContentProvider = FutureProvider.family<LevelContent, String>(
  (ref, levelId) => ref.watch(contentRepositoryProvider).level(levelId),
);

final outlineProvider = FutureProvider<List<OutlineLevel>>(
  (ref) => ref.watch(contentRepositoryProvider).outline(),
);

/// Every vocab item and sentence from all bundled levels, for review screens.
final allContentProvider = FutureProvider<List<LevelContent>>(
  (ref) => ref.watch(contentRepositoryProvider).allAvailable(),
);

// ---- Progress ------------------------------------------------------------

final lessonProgressProvider = StreamProvider<Map<String, LessonProgress>>(
  (ref) => ref.watch(progressRepositoryProvider).watchLessons(),
);

final studyStatsProvider = StreamProvider<StudyStats>(
  (ref) => ref.watch(progressRepositoryProvider).watchStats(),
);

final dueCountProvider = StreamProvider<int>(
  (ref) => ref.watch(srsRepositoryProvider).watchDueCount(),
);

final authUserProvider = StreamProvider<User?>((ref) {
  final client = ref.watch(supabaseProvider);
  if (client == null) return Stream.value(null);
  return client.auth.onAuthStateChange
      .map((s) => s.session?.user)
      .startWithValue(client.auth.currentUser);
});

extension _StartWith<T> on Stream<T> {
  Stream<T> startWithValue(T value) async* {
    yield value;
    yield* this;
  }
}
