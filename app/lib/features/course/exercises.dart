// Reusable exercise widgets used by lessons and practice screens.

import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/lang/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../contrast/contrast_widgets.dart';
import '../../core/bidi.dart';

/// Shows one word with its translation, plural, an example, and the same
/// word in the learner's other languages.
class WordCard extends ConsumerWidget {
  const WordCard({super.key, required this.item, required this.content});
  final VocabItem item;
  final LevelContent content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = ref.watch(explainLangProvider);
    final text = Theme.of(context).textTheme;
    final example = item.sentenceIds
        .map((id) => content.sentences[id])
        .whereType<Sentence>()
        .firstOrNull;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: BidiText(
                    item.display,
                    textDirection: TextDirection.ltr,
                    style: text.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                SpeakButton(item.display, lang: item.lang),
              ],
            ),
            if (item.plural != null)
              BidiText(l.plural(item.plural!), style: text.bodySmall),
            const SizedBox(height: 12),
            BidiText(
              item.translations.get(lang),
              style: text.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (example != null) ...[
              const Divider(height: 32),
              BidiText(l.example, style: text.labelSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: BidiText(
                      example.text,
                      textDirection: TextDirection.ltr,
                      style: text.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SpeakButton(example.text, lang: item.lang),
                ],
              ),
              BidiText(
                example.translations.get(lang),
                style: text.bodyMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            OtherLanguages(item: item),
          ],
        ),
      ),
    );
  }
}

/// "Which German word means ...?" with four options.
class ChoiceQuiz extends ConsumerStatefulWidget {
  const ChoiceQuiz({
    super.key,
    required this.items,
    required this.pool,
    required this.onDone,
  });
  final List<VocabItem> items;

  /// Words to draw wrong options from.
  final List<VocabItem> pool;
  final void Function(double score) onDone;

  @override
  ConsumerState<ChoiceQuiz> createState() => _ChoiceQuizState();
}

class _ChoiceQuizState extends ConsumerState<ChoiceQuiz> {
  final _rnd = Random();
  late final List<VocabItem> _order = [...widget.items]..shuffle(_rnd);
  int _index = 0, _correct = 0;
  String? _picked;
  late List<VocabItem> _options = _makeOptions();

  List<VocabItem> _makeOptions() {
    final target = _order[_index];
    // Prefer distractors from the same lesson: harder, and they are words
    // the learner has just seen. Fill up from the wider pool if needed.
    final near = widget.items.where((v) => v.id != target.id).toList()
      ..shuffle(_rnd);
    final far =
        widget.pool
            .where((v) => v.id != target.id && !near.contains(v))
            .toList()
          ..shuffle(_rnd);
    final options = [
      target,
      ...[...near, ...far].take(3),
    ];
    // Sometimes one wrong option is the same word in another language you
    // learn (das Haus in a Dutch quiz): picking it counts as a mix-up.
    final other = _otherLanguageTwin(target);
    if (other != null && options.length == 4 && _rnd.nextInt(3) == 0) {
      options[3] = other;
    }
    return options..shuffle(_rnd);
  }

  VocabItem? _otherLanguageTwin(VocabItem target) {
    final cid = target.conceptId;
    final lang = target.lang;
    if (cid == null || lang == null) return null;
    final twins = ref.read(conceptIndexProvider).value?[cid];
    if (twins == null) return null;
    final others = [
      for (final e in twins.entries)
        if (e.key != lang && e.value.display != target.display) e.value,
    ]..sort((a, b) => Lang.areSimilar(lang, a.lang!) ? -1 : 1);
    return others.firstOrNull;
  }

  Lang? _mixupFrom;

  void _pick(VocabItem v) {
    if (_picked != null) return;
    final target = _order[_index];
    setState(() {
      _picked = v.id;
      _mixupFrom = null;
    });
    if (v.id == target.id) {
      _correct++;
    } else if (v.lang != null && v.lang != target.lang) {
      reportWrongAnswer(ref, target, v.display).then((from) {
        if (mounted) setState(() => _mixupFrom = from);
      });
    }
    ref
        .read(ttsProvider)
        .speak(
          target.display,
          lang: target.lang ?? ref.read(activeLangProvider),
        );
  }

  void _next() {
    if (_index + 1 >= _order.length) {
      widget.onDone(_correct / _order.length);
      return;
    }
    setState(() {
      _index++;
      _picked = null;
      _options = _makeOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = ref.watch(explainLangProvider);
    final target = _order[_index];
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: _index / _order.length),
        const SizedBox(height: 24),
        BidiText(
          l.whichMeans(
            target.translations.get(lang),
            ref.watch(activeLangNameProvider),
          ),
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        for (final o in _options)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: _picked == null
                    ? null
                    : o.id == target.id
                    ? Colors.green.withValues(alpha: 0.2)
                    : o.id == _picked
                    ? scheme.errorContainer
                    : null,
              ),
              onPressed: () => _pick(o),
              child: BidiText(o.display, style: const TextStyle(fontSize: 18)),
            ),
          ),
        if (_mixupFrom != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: BidiText(
              l.mixupHint(
                _mixupFrom!.displayName(ref.watch(uiLanguageProvider)),
              ),
              textAlign: TextAlign.center,
              style: TextStyle(color: _mixupFrom!.color),
            ),
          ),
        const Spacer(),
        FilledButton(
          onPressed: _picked == null ? null : _next,
          child: BidiText(l.next),
        ),
      ],
    );
  }
}

/// Fill-in-the-gap grammar exercises: "Ich ___ Anna. (heißen)".
class FillBlankRunner extends ConsumerStatefulWidget {
  const FillBlankRunner({
    super.key,
    required this.exercises,
    required this.onDone,
  });
  final List<GrammarExercise> exercises;
  final void Function(double score) onDone;

  @override
  ConsumerState<FillBlankRunner> createState() => _FillBlankRunnerState();
}

class _FillBlankRunnerState extends ConsumerState<FillBlankRunner> {
  final _controller = TextEditingController();
  int _index = 0, _correct = 0;
  bool? _wasRight;

  void _check() {
    final ex = widget.exercises[_index];
    final right =
        normalizeAnswer(_controller.text) == normalizeAnswer(ex.answer);
    setState(() => _wasRight = right);
    if (right) _correct++;
  }

  void _next() {
    if (_index + 1 >= widget.exercises.length) {
      widget.onDone(_correct / widget.exercises.length);
      return;
    }
    setState(() {
      _index++;
      _wasRight = null;
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ex = widget.exercises[_index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: _index / widget.exercises.length),
        const SizedBox(height: 24),
        BidiText(
          ex.prompt,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        if (ex.base != null)
          BidiText(
            '(${ex.base})',
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          textDirection: TextDirection.ltr,
          autofocus: true,
          autocorrect: false,
          enabled: _wasRight == null,
          decoration: InputDecoration(
            hintText: l.typeHere(ref.watch(activeLangNameProvider)),
            hintTextDirection: Directionality.of(context),
          ),
          onSubmitted: (_) => _wasRight == null ? _check() : _next(),
        ),
        const SizedBox(height: 12),
        if (_wasRight != null)
          BidiText(
            _wasRight! ? l.correct : l.wrongAnswer(ex.answer),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _wasRight!
                  ? Colors.green
                  : Theme.of(context).colorScheme.error,
            ),
          ),
        const Spacer(),
        FilledButton(
          onPressed: _wasRight == null ? _check : _next,
          child: BidiText(_wasRight == null ? l.check : l.next),
        ),
      ],
    );
  }
}
