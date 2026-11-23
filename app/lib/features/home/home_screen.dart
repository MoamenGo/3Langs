import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../data/repositories/content_repository.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../data/models/learner.dart';
import '../course/lesson_type_ui.dart';

/// Today at a glance: goal, streak, due flashcards and the next lesson.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final settings = ref.watch(settingsProvider).value;
    final stats = ref.watch(studyStatsProvider).value;
    final due = ref.watch(dueCountProvider).value ?? 0;
    final content = ref.watch(activeContentProvider);
    final progress = ref.watch(lessonProgressProvider).value ?? const {};
    final lang = ref.watch(explainLangProvider);
    final goal = settings?.dailyGoalMinutes ?? 120;
    final minutes = stats?.minutesToday ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          const LangSwitcher(),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l.settings,
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
          Card(
            child: ListTile(
              leading: const Icon(Icons.style),
              title: Text(l.flashcards),
              subtitle: Text(l.cardsDue(due)),
              trailing: FilledButton(
                onPressed: due == 0 ? null : () => context.push('/review'),
                child: Text(l.startReview),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.continueLearning,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          AsyncView(
            value: content,
            builder: (c) {
              if (c == null) return const NoContentYet();
              final next = _nextLesson(c, progress);
              if (next == null) {
                final up = ContentRepository.nextPackLevel(c.lang, c.level.id);
                if (up == null) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l.allLessonsDone),
                  );
                }
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.emoji_events),
                    title: Text(l.levelDone(c.level.id)),
                    trailing: FilledButton(
                      key: const ValueKey('next-level'),
                      onPressed: () => advanceLevel(ref),
                      child: Text(l.startLevel(up)),
                    ),
                  ),
                );
              }
              final unit = c.units.firstWhere((u) => u.id == next.unitId);
              return Card(
                child: ListTile(
                  leading: Icon(next.type.icon),
                  title: Text(next.title.get(lang)),
                  subtitle: Text(
                    '${l.unitN(unit.order)} · ${unit.theme.get(lang)}',
                  ),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () => context.push('/lesson/${next.id}'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Lesson? _nextLesson(LevelContent c, Map<String, LessonProgress> progress) {
    for (final unit in c.units) {
      for (final lesson in c.lessonsOf(unit)) {
        if (progress[lesson.id]?.status != LessonStatus.completed) {
          return lesson;
        }
      }
    }
    return null;
  }
}
