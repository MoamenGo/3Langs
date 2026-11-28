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
import '../../core/theme.dart';
import '../polyglot/ui.dart' show TrX;

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
    this.allowRetry = true,
  });
  final List<VocabItem> items;

  /// Off in exams and the placement test: a wrong pick shows the answer.
  final bool allowRetry;

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
  bool _revealed = false, _firstTry = true;
  final _wrongTries = <String>{};
  late List<VocabItem> _options = _makeOptions();

  bool get _solved => _picked == _order[_index].id;
  bool get _done => _solved || _revealed;

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
    if (_picked != null || _done || _wrongTries.contains(v.id)) return;
    final target = _order[_index];
    setState(() {
      _picked = v.id;
      _mixupFrom = null;
    });
    if (v.id == target.id) {
      if (_firstTry) _correct++;
      _speakTarget();
      return;
    }
    _firstTry = false;
    if (!widget.allowRetry) _reveal();
    if (v.lang != null && v.lang != target.lang) {
      reportWrongAnswer(ref, target, v.display).then((from) {
        if (mounted) setState(() => _mixupFrom = from);
      });
    }
  }

  void _retry() => setState(() {
    _wrongTries.add(_picked!);
    _picked = null;
    _mixupFrom = null;
  });

  void _reveal() {
    setState(() => _revealed = true);
    _speakTarget();
  }

  void _speakTarget() {
    final target = _order[_index];
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
      _revealed = false;
      _firstTry = true;
      _wrongTries.clear();
      _mixupFrom = null;
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
                backgroundColor: o.id == target.id && _done
                    ? Colors.green.withValues(alpha: 0.2)
                    : o.id == _picked || _wrongTries.contains(o.id)
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
        if (_picked != null && !_done)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: BidiText(
              l.notQuiteTryAgain,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.error),
            ),
          ),
        const Spacer(),
        if (_picked != null && !_done)
          RetryOrReveal(onRetry: _retry, onReveal: _reveal)
        else
          FilledButton(
            onPressed: _done ? _next : null,
            child: BidiText(l.next),
          ),
      ],
    );
  }
}

/// Fill-in-the-gap grammar exercises: "Ich ___ Anna. (heißen)".
///
/// The answer field stays editable at all times. Checking opens a popup
/// with a tick or a cross; editing the answer afterwards lets the learner
/// check again. Only a right answer on the first try counts toward the score.
class FillBlankRunner extends ConsumerStatefulWidget {
  const FillBlankRunner({
    super.key,
    required this.exercises,
    required this.onDone,
    this.allowRetry = true,
  });
  final List<GrammarExercise> exercises;

  /// Off in exams: a wrong answer shows the right one straight away.
  final bool allowRetry;
  final void Function(double score) onDone;

  @override
  ConsumerState<FillBlankRunner> createState() => _FillBlankRunnerState();
}

/// What the learner chose in the answer popup.
enum _Feedback { next, retry, reveal, edit }

