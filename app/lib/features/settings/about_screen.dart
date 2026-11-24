import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../core/bidi.dart';

/// Credits for every content source, as the CC BY / CC BY-SA licences ask.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  static const _sources = [
    (
      'Tatoeba',
      'Example sentences and translations',
      'CC BY 2.0 FR',
      'https://tatoeba.org',
    ),
    (
      'Wiktionary (via kaikki.org)',
      'Word forms, meanings, IPA',
      'CC BY-SA 4.0',
      'https://kaikki.org',
    ),
    (
      'Mozilla Common Voice',
      'Recorded German speech',
      'CC0',
      'https://commonvoice.mozilla.org',
    ),
    (
      'FrequencyWords',
      'Word frequency lists',
      'CC BY-SA 4.0',
      'https://github.com/hermitdave/FrequencyWords',
    ),
    (
      'LanguageTool',
      'Writing checks',
      'LGPL, free public API',
      'https://languagetool.org',
    ),
    (
      'Deutsche Welle',
      'Linked courses, not copied',
      '© DW',
      'https://learngerman.dw.com',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final levels = ref.watch(allContentProvider).value ?? const [];
    final itemSources = <String, String>{
      for (final c in levels) ...{
        for (final v in c.vocab.values) v.source: v.license,
        for (final s in c.sentences.values) s.source: s.license,
      },
    };
    return Scaffold(
      appBar: AppBar(title: BidiText(l.about)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BidiText(l.aboutText),
          const SizedBox(height: 16),
          for (final (name, what, license, url) in _sources)
            ListTile(
              title: BidiText(name),
              subtitle: BidiText('$what · $license\n$url'),
              isThreeLine: true,
            ),
          const Divider(),
          for (final c in levels)
            ListTile(
              dense: true,
              title: BidiText('${c.level.id} content ${c.contentVersion}'),
            ),
          for (final e in itemSources.entries.take(50))
            ListTile(
              dense: true,
              title: BidiText(e.key),
              trailing: BidiText(e.value),
            ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () =>
                showLicensePage(context: context, applicationName: l.appTitle),
            child: const BidiText('Open-source licences'),
          ),
        ],
      ),
    );
  }
}
