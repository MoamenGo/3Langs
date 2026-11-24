import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../data/models/learner.dart';
import '../../data/repositories/content_repository.dart';
import '../../core/bidi.dart';

/// The shared A0 to C1 path in the language on screen. Each level lists the
/// units of the shared syllabus; where this language has a pack in this
/// build the units open, the rest show their planned themes.
class CourseScreen extends ConsumerWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = ref.watch(explainLangProvider);
    final track = ref.watch(activeTrackProvider);
    return Scaffold(
      appBar: AppBar(
        title: BidiText(l.courseTimeline),
        actions: const [LangSwitcher()],
      ),
      body: AsyncView(
        value: ref.watch(outlineProvider),
        builder: (levels) => ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _TrackHeader(track: track),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: BidiText(
                l.sameForAllLanguages,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            for (final level in levels)
              Card(
                child: ExpansionTile(
                  initiallyExpanded:
                      level.id ==
                      ContentRepository.packLevelFor(
                        track.lang,
                        track.currentLevel,
                      ),
                  leading: CircleAvatar(
                    backgroundColor: track.lang.color.withValues(alpha: 0.15),
                    child: BidiText(level.id),
                  ),
                  title: BidiText(level.title.get(lang)),
                  subtitle: BidiText(
                    '${l.unitsCount(level.unitIds.length)} · ${l.hoursShort(level.targetHours)}',
                  ),
                  children: ContentRepository.hasPack(track.lang, level.id)
                      ? [
                          _LevelUnits(
                            key: ValueKey('${track.lang.name}-${level.id}'),
                            levelId: level.id,
                          ),
                        ]
                      : [
                          for (final (i, theme) in level.unitThemes.indexed)
                            ListTile(
                              dense: true,
                              enabled: false,
                              title: BidiText(
                                '${l.unitN(i + 1)} · ${theme.get(lang)}',
                              ),
                              trailing: BidiText(l.comingSoon),
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

/// The language on screen: its level and where its plan stands.
class _TrackHeader extends ConsumerWidget {
  const _TrackHeader({required this.track});
  final LanguageTrack track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ui = ref.watch(uiLanguageProvider);
    final active = track.isActiveOn(DateTime.now().toUtc());
    return Card(
      color: track.lang.color.withValues(alpha: 0.10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: track.lang.color,
          foregroundColor: Colors.white,
          child: BidiText(track.lang.code),
        ),
        title: BidiText(
          track.lang.displayName(ui),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: BidiText(
          '${l.levelN(track.currentLevel)} · ${active
              ? l.trackActive
              : track.status == TrackStatus.paused
              ? l.trackPaused
              : l.trackScheduled(formatDay(track.startDate!))}',
        ),
      ),
    );
  }
}

class _LevelUnits extends ConsumerWidget {
  const _LevelUnits({super.key, required this.levelId});
  final String levelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = ref.watch(explainLangProvider);
    final target = ref.watch(activeLangProvider);
    final progress = ref.watch(lessonProgressProvider).value ?? const {};
    return AsyncView<LevelContent>(
      value: ref.watch(levelContentProvider((lang: target, level: levelId))),
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
                  title: BidiText(
                    '${l.unitN(unit.order)} · ${unit.theme.get(lang)}',
                  ),
                  subtitle: LinearProgressIndicator(
                    value: unit.lessonIds.isEmpty
                        ? 0
                        : done / unit.lessonIds.length,
                  ),
                  trailing: BidiText('$done/${unit.lessonIds.length}'),
                  onTap: () => context.go('/course/unit/${unit.id}'),
                );
              },
            ),
        ],
      ),
    );
  }
}
