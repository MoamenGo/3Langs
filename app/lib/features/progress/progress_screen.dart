import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import 'package:sembast/sembast.dart' show Filter;

import '../../core/lang/lang.dart';
import '../../data/local/local_db.dart';
import '../../data/models/content.dart';
import '../../data/models/learner.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/repositories/progress_repository.dart';

final _knownWordsProvider = FutureProvider.autoDispose<int>((ref) {
  ref.watch(dueCountProvider); // refresh when cards change
  return ref.watch(srsRepositoryProvider).knownCount();
});

final _knownByLangProvider = FutureProvider.autoDispose<Map<Lang, int>>((
  ref,
) async {
  ref.watch(dueCountProvider);
  final rows = await ref
      .watch(localDbProvider)
      .all(LocalDb.cardStates, filter: Filter.equals('state', 2));
  final out = {for (final l in Lang.values) l: 0};
  for (final r in rows) {
    final lang = ContentId.parse(r['card_id'] as String)?.lang;
    if (lang != null) out[lang] = out[lang]! + 1;
  }
  return out;
});

/// Expected date to finish C1 in [t], from the hours left in the outline and
/// your daily minutes for this language (6 study days a week).
DateTime? projectC1(
  LanguageTrack t,
  List<OutlineLevel> outline,
  int dailyMinutes,
  double levelFraction,
) {
  final i = outline.indexWhere((o) => o.id == t.currentLevel);
  if (i < 0) return null;
  var hours = outline[i].targetHours * (1 - levelFraction);
  for (final o in outline.skip(i + 1)) {
    hours += o.targetHours;
  }
  final perDay = dailyMinutes / 60 * t.timeShare * 6 / 7;
  if (perDay <= 0) return null;
  final start = t.startDate != null && t.startDate!.isAfter(DateTime.now())
      ? t.startDate!
      : DateTime.now();
  return start.add(Duration(days: (hours / perDay).ceil()));
}

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
          Text(l.yourLanguages, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const _LanguageCards(),
          const SizedBox(height: 16),
          const _MixupMap(),
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

class _LanguageCards extends ConsumerWidget {
  const _LanguageCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final tracks = ref.watch(tracksProvider).value;
    final outline = ref.watch(outlineProvider).value;
    final known = ref.watch(_knownByLangProvider).value ?? const {};
    final progress = ref.watch(lessonProgressProvider).value ?? const {};
    final minutes = ref.watch(settingsProvider).value?.dailyGoalMinutes ?? 120;
    final ui = ref.watch(uiLanguageProvider);
    if (tracks == null || outline == null) return const SizedBox.shrink();
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final lang in Lang.values)
          Builder(
            builder: (context) {
              final t = tracks[lang]!;
              final level = ContentRepository.packLevelFor(lang, t.currentLevel);
              final pack = level == null
                  ? null
                  : ref
                        .watch(levelContentProvider((lang: lang, level: level)))
                        .value;
              final total = pack?.lessons.length ?? 0;
              final done = pack == null
                  ? 0
                  : pack.lessons.keys
                        .where(
                          (id) =>
                              progress[id]?.status == LessonStatus.completed,
                        )
                        .length;
              final fraction = total == 0 ? 0.0 : done / total;
              final c1 = projectC1(t, outline, minutes, fraction);
              return SizedBox(
                width: 260,
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: lang.color, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${lang.displayName(ui)} · ${t.currentLevel}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: lang.color),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: fraction,
                          color: lang.color,
                        ),
                        const SizedBox(height: 8),
                        Text(l.lessonsCompleted(done, total)),
                        Text(l.wordsKnown(known[lang] ?? 0)),
                        if (t.status == TrackStatus.paused)
                          Text(l.trackPaused)
                        else if (c1 != null)
                          Text(l.c1By(formatDay(c1))),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

/// How often each language leaks into another, from your mix-ups.
class _MixupMap extends ConsumerWidget {
  const _MixupMap();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final events = ref.watch(interferenceEventsProvider).value ?? const [];
    final pairs = <(Lang, Lang), int>{};
    for (final e in events) {
      pairs[(e.lang, e.otherLang)] = (pairs[(e.lang, e.otherLang)] ?? 0) + 1;
    }
    final sorted = pairs.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final max = sorted.isEmpty ? 1 : sorted.first.value;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.mixupMap, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (sorted.isEmpty) Text(l.noMixups),
            for (final e in sorted)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 72,
                      child: Text(
                        '\u2066${e.key.$1.code} <- ${e.key.$2.code}\u2069',
                        style: TextStyle(
                          color: e.key.$2.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: e.value / max,
                        color: e.key.$2.color,
                        minHeight: 10,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text('${e.value}', textAlign: TextAlign.end),
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
