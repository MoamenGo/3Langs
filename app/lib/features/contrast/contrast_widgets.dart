import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/lang/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../data/models/contrast.dart';
import '../../core/bidi.dart';

/// On a word card: the same word in the learner's other two languages, and
/// any contrast note about it (false friend, gender change, look-alike).
class OtherLanguages extends ConsumerWidget {
  const OtherLanguages({super.key, required this.item});
  final VocabItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final explain = ref.watch(explainLangProvider);
    final index = ref.watch(conceptIndexProvider).value;
    final entries = ref.watch(contrastProvider).value ?? const [];
    final words = index?[item.conceptId] ?? const <Lang, VocabItem>{};
    final others = [
      for (final l in Lang.values)
        if (l != item.lang && words[l] != null) words[l]!,
    ];
    final notes = entries.where((e) => e.concerns(item)).toList()
      ..sort((a, b) => a.kind.index.compareTo(b.kind.index));
    if (others.isEmpty && notes.isEmpty) return const SizedBox.shrink();
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 32),
        BidiText(
          context.l10n.inOtherLanguages,
          style: text.labelSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final w in others)
              LangWordChip(code: w.lang!.name, word: w.display),
          ],
        ),
        for (final n in notes.take(2))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ContrastNote(kind: n.kind, text: n.note.get(explain)),
          ),
      ],
    );
  }
}

/// A word with a small coloured tag for its language: [DE] der Tisch.
class LangWordChip extends StatelessWidget {
  const LangWordChip({super.key, required this.code, required this.word});
  final String code;
  final String word;

  @override
  Widget build(BuildContext context) {
    final lang = langOfCode(code);
    final color = lang?.color ?? Theme.of(context).colorScheme.outline;
    return Chip(
      visualDensity: VisualDensity.compact,
      avatar: CircleAvatar(
        backgroundColor: color,
        child: BidiText(
          code.toUpperCase(),
          style: const TextStyle(fontSize: 9, color: Colors.white),
        ),
      ),
      label: BidiText(word, textDirection: TextDirection.ltr),
      side: BorderSide(color: color.withValues(alpha: 0.5)),
    );
  }
}

class ContrastNote extends StatelessWidget {
  const ContrastNote({super.key, required this.kind, required this.text});
  final ContrastKind kind;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (icon, color) = switch (kind) {
      ContrastKind.falseFriend => (Icons.warning_amber, scheme.error),
      ContrastKind.genderMismatch => (Icons.swap_horiz, scheme.tertiary),
      ContrastKind.nearCognate => (Icons.link, scheme.primary),
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: BidiText(text, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}

String contrastKindLabel(BuildContext context, ContrastKind kind) =>
    switch (kind) {
      ContrastKind.falseFriend => context.l10n.falseFriends,
      ContrastKind.nearCognate => context.l10n.nearCognates,
      ContrastKind.genderMismatch => context.l10n.genderMismatches,
    };
