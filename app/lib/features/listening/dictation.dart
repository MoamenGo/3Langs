import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../core/bidi.dart';

/// Hear a German sentence (device TTS), type it, compare.
class DictationRunner extends ConsumerStatefulWidget {
  const DictationRunner({
    super.key,
    required this.sentences,
    required this.onDone,
  });
  final List<Sentence> sentences;
  final void Function(double score) onDone;

  @override
  ConsumerState<DictationRunner> createState() => _DictationRunnerState();
}

class _DictationRunnerState extends ConsumerState<DictationRunner> {
  final _controller = TextEditingController();
  int _index = 0, _correct = 0;
  bool? _wasRight;
  bool _revealed = false, _firstTry = true;
  final _focus = FocusNode();

  bool get _done => _wasRight == true || _revealed;
  bool get _waitingRetry => _wasRight == false && !_revealed;

  void _retry() {
    setState(() => _wasRight = null);
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  void _reveal() => setState(() => _revealed = true);
  bool _showTranslation = false;

  Sentence get _current => widget.sentences[_index];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _play());
  }

  void _play({bool slow = false}) =>
      ref.read(ttsProvider).speak(_current.text, slow: slow);

  void _check() {
    final right =
        normalizeAnswer(_controller.text) == normalizeAnswer(_current.text);
    setState(() => _wasRight = right);
    if (right && _firstTry) _correct++;
    if (!right) _firstTry = false;
  }

  void _next() {
    if (_index + 1 >= widget.sentences.length) {
      widget.onDone(_correct / widget.sentences.length);
      return;
    }
    setState(() {
      _index++;
      _wasRight = null;
      _revealed = false;
      _firstTry = true;
      _showTranslation = false;
      _controller.clear();
    });
    _play();
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
    final lang = ref.watch(explainLangProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: _index / widget.sentences.length),
        const SizedBox(height: 16),
        BidiText(
          l.listenAndType,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.tonalIcon(
              onPressed: _play,
              icon: const Icon(Icons.volume_up),
              label: BidiText(l.playAudio),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () => _play(slow: true),
              icon: const Icon(Icons.slow_motion_video),
              label: BidiText(l.playSlow),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          focusNode: _focus,
          textDirection: TextDirection.ltr,
          autocorrect: false,
          enabled: _wasRight == null,
          decoration: InputDecoration(
            hintText: l.typeHere(ref.watch(activeLangNameProvider)),
            hintTextDirection: Directionality.of(context),
          ),
          onSubmitted: (_) => _wasRight == null
              ? _check()
              : _done
              ? _next()
              : null,
        ),
        const SizedBox(height: 12),
        if (_wasRight != null) ...[
          BidiText(
            _wasRight!
                ? l.correct
                : _revealed
                ? l.wrongAnswer(_current.text)
                : l.notQuiteTryAgain,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _wasRight!
                  ? Colors.green
                  : Theme.of(context).colorScheme.error,
            ),
          ),
          BidiText(
            _current.translations.get(lang),
            textAlign: TextAlign.center,
          ),
        ] else
          TextButton(
            onPressed: () =>
                setState(() => _showTranslation = !_showTranslation),
            child: BidiText(
              _showTranslation
                  ? _current.translations.get(lang)
                  : l.showTranslation,
            ),
          ),
        const Spacer(),
        if (_waitingRetry)
          RetryOrReveal(onRetry: _retry, onReveal: _reveal)
        else
          FilledButton(
            onPressed: _wasRight == null ? _check : _next,
            child: BidiText(_wasRight == null ? l.check : l.next),
          ),
      ],
    );
  }
}
