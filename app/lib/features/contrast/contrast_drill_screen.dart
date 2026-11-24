import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/lang/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/learner.dart';
import '../../domain/interference/contrast_drill.dart';
import '../../domain/interference/interference_detector.dart';
import '../../core/bidi.dart';

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
  bool _finished = false, _revealed = false, _firstTry = true;
  final _wrongTries = <DrillOption>{};

  bool get _done => (_picked?.correct ?? false) || _revealed;

  void _retry() => setState(() {
    _wrongTries.add(_picked!);
    _picked = null;
  });

  void _reveal(DrillQuestion q) {
    setState(() => _revealed = true);
    _speak(q);
  }

  void _speak(DrillQuestion q) => ref
      .read(ttsProvider)
      .speak(
        q.target.display,
        lang: q.target.lang ?? ref.read(activeLangProvider),
      );

  Future<void> _pick(DrillQuestion q, DrillOption o) async {
    if (_picked != null || _done || _wrongTries.contains(o)) return;
    setState(() => _picked = o);
    if (o.correct) {
      if (_firstTry) _correct++;
      _speak(q);
      return;
    }
    _firstTry = false;
    if (o.lang != null && q.target.lang != null) {
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
        appBar: AppBar(title: BidiText(l.blockContrast)),
        body: AsyncView(
          value: ref.watch(_drillProvider),
          builder: (questions) {
            if (questions.isEmpty) {
              return Center(child: BidiText(l.drillEmpty));
            }
            if (_finished) {
              return _Summary(score: _correct / questions.length);
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
                      LinearProgressIndicator(value: _index / questions.length),
                      const SizedBox(height: 24),
                      BidiText(
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
                          label: BidiText(lang.code),
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
                              backgroundColor: o.correct && _done
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : identical(o, _picked) ||
                                        _wrongTries.contains(o)
                                  ? Theme.of(context).colorScheme.errorContainer
                                  : null,
                            ),
                            onPressed: () => _pick(q, o),
                            child: Row(
                              children: [
                                Expanded(
                                  child: BidiText(
                                    o.text,
                                    textDirection: TextDirection.ltr,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                if (_done)
                                  BidiText(
                                    o.lang?.code ?? 'x',
                                    style: TextStyle(
                                      color: o.lang?.color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      if (_picked != null && !_done) ...[
                        const SizedBox(height: 12),
                        BidiText(
                          l.notQuiteTryAgain,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      if (_done && q.note != null) ...[
                        const SizedBox(height: 12),
                        BidiText(
                          q.note!.get(explain),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      const Spacer(),
                      if (_picked != null && !_done)
                        RetryOrReveal(
                          onRetry: _retry,
                          onReveal: () => _reveal(q),
                        )
                      else
                        FilledButton(
                          onPressed: !_done
                              ? null
                              : () => setState(() {
                                  if (_index + 1 >= questions.length) {
                                    _finished = true;
                                  } else {
                                    _index++;
                                    _picked = null;
                                    _revealed = false;
                                    _firstTry = true;
                                    _wrongTries.clear();
                                  }
                                }),
                          child: BidiText(l.next),
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
        BidiText(
          l.scoreLabel((score * 100).round()),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        BidiText(l.myMixups, style: Theme.of(context).textTheme.titleMedium),
        if (events.isEmpty) BidiText(l.noMixups),
        for (final e in events.take(30)) MixupTile(event: e),
        const SizedBox(height: 16),
        FilledButton(onPressed: () => context.pop(), child: BidiText(l.done)),
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
      leading: BidiText(
        '${event.lang.code}->${event.otherLang.code}',
        style: TextStyle(
          color: event.otherLang.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      title: BidiText(event.expected, textDirection: TextDirection.ltr),
      subtitle: BidiText(
        l.mixupGiven(event.given, event.otherLang.displayName(ui)),
      ),
      trailing: BidiText(formatDay(event.at.toLocal())),
    );
  }
}
