import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/lang/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/learner.dart';
import '../../domain/interference/contrast_drill.dart';
import '../../domain/interference/interference_detector.dart';

final _drillProvider = FutureProvider.autoDispose<List<DrillQuestion>>((
  ref,
) async {
  final concepts = await ref.watch(conceptIndexProvider.future);
  final contrast = await ref.watch(contrastProvider.future);
  final events = await ref.read(interferenceRepositoryProvider).all();
  final tracks = await ref.read(trackRepositoryProvider).all();
  final now = DateTime.now().toUtc();
  var langs = {
    for (final t in tracks.values)
      if (t.status != TrackStatus.paused && t.isActiveOn(now)) t.lang,
  };
  if (langs.length < 2) langs = Lang.values.toSet();
  return buildContrastDrill(
    concepts: concepts,
    contrast: contrast,
    events: events,
    langs: langs,
  );
});

/// The contrast drill, then your list of mix-ups.
class ContrastDrillScreen extends ConsumerStatefulWidget {
  const ContrastDrillScreen({super.key});

  @override
  ConsumerState<ContrastDrillScreen> createState() =>
      _ContrastDrillScreenState();
}

class _ContrastDrillScreenState extends ConsumerState<ContrastDrillScreen> {
  int _index = 0, _correct = 0;
  DrillOption? _picked;
  bool _finished = false;

  Future<void> _pick(DrillQuestion q, DrillOption o) async {
    if (_picked != null) return;
    setState(() => _picked = o);
    ref.read(ttsProvider).speak(q.target.display, lang: q.target.lang ?? ref.read(activeLangProvider));
    if (o.correct) {
      _correct++;
    } else if (o.lang != null && q.target.lang != null) {
      await ref
          .read(interferenceRepositoryProvider)
          .record(
            lang: q.target.lang!,
            match: InterferenceMatch(
              otherLang: o.lang!,
              kind: 'same_concept',
              conceptId: q.target.conceptId,
            ),
            expected: q.target.display,
            given: o.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final explain = ref.watch(explainLangProvider);
    final ui = ref.watch(uiLanguageProvider);
    return StudyTimer(
      activity: Activity.review,
      child: Scaffold(
        appBar: AppBar(title: Text(l.blockContrast)),
        body: AsyncView(
          value: ref.watch(_drillProvider),
          builder: (questions) {
            if (questions.isEmpty) {
              return Center(child: Text(l.drillEmpty));
            }
            if (_finished) {
              return _Summary(
                score: _correct / questions.length,
              );
            }
            final q = questions[_index];
            final lang = q.target.lang!;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LinearProgressIndicator(
                        value: _index / questions.length,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l.whichMeans(
                          q.target.translations.get(explain),
                          lang.displayName(ui),
                        ),
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Chip(
                          label: Text(lang.code),
                          backgroundColor: lang.color,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (final o in q.options)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: _picked == null
                                  ? null
                                  : o.correct
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : identical(o, _picked)
                                  ? Theme.of(context).colorScheme.errorContainer
                                  : null,
                            ),
                            onPressed: () => _pick(q, o),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    o.text,
                                    textDirection: TextDirection.ltr,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                if (_picked != null)
                                  Text(
                                    o.lang?.code ?? '✗',
                                    style: TextStyle(
                                      color: o.lang?.color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      if (_picked != null && q.note != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          q.note!.get(explain),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      const Spacer(),
                      FilledButton(
                        onPressed: _picked == null
                            ? null
                            : () => setState(() {
                                if (_index + 1 >= questions.length) {
                                  _finished = true;
                                } else {
                                  _index++;
                                  _picked = null;
                                }
                              }),
                        child: Text(l.next),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Summary extends ConsumerWidget {
  const _Summary({required this.score});
  final double score;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final events = ref.watch(interferenceEventsProvider).value ?? const [];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Icon(Icons.compare_arrows, size: 56),
        Text(
          l.scoreLabel((score * 100).round()),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Text(l.myMixups, style: Theme.of(context).textTheme.titleMedium),
        if (events.isEmpty) Text(l.noMixups),
        for (final e in events.take(30)) MixupTile(event: e),
        const SizedBox(height: 16),
        FilledButton(onPressed: () => context.pop(), child: Text(l.done)),
      ],
    );
  }
}

/// "NL huis ← you wrote DE Haus".
class MixupTile extends ConsumerWidget {
  const MixupTile({super.key, required this.event});
  final InterferenceEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ui = ref.watch(uiLanguageProvider);
    return ListTile(
      dense: true,
      leading: Text(
        '${event.lang.code}→${event.otherLang.code}',
        style: TextStyle(
          color: event.otherLang.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      title: Text(event.expected, textDirection: TextDirection.ltr),
      subtitle: Text(
        l.mixupGiven(event.given, event.otherLang.displayName(ui)),
      ),
      trailing: Text(formatDay(event.at.toLocal())),
    );
  }
}
