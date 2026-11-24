// Today's study plan: built once a day by the SessionPlanner, saved on the
// device so an interrupted day picks up where it stopped.

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/lang/lang.dart';
import '../../core/providers.dart';
import '../../data/models/learner.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/repositories/interference_repository.dart';
import '../../data/repositories/progress_repository.dart';
import '../../domain/scheduling/session_planner.dart';

String _planKey(String day) => 'plan:$day';
String _doneKey(String day) => 'plan_done:$day';

String todayKey([DateTime? now]) =>
    ProgressRepository.localDay(now ?? DateTime.now());

Map<String, Object?> blockToJson(SessionBlock b) => {
  'kind': b.kind.name,
  'lang': b.lang?.name,
  'minutes': b.minutes,
  'lessonId': b.lessonId,
  'skill': b.skill?.name,
};

SessionBlock blockFromJson(Map<String, Object?> j) => SessionBlock(
  kind: BlockKind.values.byName(j['kind'] as String),
  lang: Lang.tryParse(j['lang'] as String?),
  minutes: j['minutes'] as int,
  lessonId: j['lessonId'] as String?,
  skill: j['skill'] == null ? null : SkillKind.values.byName(j['skill'] as String),
);

/// Builds today's plan from the tracks, due cards, next lessons and recent
/// mix-ups. Reuses the plan saved earlier today when there is one.
final todayPlanProvider = FutureProvider<SessionPlan>((ref) async {
  final db = ref.watch(localDbProvider);
  final day = todayKey();
  final saved = await db.getMeta<String>(_planKey(day));
  final now = DateTime.now();
  if (saved != null) {
    final j = jsonDecode(saved) as Map<String, dynamic>;
    return SessionPlan(
      day: DateTime(now.year, now.month, now.day),
      blocks: [
        for (final b in j['blocks'] as List)
          blockFromJson(Map<String, Object?>.from(b as Map)),
      ],
      newCardLimit: {
        for (final e in (j['newCardLimit'] as Map).entries)
          if (Lang.tryParse(e.key as String) case final l?) l: e.value as int,
      },
    );
  }

  final tracks = await ref.read(trackRepositoryProvider).all();
  final settings = await ref.read(settingsRepositoryProvider).get();
  final due = await ref.read(srsRepositoryProvider).dueCards(newLimit: 0);
  final progress = await ref.read(progressRepositoryProvider).watchLessons().first;
  final events = await ref.read(interferenceRepositoryProvider).all();
  final content = ref.read(contentRepositoryProvider);

  final langs = <LangDay>[];
  for (final lang in Lang.values) {
    final t = tracks[lang]!;
    final active = t.status != TrackStatus.paused && t.isActiveOn(now.toUtc());
    String? next;
    final level = ContentRepository.packLevelFor(lang, t.currentLevel);
    if (active && level != null) {
      final pack = await content.level(lang, level);
      next = nextLessonIn(pack, progress)?.id;
    }
    langs.add(
      LangDay(
        lang: lang,
        active: active,
        share: t.timeShare,
        dueCards: due.where((c) => c.cardId.startsWith('${lang.name}.')).length,
        newCardsPerDay: t.newCardsPerDay,
        nextLessonId: next,
        lessonsDone: progress.values
            .where(
              (p) =>
                  p.status == LessonStatus.completed &&
                  p.lessonId.startsWith('${lang.name}.'),
            )
            .length,
      ),
    );
  }
  final plan = const SessionPlanner().plan(
    day: now,
    minutes: settings.dailyGoalMinutes,
    langs: langs,
    interferenceThisWeek: eventsThisWeek(events, now.toUtc()),
  );
  await db.setMeta(
    _planKey(day),
    jsonEncode({
      'blocks': [for (final b in plan.blocks) blockToJson(b)],
      'newCardLimit': {
        for (final e in plan.newCardLimit.entries) e.key.name: e.value,
      },
    }),
  );
  return plan;
});

/// Block ids finished today.
final doneBlocksProvider = StreamProvider<Set<String>>((ref) {
  final db = ref.watch(localDbProvider);
  return db
      .watchMeta(_doneKey(todayKey()))
      .map((v) => v == null ? <String>{} : (v as List).cast<String>().toSet());
});

Future<void> markBlockDone(WidgetRef ref, SessionBlock block) async {
  final db = ref.read(localDbProvider);
  final key = _doneKey(todayKey());
  final done = ((await db.getMeta<List>(key)) ?? const []).cast<String>().toSet()
    ..add(block.id);
  await db.setMeta(key, done.toList());
}

/// Throws away today's plan (after changing languages or minutes).
Future<void> rebuildTodayPlan(WidgetRef ref) async {
  await ref.read(localDbProvider).deleteMeta(_planKey(todayKey()));
  ref.invalidate(todayPlanProvider);
}