class _FillBlankRunnerState extends ConsumerState<FillBlankRunner> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  int _index = 0, _correct = 0;

  /// Result for the text as it is now; null once the learner edits it.
  bool? _wasRight;
  bool _revealed = false, _solved = false, _firstTry = true;

  bool get _canAdvance => _solved || _revealed;
  bool get _hasText => _controller.text.trim().isNotEmpty;

  void _focusField() {
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  void _onEdited(String _) {
    // Any edit makes the old verdict stale: the learner can check again.
    setState(() => _wasRight = null);
  }

  void _reveal() => setState(() => _revealed = true);

  Future<void> _check() async {
    if (!_hasText) {
      _focusField();
      return;
    }
    final ex = widget.exercises[_index];
    final right =
        normalizeAnswer(_controller.text) == normalizeAnswer(ex.answer);
    setState(() {
      _wasRight = right;
      if (right) {
        if (_firstTry && !_solved) _correct++;
        _solved = true;
      } else {
        _firstTry = false;
        if (!widget.allowRetry) _revealed = true;
      }
    });
    final choice = await showDialog<_Feedback>(
      context: context,
      builder: (_) => _AnswerFeedbackDialog(
        right: right,
        given: _controller.text.trim(),
        answer: ex.answer,
        revealed: _revealed,
        allowRetry: widget.allowRetry,
      ),
    );
    if (!mounted) return;
    switch (choice) {
      case _Feedback.next:
        _next();
      case _Feedback.reveal:
        _reveal();
        _focusField();
      case _Feedback.retry || _Feedback.edit || null:
        _focusField();
    }
  }

  void _next() {
    if (_index + 1 >= widget.exercises.length) {
      widget.onDone(_correct / widget.exercises.length);
      return;
    }
    setState(() {
      _index++;
      _wasRight = null;
      _revealed = false;
      _solved = false;
      _firstTry = true;
      _controller.clear();
    });
    _focusField();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final mx = context.mx;
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final ex = widget.exercises[_index];
    final total = widget.exercises.length;
    final wrong = theme.colorScheme.error;
    final stateColor = switch (_wasRight) {
      true => mx.primary,
      false => wrong,
      null => mx.rule,
    };
    OutlineInputBorder border(Color c, [double w = 1.5]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c, width: w),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: (_index + (_canAdvance ? 1 : 0)) / total,
                  minHeight: 8,
                  backgroundColor: mx.surface2,
                  color: mx.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            BidiText(
              '${_index + 1} / $total',
              textDirection: TextDirection.ltr,
              style: text.labelLarge?.copyWith(color: mx.muted),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // The sentence with its gap.
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  decoration: BoxDecoration(
                    color: mx.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: mx.rule),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            size: 20,
                            color: mx.primary,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: BidiText(
                              context.tr('Fill in the blank', 'أكمل الفراغ'),
                              style: text.labelLarge?.copyWith(
                                color: mx.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      BidiText(
                        ex.prompt,
                        textDirection: TextDirection.ltr,
                        style: text.headlineSmall?.copyWith(
                          color: mx.ink,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (ex.base != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: mx.amber.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lightbulb_outline_rounded,
                                size: 16,
                                color: mx.ink,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: BidiText(
                                  ex.base!,
                                  textDirection: TextDirection.ltr,
                                  style: text.bodyMedium?.copyWith(
                                    color: mx.ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  key: const Key('answer-field'),
                  controller: _controller,
                  focusNode: _focus,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  style: text.titleLarge?.copyWith(color: mx.ink),
                  textInputAction: TextInputAction.done,
                  onChanged: _onEdited,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: mx.surface,
                    hintText: l.typeHere(ref.watch(activeLangNameProvider)),
                    hintTextDirection: Directionality.of(context),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    enabledBorder: border(stateColor),
                    focusedBorder: border(
                      _wasRight == null ? mx.primary : stateColor,
                      2,
                    ),
                    suffixIcon: _wasRight == null
                        ? null
                        : Icon(
                            _wasRight!
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            color: stateColor,
                          ),
                  ),
                  onSubmitted: (_) => _wasRight == null
                      ? _check()
                      : _canAdvance
                      ? _next()
                      : _focusField(),
                ),
                const SizedBox(height: 8),
                BidiText(
                  context.tr(
                    'You can edit your answer and check again at any time.',
                    'يمكنك تعديل إجابتك والتحقق منها مرة أخرى في أي وقت.',
                  ),
                  textAlign: TextAlign.center,
                  style: text.bodySmall?.copyWith(color: mx.muted),
                ),
                if (_revealed) ...[
                  const SizedBox(height: 16),
                  Container(
                    key: const Key('revealed-answer'),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: mx.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: BidiText(
                      l.wrongAnswer(ex.answer),
                      textAlign: TextAlign.center,
                      style: text.titleMedium?.copyWith(color: mx.ink),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (_wasRight == null && _canAdvance) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: _next,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: BidiText(l.next),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: FilledButton.icon(
                key: const Key('check-or-next'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: _wasRight == null
                    ? _check
                    : _canAdvance
                    ? _next
                    : _focusField,
                icon: Icon(
                  _wasRight == null
                      ? Icons.check_rounded
                      : _canAdvance
                      ? Icons.arrow_forward_rounded
                      : Icons.edit_rounded,
                ),
                label: BidiText(
                  _wasRight == null
                      ? l.check
                      : _canAdvance
                      ? l.next
                      : l.tryAgain,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Popup after a check: a big tick for a right answer, a cross otherwise.
class _AnswerFeedbackDialog extends StatelessWidget {
  const _AnswerFeedbackDialog({
    required this.right,
    required this.given,
    required this.answer,
    required this.revealed,
    required this.allowRetry,
  });
  final bool right, revealed, allowRetry;
  final String given, answer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final mx = context.mx;
    final text = Theme.of(context).textTheme;
    final color = right ? mx.primary : Theme.of(context).colorScheme.error;
    void close(_Feedback f) => Navigator.of(context).pop(f);
    const pad = EdgeInsets.symmetric(horizontal: 8, vertical: 14);

    final actions = <Widget>[
      if (right || revealed) ...[
        OutlinedButton.icon(
          key: const Key('fb-edit'),
          onPressed: () => close(_Feedback.edit),
          icon: const Icon(Icons.edit_rounded, size: 18),
          label: BidiText(context.tr('Edit', 'تعديل')),
        ),
        FilledButton.icon(
          key: const Key('fb-next'),
          onPressed: () => close(_Feedback.next),
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          label: BidiText(l.next),
        ),
      ] else ...[
        OutlinedButton.icon(
          key: const Key('fb-reveal'),
          onPressed: () => close(_Feedback.reveal),
          icon: const Icon(Icons.visibility_outlined, size: 18),
          label: BidiText(l.showAnswer),
        ),
        FilledButton.icon(
          key: const Key('fb-retry'),
          onPressed: () => close(_Feedback.retry),
          icon: const Icon(Icons.edit_rounded, size: 18),
          label: BidiText(l.tryAgain),
        ),
      ],
    ];

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      // The theme's dialog colour stays nearly opaque under the glass style.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.5, end: 1),
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutBack,
                builder: (_, s, child) =>
                    Transform.scale(scale: s, child: child),
                child: Container(
                  key: Key(right ? 'fb-tick' : 'fb-cross'),
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        right ? Icons.check_rounded : Icons.close_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BidiText(
                right ? l.correct : context.tr('Not quite', 'إجابة خاطئة'),
                style: text.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: mx.ink.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: BidiText(
                  given,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  style: text.titleMedium?.copyWith(
                    color: mx.ink,
                    decoration: right ? null : TextDecoration.lineThrough,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              BidiText(
                right
                    ? context.tr('Well done!', 'أحسنت!')
                    : revealed
                    ? l.wrongAnswer(answer)
                    : l.notQuiteTryAgain,
                textAlign: TextAlign.center,
                style: text.bodyLarge?.copyWith(
                  color: right || !revealed ? mx.muted : mx.ink,
                ),
              ),
              const SizedBox(height: 20),
              Theme(
                // Compact buttons so both labels fit on one line.
                data: Theme.of(context).copyWith(
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: Theme.of(context).outlinedButtonTheme.style
                        ?.copyWith(
                          padding: const WidgetStatePropertyAll(pad),
                          backgroundColor: const WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                          side: WidgetStatePropertyAll(
                            BorderSide(color: mx.muted.withValues(alpha: 0.45)),
                          ),
                        ),
                  ),
                  filledButtonTheme: FilledButtonThemeData(
                    style: Theme.of(context).filledButtonTheme.style
                        ?.copyWith(padding: const WidgetStatePropertyAll(pad)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(child: actions[0]),
                    const SizedBox(width: 10),
                    Expanded(child: actions[1]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
