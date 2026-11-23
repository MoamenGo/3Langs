// Dependency wiring with Riverpod. Screens read these providers instead of
// creating repositories themselves, which keeps them easy to test.

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/local/local_db.dart';
import '../data/models/content.dart';
import '../data/models/contrast.dart';
import '../data/models/learner.dart';
import '../data/repositories/content_repository.dart';
import '../data/repositories/progress_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/srs_repository.dart';
import '../data/repositories/track_repository.dart';
import '../data/repositories/writing_repository.dart';
import '../data/sync/sync_service.dart';
import '../services/language_tool_service.dart';
import '../services/tts_service.dart';
import '../srs/fsrs.dart';
import 'env.dart';
import 'lang/lang.dart';

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

/// Explanation language, defaulting to Arabic while settings load.
final explainLangProvider = Provider<ExplainLang>(
  (ref) =>
      ref.watch(settingsProvider).value?.explanationLanguage ?? ExplainLang.ar,
);

/// Interface language code (ar or en).
final uiLanguageProvider = Provider<String>(
  (ref) => ref.watch(settingsProvider).value?.uiLanguage ?? 'ar',
);

/// The language on screen now (switched from the bar at the top).
final activeLangProvider = Provider<Lang>(
  (ref) => ref.watch(settingsProvider).value?.activeLanguage ?? Lang.de,
);

final trackRepositoryProvider = Provider(
  (ref) => TrackRepository(ref.watch(localDbProvider)),
);

final tracksProvider = StreamProvider<Map<Lang, LanguageTrack>>(
  (ref) => ref.watch(trackRepositoryProvider).watch(),
);

/// Name of the language on screen, in the interface language.
final activeLangNameProvider = Provider<String>(
  (ref) =>
      ref.watch(activeLangProvider).displayName(ref.watch(uiLanguageProvider)),
);

/// The track of the language on screen.
final activeTrackProvider = Provider<LanguageTrack>((ref) {
  final lang = ref.watch(activeLangProvider);
  return ref.watch(tracksProvider).value?[lang] ??
      LanguageTrack.defaultFor(lang, DateTime.now().toUtc());
});

/// Makes [lang] the language on screen.
Future<void> switchLanguage(WidgetRef ref, Lang lang) async {
  final repo = ref.read(settingsRepositoryProvider);
  await repo.save((await repo.get()).copyWith(activeLanguage: lang));
}

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

/// Which pack to load: a language and a level.
typedef PackKey = ({Lang lang, String level});

final levelContentProvider = FutureProvider.family<LevelContent, PackKey>(
  (ref, key) => ref.watch(contentRepositoryProvider).level(key.lang, key.level),
);

/// The pack for a content id such as `de.a1.u03` or `de.a1.u03.l02`.
PackKey packKeyOf(String contentId) {
  final id = ContentId.parse(contentId);
  return (lang: id?.lang ?? Lang.de, level: id?.level ?? 'A1');
}

/// The pack to study now in the language on screen, or null when that
/// language has no content in this build yet.
final activeContentProvider = FutureProvider<LevelContent?>((ref) async {
  final track = ref.watch(activeTrackProvider);
  final level = ContentRepository.packLevelFor(track.lang, track.currentLevel);
  if (level == null) return null;
  return ref.watch(
    levelContentProvider((lang: track.lang, level: level)).future,
  );
});

final outlineProvider = FutureProvider<List<OutlineLevel>>(
  (ref) => ref.watch(contentRepositoryProvider).outline(),
);

/// Every vocab item and sentence from all bundled levels, for review screens.
final allContentProvider = FutureProvider<List<LevelContent>>(
  (ref) => ref.watch(contentRepositoryProvider).allAvailable(),
);

/// The contrast dictionary: false friends, near cognates, gender mismatches.
final contrastProvider = FutureProvider<List<ContrastEntry>>(
  (ref) => ref.watch(contentRepositoryProvider).contrast(),
);

/// Concept id -> the word for it in each language, across all bundled packs.
final conceptIndexProvider = FutureProvider<Map<String, Map<Lang, VocabItem>>>((
  ref,
) async {
  final packs = await ref.watch(allContentProvider.future);
  final index = <String, Map<Lang, VocabItem>>{};
  for (final pack in packs) {
    for (final word in pack.vocab.values) {
      final concept = word.conceptId;
      final lang = word.lang;
      if (concept == null || lang == null) continue;
      index.putIfAbsent(concept, () => {})[lang] = word;
    }
  }
  return index;
});

/// Moves the track on screen to its next bundled level (A0 -> A1).
Future<void> advanceLevel(WidgetRef ref) async {
  final track = ref.read(activeTrackProvider);
  final current =
      ContentRepository.packLevelFor(track.lang, track.currentLevel) ??
      track.currentLevel;
  final next = ContentRepository.nextPackLevel(track.lang, current);
  if (next == null) return;
  await ref
      .read(trackRepositoryProvider)
      .save(track.copyWith(currentLevel: next));
  ref.read(syncServiceProvider).schedule();
}

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
