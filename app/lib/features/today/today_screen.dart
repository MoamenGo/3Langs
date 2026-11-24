import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/lang/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/learner.dart';
import '../../data/repositories/content_repository.dart';
import '../../domain/scheduling/session_planner.dart';
import '../course/lesson_type_ui.dart';
import 'today_plan.dart';

/// "Today": the day's plan across the three languages, built by the
/// SessionPlanner. "Continue" walks you through it block by block, so you
/// never have to decide what to study next.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final settings = ref.watch(settingsProvider).value;
    final stats = ref.watch(studyStatsProvider).value;
    final plan = ref.watch(todayPlanProvider);
    final done = ref.watch(doneBlocksProvider).value ?? const <String>{};
    final onboarded = ref.watch(onboardedProvider).value ?? true;
    final goal = settings?.dailyGoalMinutes ?? 120;
    final minutes = stats?.minutesToday ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navToday),
        actions: [
          const LangSwitcher(),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l.settings,
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          final main = <Widget>[
            if (!onboarded)
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: ListTile(
                  leading: const Icon(Icons.waving_hand),
                  title: Text(l.welcomeTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.welcomeSubtitle),
                      const SizedBox(height: 8),
                      FilledButton(
                        key: const ValueKey('setup'),
                        onPressed: () => context.push('/welcome'),
                        child: Text(l.setUp),
                      ),
                    ],
                  ),
                ),
              ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l.streakDays(stats?.streakDays ?? 0),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(l.todayGoal(minutes, goal)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (minutes / goal).clamp(0, 1).toDouble(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            AsyncView(
              value: plan,
              builder: (p) => _PlanCard(plan: p, done: done),
            ),
          ];
          if (c.maxWidth < 900) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...main,
                const SizedBox(height: 8),
                const _LevelCards(),
              ],
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: main,
                  ),
                ),
                const SizedBox(width: 24),
                const Expanded(flex: 2, child: _LevelCards()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PlanCard extends ConsumerWidget {
  const _PlanCard({required this.plan, required this.done});
  final SessionPlan plan;
  final Set<String> done;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final next = plan.blocks.where((b) => !done.contains(b.id)).firstOrNull;
    final left = plan.blocks
        .where((b) => !done.contains(b.id))
        .fold<int>(0, (s, b) => s + b.minutes);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(
                l.todaysPlan,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(l.planMinutes(plan.totalMinutes, left)),
              trailing: IconButton(
                tooltip: l.rebuildPlan,
                icon: const Icon(Icons.refresh),
                onPressed: () => rebuildTodayPlan(ref),
              ),
            ),
            if (plan.blocks.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l.planEmpty),
              ),
            for (final (i, b) in plan.blocks.indexed)
              _BlockTile(
                key: ValueKey('block-${b.id}'),
                index: i + 1,
                block: b,
                done: done.contains(b.id),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: next == null
                  ? Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(l.planDone)),
                      ],
                    )
                  : FilledButton.icon(
                      key: const ValueKey('continue-plan'),
                      icon: const Icon(Icons.play_arrow),
                      label: Text(done.isEmpty ? l.startPlan : l.continuePlan),
                      onPressed: () => runBlock(context, ref, next),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData blockIcon(SessionBlock b) => switch (b.kind) {
  BlockKind.review => Icons.style,
  BlockKind.newLesson => Icons.school,
  BlockKind.contrast => Icons.compare_arrows,
  BlockKind.skill => switch (b.skill!) {
    SkillKind.listening => Icons.headphones,
    SkillKind.reading => Icons.menu_book,
    SkillKind.speaking => Icons.record_voice_over,
    SkillKind.writing => Icons.edit_note,
  },
};

class _BlockTile extends ConsumerWidget {
  const _BlockTile({
    super.key,
    required this.index,
    required this.block,
    required this.done,
  });
  final int index;
  final SessionBlock block;
  final bool done;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ui = ref.watch(uiLanguageProvider);
    final explain = ref.watch(explainLangProvider);
    final lang = block.lang;
    final langName = lang?.displayName(ui) ?? '';
    String title;
    String? subtitle;
    switch (block.kind) {
      case BlockKind.review:
        title = l.blockReview(langName);
        subtitle = l.cardsDue(ref.watch(dueByLangProvider).value?[lang] ?? 0);
      case BlockKind.newLesson:
        title = l.blockLesson(langName);
        final id = block.lessonId!;
        final pack = ref.watch(levelContentProvider(packKeyOf(id))).value;
        final lesson = pack?.lessons[id];
        if (lesson != null) {
          final unit = pack!.units.firstWhere((u) => u.id == lesson.unitId);
          subtitle =
              '${pack.level.id} · ${l.unitN(unit.order)} · ${lesson.title.get(explain)}';
        }
      case BlockKind.skill:
        title = '${skillName(context, block.skill!)} · $langName';
      case BlockKind.contrast:
        title = l.blockContrast;
        subtitle = l.blockContrastHint;
    }
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: done
            ? Colors.green
            : (lang?.color ?? Theme.of(context).colorScheme.tertiary),
        foregroundColor: Colors.white,
        child: done
            ? const Icon(Icons.check)
            : Icon(blockIcon(block), size: 20),
      ),
      title: Text(
        title,
        style: done
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: Text(l.minutesShort(block.minutes)),
      onTap: () => runBlock(context, ref, block),
    );
  }
}

