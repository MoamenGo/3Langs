import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/learner.dart';
import '../../data/repositories/progress_repository.dart';

final _knownWordsProvider = FutureProvider.autoDispose<int>((ref) {
  ref.watch(dueCountProvider); // refresh when cards change
  return ref.watch(srsRepositoryProvider).knownCount();
});

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final stats = ref.watch(studyStatsProvider).value;
    final settings = ref.watch(settingsProvider).value;
    final known = ref.watch(_knownWordsProvider).value ?? 0;
    final lessons = ref.watch(lessonProgressProvider).value ?? const {};
    final content = ref.watch(activeContentProvider).value;
    final goal = settings?.dailyGoalMinutes ?? 120;
    final done = lessons.values
        .where((p) => p.status == LessonStatus.completed)
        .length;
    final total = content?.lessons.length ?? 0;

    final today = DateTime.now();
    final week = [
      for (var i = 6; i >= 0; i--) today.subtract(Duration(days: i)),
    ];
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navProgress),
        actions: const [LangSwitcher()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _Stat(
                Icons.local_fire_department,
                l.streakDays(stats?.streakDays ?? 0),
              ),
              _Stat(
                Icons.timer,
                l.totalHours((stats?.totalHours ?? 0).toStringAsFixed(1)),
              ),
              _Stat(Icons.translate, l.wordsKnown(known)),
              _Stat(
                Icons.school,
                '${ref.watch(activeTrackProvider).currentLevel} · ${l.lessonsCompleted(done, total)}',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(l.last7Days, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final day in week)
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final minutes =
                            stats?.minutesByDay[ProgressRepository.localDay(
                              day,
                            )] ??
                            0;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$minutes',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              height: 110 * (minutes / goal).clamp(0.02, 1.0),
                              decoration: BoxDecoration(
                                color: minutes >= goal
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat.E(locale).format(day),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 170,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    ),
  );
}
