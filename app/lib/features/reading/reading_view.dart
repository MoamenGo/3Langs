import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/lang/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../core/bidi.dart';

/// A reading text with audio, a glossary, a translation toggle and questions.
class ReadingView extends ConsumerStatefulWidget {
  const ReadingView({
    super.key,
    required this.text,
    required this.content,
    this.onDone,
  });
  final ContentText text;
  final LevelContent content;
  final void Function(double score)? onDone;

  @override
  ConsumerState<ReadingView> createState() => _ReadingViewState();
}

class _ReadingViewState extends ConsumerState<ReadingView> {
  final _answers = <int, int>{};
  bool _showTranslation = false;
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = ref.watch(explainLangProvider);
    final t = widget.text;
    final theme = Theme.of(context).textTheme;

    if (t.kind == 'external') {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BidiText(t.title, style: theme.headlineSmall),
          const SizedBox(height: 8),
          if (t.translation != null) BidiText(t.translation!.get(lang)),
          const SizedBox(height: 8),
          BidiText(l.externalHint),
          SelectableText(
            t.url ?? '',
            textDirection: TextDirection.ltr,
            textAlign: screenAlign(context),
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          const SizedBox(height: 16),
          if (widget.onDone != null)
            FilledButton(
              onPressed: () => widget.onDone!(1),
              child: BidiText(l.next),
            ),
        ],
      );
    }

    final glossary = t.glossary
        .map((id) => widget.content.vocab[id])
        .whereType<VocabItem>();
    final score = t.questions.isEmpty
        ? 1.0
        : t.questions.indexed
                  .where((e) => _answers[e.$1] == e.$2.answer)
                  .length /
              t.questions.length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: BidiText(t.title, style: theme.headlineSmall)),
            if (t.body != null)
              SpeakButton(t.body!, lang: ContentId.parse(t.id)?.lang),
            if (t.body != null)
              SpeakButton(
                t.body!,
                slow: true,
                lang: ContentId.parse(t.id)?.lang,
              ),
          ],
        ),
        const SizedBox(height: 12),
        SelectableText(
          t.body ?? '',
          textDirection: TextDirection.ltr,
          style: theme.bodyLarge?.copyWith(height: 1.6),
        ),
        if (t.translation != null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () =>
                  setState(() => _showTranslation = !_showTranslation),
              child: BidiText(l.showTranslation),
            ),
          ),
        if (_showTranslation && t.translation != null)
          BidiText(
            t.translation!.get(lang),
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        if (glossary.isNotEmpty) ...[
          const Divider(height: 32),
          BidiText(l.glossary, style: theme.titleMedium),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final v in glossary)
                Chip(
                  label: BidiText('${v.display} · ${v.translations.get(lang)}'),
                ),
            ],
          ),
        ],
        if (t.questions.isNotEmpty) ...[
          const Divider(height: 32),
          BidiText(l.questions, style: theme.titleMedium),
          for (final (qi, q) in t.questions.indexed) ...[
            const SizedBox(height: 12),
            BidiText(
              q.question,
              textDirection: TextDirection.ltr,
              style: theme.titleSmall,
            ),
            RadioGroup<int>(
              groupValue: _answers[qi],
              onChanged: (v) =>
                  _checked ? null : setState(() => _answers[qi] = v!),
              child: Column(
                children: [
                  for (final (oi, option) in q.options.indexed)
                    RadioListTile<int>(
                      dense: true,
                      value: oi,
                      title: BidiText(option, textDirection: TextDirection.ltr),
                      secondary: _checked && oi == q.answer
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                    ),
                ],
              ),
            ),
          ],
        ],
        const SizedBox(height: 16),
        if (_checked)
          BidiText(
            l.scoreLabel((score * 100).round()),
            textAlign: TextAlign.center,
          ),
        FilledButton(
          onPressed: _answers.length < t.questions.length
              ? null
              : () {
                  if (!_checked) {
                    setState(() => _checked = true);
                  } else {
                    widget.onDone?.call(score);
                  }
                },
          child: BidiText(!_checked ? l.check : l.next),
        ),
      ],
    );
  }
}