String skillName(BuildContext context, SkillKind s) {
  final l = context.l10n;
  return switch (s) {
    SkillKind.listening => l.lessonListening,
    SkillKind.reading => l.lessonReading,
    SkillKind.speaking => l.lessonSpeaking,
    SkillKind.writing => l.lessonWriting,
  };
}

/// Opens one block of the plan, then marks it done when you come back.
/// A new lesson only counts once the lesson is completed.
Future<void> runBlock(
  BuildContext context,
  WidgetRef ref,
  SessionBlock block,
) async {
  if (block.lang != null) await switchLanguage(ref, block.lang!);
  if (!context.mounted) return;
  final route = switch (block.kind) {
    BlockKind.review => '/review?lang=${block.lang!.name}',
    BlockKind.newLesson => '/lesson/${block.lessonId}',
    BlockKind.contrast => '/review/contrast',
    BlockKind.skill => '/practice/${block.skill!.name}',
  };
  await context.push(route);
  if (block.kind == BlockKind.newLesson) {
    final progress = await ref
        .read(progressRepositoryProvider)
        .watchLessons()
        .first;
    if (progress[block.lessonId]?.status != LessonStatus.completed) return;
  }
  await markBlockDone(ref, block);
}

/// One line per language: level, next lesson, and the button to move on to
/// the next level once a level is finished.
class _LevelCards extends ConsumerWidget {
  const _LevelCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final tracks = ref.watch(tracksProvider).value;
    final progress = ref.watch(lessonProgressProvider).value ?? const {};
    final ui = ref.watch(uiLanguageProvider);
    final explain = ref.watch(explainLangProvider);
    if (tracks == null) return const SizedBox.shrink();
    final now = DateTime.now().toUtc();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.yourLanguages, style: Theme.of(context).textTheme.titleMedium),
        for (final lang in Lang.values)
          Builder(
            builder: (context) {
              final t = tracks[lang]!;
              final level = ContentRepository.packLevelFor(
                lang,
                t.currentLevel,
              );
              final pack = level == null
                  ? null
                  : ref
                        .watch(levelContentProvider((lang: lang, level: level)))
                        .value;
              final next = pack == null ? null : nextLessonIn(pack, progress);
              final started = t.isActiveOn(now);
              String subtitle;
              Widget? trailing;
              if (t.status == TrackStatus.paused) {
                subtitle = l.trackPaused;
              } else if (!started && t.startDate != null) {
                subtitle = l.startsOn(formatDay(t.startDate!));
              } else if (pack == null) {
                subtitle = '';
              } else if (next != null) {
                final unit = pack.units.firstWhere((u) => u.id == next.unitId);
                subtitle =
                    '${l.unitN(unit.order)} · ${next.title.get(explain)}';
                trailing = Icon(next.type.icon);
              } else {
                final up = ContentRepository.nextPackLevel(lang, pack.level.id);
                subtitle = up == null
                    ? l.allLessonsDone
                    : l.levelDone(pack.level.id);
                if (up != null) {
                  trailing = FilledButton(
                    key: ValueKey('next-level-${lang.name}'),
                    onPressed: () async {
                      await switchLanguage(ref, lang);
                      await advanceLevel(ref);
                    },
                    child: Text(l.startLevel(up)),
                  );
                }
              }
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: lang.color,
                    foregroundColor: Colors.white,
                    child: Text(lang.code),
                  ),
                  title: Text('${lang.displayName(ui)} · ${t.currentLevel}'),
                  subtitle: Text(subtitle),
                  trailing: trailing,
                  onTap: next == null || !started
                      ? null
                      : () async {
                          await switchLanguage(ref, lang);
                          if (context.mounted) {
                            context.push('/lesson/${next.id}');
                          }
                        },
                ),
              );
            },
          ),
      ],
    );
  }
}
