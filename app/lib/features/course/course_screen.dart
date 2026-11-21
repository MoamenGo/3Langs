import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../data/models/learner.dart';
import '../../data/repositories/content_repository.dart';

/// The whole 24-month path, A1 to C1. Levels with content in this build open
/// their units; the rest show the planned themes.
class CourseScreen extends ConsumerWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = ref.watch(explainLangProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.courseTimeline)),
      body: AsyncView(
        value: ref.watch(outlineProvider),
        builder: (levels) => ListView(
          padding: const EdgeInsets.all(12),
          children: [
            for (final level in levels)
              Card(
                child: ExpansionTile(
                  initiallyExpanded: level.id == 'A1',
                  leading: CircleAvatar(child: Text(level.id)),
                  title: Text(level.title.get(lang)),
                  subtitle: Text(
                    '${l.monthsRange(level.months.first, level.months.last)} · ${l.hoursShort(level.targetHours)}',
                  ),
                  children: ContentRepository.bundledLevels.contains(level.id)
                      ? [_LevelUnits(levelId: level.id)]
                      : [
                          for (final (i, theme) in level.unitThemes.indexed)
                            ListTile(
                              dense: true,
                              enabled: false,
                              title: Text(
                                '${l.unitN(i + 1)} · ${theme.get(lang)}',
                              ),
                              trailing: Text(l.comingSoon),
                            ),
                        ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LevelUnits extends ConsumerWidget {
  const _LevelUnits({required this.levelId});
  final String levelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = ref.watch(explainLangProvider);
    final progress = ref.watch(lessonProgressProvider).value ?? const {};
    return AsyncView<LevelContent>(
      value: ref.watch(levelContentProvider(levelId)),
      builder: (c) => Column(
        children: [
          for (final unit in c.units)
            Builder(
              builder: (context) {
                final done = unit.lessonIds
                    .where(
                      (id) => progress[id]?.status == LessonStatus.completed,
                    )
                    .length;
                return ListTile(
                  title: Text(
                    '${l.unitN(unit.order)} · ${unit.theme.get(lang)}',
                  ),
                  subtitle: LinearProgressIndicator(
                    value: unit.lessonIds.isEmpty
                        ? 0
                        : done / unit.lessonIds.length,
                  ),
                  trailing: Text('$done/${unit.lessonIds.length}'),
                  onTap: () =>
                      context.go('/course/unit/${unit.id}?level=$levelId'),
                );
              },
            ),
        ],
      ),
    );
  }
}
