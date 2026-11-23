import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/contrast.dart';
import 'contrast_widgets.dart';

/// The contrast dictionary: every false friend, look-alike and gender change
/// between German, Dutch and Spanish, filterable by kind.
class ContrastScreen extends ConsumerStatefulWidget {
  const ContrastScreen({super.key});

  @override
  ConsumerState<ContrastScreen> createState() => _ContrastScreenState();
}

class _ContrastScreenState extends ConsumerState<ContrastScreen> {
  ContrastKind? _kind = ContrastKind.falseFriend;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final explain = ref.watch(explainLangProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.contrastDictionary)),
      body: AsyncView(
        value: ref.watch(contrastProvider),
        builder: (entries) {
          final shown = _kind == null
              ? entries
              : entries.where((e) => e.kind == _kind).toList();
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Text(
                l.contrastIntro,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final k in [null, ...ContrastKind.values])
                    ChoiceChip(
                      key: ValueKey('contrast-${k?.json ?? 'all'}'),
                      label: Text(
                        '${k == null ? l.contrastAll : contrastKindLabel(context, k)}'
                        ' (${k == null ? entries.length : entries.where((e) => e.kind == k).length})',
                      ),
                      selected: _kind == k,
                      onSelected: (_) => setState(() => _kind = k),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              for (final e in shown)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            for (final code in contrastLangOrder)
                              if (e.forms[code] != null)
                                LangWordChip(code: code, word: e.forms[code]!),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ContrastNote(kind: e.kind, text: e.note.get(explain)),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
