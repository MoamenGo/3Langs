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
import '../polyglot/ui.dart' show TrX;
import 'plan_explainer.dart';
import 'today_plan.dart';
import '../../core/bidi.dart';

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
        title: BidiText(l.navToday),
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
                  title: BidiText(l.welcomeTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BidiText(l.welcomeSubtitle),
                      const SizedBox(height: 8),
                      FilledButton(
                        key: const ValueKey('setup'),
                        onPressed: () => context.push('/welcome'),
                        child: BidiText(l.setUp),
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
                        BidiText(
                          l.streakDays(stats?.streakDays ?? 0),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    BidiText(l.todayGoal(minutes, goal)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (minutes / goal).clamp(0, 1).toDouble(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const PlanExplainer(),
            const SizedBox(height: 8),
            _PlanSection(todayPlan: plan, todayDone: done),
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

/// Today's plan, or an earlier day's when you go back with the arrows to
/// catch up on what you missed.
class _PlanSection extends ConsumerStatefulWidget {
  const _PlanSection({required this.todayPlan, required this.todayDone});
  final AsyncValue<SessionPlan> todayPlan;
  final Set<String> todayDone;

  @override
  ConsumerState<_PlanSection> createState() => _PlanSectionState();
}

class _PlanSectionState extends ConsumerState<_PlanSection> {
  /// How many days back from today (0 = today).
  int _back = 0;
  static const maxBack = 14;

  String _label(BuildContext context, DateTime d) {
    if (_back == 0) return context.tr('Today', 'النهاردة');
    if (_back == 1) return context.tr('Yesterday', 'امبارح');
    return formatDay(d);
  }

  @override
  Widget build(BuildContext context) {
    final day = dayBefore(_back);
    final nav = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back in time is "previous": the arrow points to the reading start.
        TextButton.icon(
          key: const ValueKey('plan-prev'),
          onPressed: _back >= maxBack ? null : () => setState(() => _back++),
          icon: const Icon(Icons.chevron_left),
          label: BidiText(context.tr('Previous day', 'اليوم اللي قبله')),
        ),
        BidiText(
          _label(context, day),
          key: const ValueKey('plan-day'),
          style: Theme.of(context).textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        TextButton.icon(
          key: const ValueKey('plan-next'),
          onPressed: _back == 0 ? null : () => setState(() => _back--),
          icon: const Icon(Icons.chevron_right),
          label: BidiText(context.tr('Next day', 'اليوم اللي بعده')),
        ),
      ],
    );
    if (_back == 0) {
      return AsyncView(
        value: widget.todayPlan,
        builder: (p) => _PlanCard(plan: p, done: widget.todayDone, nav: nav),
      );
    }
    final key = todayKey(day);
    final plan = ref.watch(pastPlanProvider(key));
    final done = ref.watch(doneBlocksOnProvider(key)).value ?? const {};
    return AsyncView(
      value: plan,
      builder: (p) => p == null
          ? Card(
              key: const ValueKey('plan-none'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    nav,
                    const SizedBox(height: 8),
                    BidiText(
                      context.tr(
                        'No tasks were saved for this day: the app was not opened.',
                        'مفيش مهام محفوظة لليوم ده، لأن التطبيق ماتفتحش فيه.',
                      ),
                    ),
                  ],
                ),
              ),
            )
          : _PlanCard(
              plan: p,
              done: done,
              nav: nav,
              day: key,
              dayLabel: _label(context, day),
            ),
    );
  }
}

class _PlanCard extends ConsumerWidget {
  const _PlanCard({
    required this.plan,
    required this.done,
    required this.nav,
    this.day,
    this.dayLabel,
  });
  final SessionPlan plan;
  final Set<String> done;
  final Widget nav;

  /// Set for an earlier day (as from [todayKey]); null for today.
  final String? day;
  final String? dayLabel;

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: nav,
            ),
            ListTile(
              title: BidiText(
                day == null
                    ? l.todaysPlan
                    : context.tr('Tasks: $dayLabel', 'مهام $dayLabel'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: BidiText(l.planMinutes(plan.totalMinutes, left)),
              trailing: day != null
                  ? null
                  : IconButton(
                      tooltip: l.rebuildPlan,
                      icon: const Icon(Icons.refresh),
                      onPressed: () => rebuildTodayPlan(ref),
                    ),
            ),
            if (plan.blocks.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: BidiText(l.planEmpty),
              ),
            for (final (i, b) in plan.blocks.indexed)
              _BlockTile(
                key: ValueKey('block-${b.id}'),
                index: i + 1,
                block: b,
                done: done.contains(b.id),
                day: day,
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: next == null
                  ? Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: BidiText(
                            day == null
                                ? l.planDone
                                : context.tr(
                                    'You finished this day.',
                                    'خلّصت مهام اليوم ده.',
                                  ),
                          ),
                        ),
                      ],
                    )
                  : FilledButton.icon(
                      key: const ValueKey('continue-plan'),
                      icon: const Icon(Icons.play_arrow),
                      label: BidiText(
                        day != null
                            ? context.tr(
                                'Catch up on what you missed',
                                'كمّل اللي فاتك',
                              )
                            : done.isEmpty
                            ? l.startPlan
                            : l.continuePlan,
                      ),
                      onPressed: () => runBlock(context, ref, next, day: day),
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
    this.day,
  });
  final int index;
  final SessionBlock block;
  final bool done;
  final String? day;

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
      title: BidiText(
        title,
        style: done
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      subtitle: subtitle == null ? null : BidiText(subtitle),
      trailing: BidiText(l.minutesShort(block.minutes)),
      onTap: () => runBlock(context, ref, block, day: day),
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
  SessionBlock block, {
  String? day,
}) async {
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
  await markBlockDone(ref, block, day: day);
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
        BidiText(
          l.yourLanguages,
          style: Theme.of(context).textTheme.titleMedium,
        ),
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
                    child: BidiText(l.startLevel(up)),
                  );
                }
              }
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: lang.color,
                    foregroundColor: Colors.white,
                    child: BidiText(lang.code),
                  ),
                  title: BidiText(
                    '${lang.displayName(ui)} · ${t.currentLevel}',
                  ),
                  subtitle: BidiText(subtitle),
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
