// Dependency wiring with Riverpod. Screens read these providers instead of
// creating repositories themselves, which keeps them easy to test.

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/local/local_db.dart';
import '../data/models/content.dart';
import '../data/models/contrast.dart';
import '../data/models/learner.dart';
import '../data/repositories/assessment_repository.dart';
import '../data/repositories/content_repository.dart';
import '../data/repositories/interference_repository.dart';
import '../data/repositories/progress_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/srs_repository.dart';
import '../data/repositories/track_repository.dart';
import '../data/repositories/writing_repository.dart';
import '../data/sync/sync_service.dart';
import '../domain/interference/interference_detector.dart';
import '../services/language_tool_service.dart';
import '../services/tts_service.dart';
import '../srs/fsrs.dart';
import 'env.dart';
import 'lang/lang.dart';
import 'theme.dart';

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

/// Settings and look read once before the first frame (see `main.dart`), so
/// the app opens in the learner's theme and language instead of switching a
/// moment later when the database streams answer.
class StartupState {
  const StartupState({
    this.settings,
    this.appTheme = AppTheme.lagoon,
    this.themeMode = ThemeMode.system,
    this.glass = false,
  });
  final UserSettings? settings;
  final AppTheme appTheme;
  final ThemeMode themeMode;

  /// The frosted glass style, which works with every colour theme.
  final bool glass;
}

final startupStateProvider = Provider<StartupState>(
  (ref) => const StartupState(),
);

/// Current settings, falling back to the ones read at startup.
final currentSettingsProvider = Provider<UserSettings?>(
  (ref) =>
      ref.watch(settingsProvider).value ??
      ref.watch(startupStateProvider).settings,
);

/// Explanation language, defaulting to Arabic while settings load.
final explainLangProvider = Provider<ExplainLang>(
  (ref) =>
      ref.watch(currentSettingsProvider)?.explanationLanguage ?? ExplainLang.ar,
);

/// Interface language code (ar or en).
final uiLanguageProvider = Provider<String>(
  (ref) => ref.watch(settingsProvider).value?.uiLanguage ?? 'ar',
);

/// The language on screen now (switched from the bar at the top).
final activeLangProvider = Provider<Lang>(
  (ref) => ref.watch(currentSettingsProvider)?.activeLanguage ?? Lang.de,
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

final ttsProvider = Provider((ref) {
  final tts = TtsService();
  ref.listen(
    humanVoiceProvider,
    (_, v) => tts.humanVoice = v.value ?? true,
    fireImmediately: true,
  );
  return tts;
});

/// Play native-speaker recordings for words (on by default).
final humanVoiceProvider = StreamProvider<bool>(
  (ref) => ref
      .watch(localDbProvider)
      .watchMeta('human_voice')
      .map((v) => v != false),
);
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

// ---- Phase 3: daily plan, interference, assessments ----------------------

final dueByLangProvider = StreamProvider<Map<Lang, int>>(
  (ref) => ref.watch(srsRepositoryProvider).watchDueByLang(),
);

final interferenceRepositoryProvider = Provider(
  (ref) => InterferenceRepository(ref.watch(localDbProvider)),
);

final interferenceEventsProvider = StreamProvider<List<InterferenceEvent>>(
  (ref) => ref.watch(interferenceRepositoryProvider).watch(),
);

final assessmentRepositoryProvider = Provider(
  (ref) => AssessmentRepository(ref.watch(localDbProvider)),
);

final assessmentsProvider = StreamProvider<List<LevelAssessment>>(
  (ref) => ref.watch(assessmentRepositoryProvider).watch(),
);

/// Spots answers that came from another language.
final interferenceDetectorProvider = FutureProvider<InterferenceDetector>((
  ref,
) async {
  final concepts = await ref.watch(conceptIndexProvider.future);
  final contrast = await ref.watch(contrastProvider.future);
  return InterferenceDetector(concepts: concepts, contrast: contrast);
});

/// Checks a wrong answer and saves a mix-up if it came from another language.
/// Returns the language it came from, for a hint on screen.
Future<Lang?> reportWrongAnswer(
  WidgetRef ref,
  VocabItem target,
  String given,
) async {
  final lang = target.lang;
  if (lang == null) return null;
  final detector = await ref.read(interferenceDetectorProvider.future);
  final match = detector.check(target, given);
  if (match == null) return null;
  await ref
      .read(interferenceRepositoryProvider)
      .record(lang: lang, match: match, expected: target.display, given: given);
  ref.read(syncServiceProvider).schedule();
  return match.otherLang;
}

/// The first lesson not completed yet in a pack, in course order.
Lesson? nextLessonIn(LevelContent c, Map<String, LessonProgress> progress) {
  for (final unit in c.units) {
    for (final lesson in c.lessonsOf(unit)) {
      if (progress[lesson.id]?.status != LessonStatus.completed) {
        return lesson;
      }
    }
  }
  return null;
}

/// Sets a language's level (after an exam or the placement test) and saves
/// the track.
Future<void> setTrackLevel(WidgetRef ref, Lang lang, String level) async {
  final tracks = await ref.read(trackRepositoryProvider).all();
  final track = tracks[lang]!;
  await ref
      .read(trackRepositoryProvider)
      .save(
        track.copyWith(
          currentLevel: level,
          status: track.status == TrackStatus.scheduled
              ? TrackStatus.active
              : null,
          startDate: track.status == TrackStatus.scheduled
              ? DateTime.now().toUtc()
              : null,
        ),
      );
  ref.read(syncServiceProvider).schedule();
}

/// False until the first-run setup (languages, minutes, placement) is done.
final onboardedProvider = StreamProvider<bool>(
  (ref) =>
      ref.watch(localDbProvider).watchMeta('onboarded').map((v) => v == true),
);

/// Colour theme and light/dark mode, kept on this device only.
final appThemeProvider = StreamProvider<AppTheme>(
  (ref) => ref.watch(localDbProvider).watchMeta('theme').map(AppTheme.parse),
);
final glassProvider = StreamProvider<bool>(
  (ref) => ref.watch(localDbProvider).watchMeta('glass').map((v) => v == true),
);
final themeModeProvider = StreamProvider<ThemeMode>(
  (ref) => ref
      .watch(localDbProvider)
      .watchMeta('theme_mode')
      .map(AppTheme.parseMode),
);
