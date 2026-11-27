// The sound-by-sound guide on a language's sounds page: one card per sound
// with what it sounds like, how to say it, a tip for Arabic speakers and
// example words that play when tapped.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/bidi.dart';
import '../../core/lang/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../polyglot/ui.dart' show TrX;

const _amber = Color(0xFFC87D28);

class SoundCard extends ConsumerWidget {
  const SoundCard({
    super.key,
    required this.number,
    required this.item,
    required this.lang,
    required this.explain,
  });
  final int number;
  final SoundGuideItem item;
  final Lang lang;
  final ExplainLang explain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final tip = item.tip?.get(explain);
    return Card(
      key: Key('sound-$number'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 56),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: BidiText(
                      item.letters,
                      textAlign: TextAlign.center,
                      style: t.titleLarge?.copyWith(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _amber.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: BidiText(
                          '${context.tr('Sounds like', 'زي')}: '
                          '${item.like.get(explain)}',
                          style: t.labelLarge?.copyWith(
                            color: const Color(0xFF8A5418),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.examples.isNotEmpty)
                  IconButton(
                    key: Key('sound-$number-play'),
                    tooltip: context.tr('Listen', 'اسمع'),
                    icon: Icon(Icons.volume_up, color: scheme.primary),
                    onPressed: () => ref
                        .read(ttsProvider)
                        .speak(item.examples.first.text, lang: lang),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            BidiText(
              item.explain.get(explain),
              style: t.bodyLarge?.copyWith(height: 1.6),
            ),
            if (tip != null && tip.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _amber.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _amber.withValues(alpha: 0.35)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.tips_and_updates_outlined,
                      color: _amber,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: BidiText(
                        tip,
                        style: t.bodyMedium?.copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (item.examples.isNotEmpty) ...[
              const SizedBox(height: 12),
              for (final e in item.examples)
                _ExampleRow(example: e, lang: lang, explain: explain),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExampleRow extends ConsumerWidget {
  const _ExampleRow({
    required this.example,
    required this.lang,
    required this.explain,
  });
  final SoundExample example;
  final Lang lang;
  final ExplainLang explain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return InkWell(
      key: Key('ex-${example.text}'),
      borderRadius: BorderRadius.circular(10),
      onTap: () => ref.read(ttsProvider).speak(example.text, lang: lang),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(Icons.play_circle_outline, color: scheme.primary, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      BidiText(
                        example.text,
                        textDirection: TextDirection.ltr,
                        style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (example.say.isNotEmpty)
                        BidiText(
                          '«${example.say}»',
                          textDirection: TextDirection.rtl,
                          style: t.bodyMedium?.copyWith(color: scheme.primary),
                        ),
                    ],
                  ),
                  BidiText(
                    example.meaning.get(explain),
                    style: t.bodySmall?.copyWith(color: scheme.outline),
                  ),
                ],
              ),
            ),
            SpeakButton(example.text, slow: true, lang: lang),
          ],
        ),
      ),
    );
  }
}
