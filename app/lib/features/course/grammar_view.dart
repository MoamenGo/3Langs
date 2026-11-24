import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/lang/lang.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../core/bidi.dart';

/// One piece of a grammar explanation, parsed from its plain text.
sealed class ExplainBlock {
  const ExplainBlock();
}

class ParagraphBlock extends ExplainBlock {
  const ParagraphBlock(this.text);
  final String text;
}

class BulletsBlock extends ExplainBlock {
  const BulletsBlock(this.items);
  final List<BulletItem> items;
}

/// A bullet such as "verb + -ung: entscheiden -> die Entscheidung": a
/// [label] before the colon and the [pairs] of "from -> to" examples.
class BulletItem {
  const BulletItem({this.label, this.text = '', this.pairs = const []});
  final String? label;
  final String text;
  final List<(String, String)> pairs;
}

/// Splits an explanation into paragraphs and bullet lists. Lines that start
/// with "- " or hold "a -> b" become bullets; "a -> b" parts become pairs.
List<ExplainBlock> parseExplanation(String text) {
  final out = <ExplainBlock>[];
  for (final para in text.split(RegExp(r'\n\s*\n'))) {
    final lines = para
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    var prose = <String>[];
    var bullets = <BulletItem>[];
    void flushProse() {
      if (prose.isNotEmpty) out.add(ParagraphBlock(prose.join(' ')));
      prose = [];
    }

    void flushBullets() {
      if (bullets.isNotEmpty) out.add(BulletsBlock(bullets));
      bullets = [];
    }

    for (final line in lines) {
      final isBullet = line.startsWith('- ') || line.startsWith('• ');
      if (isBullet || (line.contains('->') && line.length < 160)) {
        flushProse();
        bullets.add(parseBullet(isBullet ? line.substring(2).trim() : line));
      } else {
        flushBullets();
        prose.add(line);
      }
    }
    flushProse();
    flushBullets();
  }
  return out;
}

BulletItem parseBullet(String line) {
  String? label;
  var rest = line;
  final colon = line.indexOf(': ');
  if (colon > 0 && colon < 70) {
    label = line.substring(0, colon).trim();
    rest = line.substring(colon + 2).trim();
  }
  if (!rest.contains('->')) return BulletItem(label: label, text: rest);
  final pairs = <(String, String)>[];
  final leftovers = <String>[];
  for (final part in rest.split(RegExp(r'[,;،؛]\s+(?=[^,;،؛]*->)'))) {
    final i = part.indexOf('->');
    if (i < 0) {
      leftovers.add(part);
      continue;
    }
    final from = part.substring(0, i).trim();
    final to = part.substring(i + 2).trim().replaceAll(RegExp(r'[.,;]$'), '');
    if (from.isEmpty || to.isEmpty) {
      leftovers.add(part);
    } else {
      pairs.add((from, to));
    }
  }
  return BulletItem(label: label, text: leftovers.join(' '), pairs: pairs);
}

/// The redesigned grammar page: a hero header, key points as numbered glass
/// cards, transformations as chips, a styled table, examples with audio and
/// videos on YouTube.
class GrammarView extends ConsumerWidget {
  const GrammarView({super.key, required this.point, required this.content});
  final GrammarPoint point;
  final LevelContent content;

  int _unitOrder() {
    for (final lesson in content.lessons.values) {
      if (lesson.grammarId == point.id) {
        for (final u in content.units) {
          if (u.id == lesson.unitId) return u.order;
        }
      }
    }
    return 1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final explain = ref.watch(explainLangProvider);
    final lang = content.lang;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final blocks = parseExplanation(point.explanation.get(explain));
    final examples = [
      for (final id in point.exampleSentenceIds) ?content.sentences[id],
    ];
    var n = 0;
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        _Hero(title: point.title.get(explain), level: point.level, lang: lang),
        const SizedBox(height: 16),
        _SectionTitle(icon: Icons.lightbulb_outline, label: l.keyPoints),
        for (final b in blocks)
          switch (b) {
            ParagraphBlock(:final text) => _PointCard(number: ++n, text: text),
            BulletsBlock(:final items) => _BulletsCard(items: items),
          },
        if (point.tableRows.isNotEmpty) ...[
          const SizedBox(height: 8),
          _GrammarTable(headers: point.tableHeaders, rows: point.tableRows),
        ],
        if (examples.isNotEmpty) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SectionTitle(
                  icon: Icons.format_quote,
                  label: l.examplesTitle,
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.play_circle_outline),
                label: BidiText(l.listenAll),
                onPressed: () async {
                  final tts = ref.read(ttsProvider);
                  for (final s in examples) {
                    await tts.speak(s.text, lang: lang);
                  }
                },
              ),
            ],
          ),
          for (final s in examples)
            Card(
              child: ListTile(
                contentPadding: const EdgeInsetsDirectional.fromSTEB(
                  16,
                  8,
                  8,
                  8,
                ),
                leading: CircleAvatar(
                  backgroundColor: lang.color.withValues(alpha: 0.15),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: lang.color,
                    size: 20,
                  ),
                ),
                title: BidiText(
                  s.text,
                  textDirection: TextDirection.ltr,
                  textAlign: Directionality.of(context) == TextDirection.rtl
                      ? TextAlign.right
                      : TextAlign.left,
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: BidiText(s.translations.get(explain)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpeakButton(s.text, lang: lang),
                    SpeakButton(s.text, slow: true, lang: lang),
                  ],
                ),
              ),
            ),
        ],
        const SizedBox(height: 16),
        if (lang == Lang.de)
          if (pieceOfGermanUrl(content.level.id, _unitOrder()) case final url?)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PieceOfGermanCard(url: url),
            ),
        YouTubeCard(
          topic: point.title.values['en'] ?? point.title.get(explain),
          lang: lang,
        ),
        const SizedBox(height: 8),
        Center(
          child: BidiText(
            point.level,
            style: text.labelSmall?.copyWith(color: scheme.outline),
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.title, required this.level, required this.lang});
  final String title;
  final String level;
  final Lang lang;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              for (final c in [
                scheme.primary,
                Color.lerp(scheme.primary, lang.color, 0.45)!,
              ])
                Theme.of(context).brightness == Brightness.dark
                    ? Color.lerp(c, Colors.black, 0.5)!
                    : c,
            ],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.auto_stories,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BidiText(
                    '${lang.code} · $level',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  BidiText(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary, size: 20),
          const SizedBox(width: 8),
          BidiText(
            label,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _PointCard extends StatelessWidget {
  const _PointCard({required this.number, required this.text});
  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: scheme.primary,
              child: BidiText(
                '$number',
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BidiText(
                text,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletsCard extends StatelessWidget {
  const _BulletsCard({required this.items});
  final List<BulletItem> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, item) in items.indexed) ...[
              if (i > 0)
                Divider(
                  height: 1,
                  color: scheme.outlineVariant.withValues(alpha: 0.4),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.label != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: BidiText(
                          item.label!,
                          style: text.labelLarge?.copyWith(
                            color: scheme.onPrimaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    if (item.text.isNotEmpty)
                      BidiText(
                        item.text,
                        style: text.bodyLarge?.copyWith(height: 1.5),
                      ),
                    if (item.pairs.isNotEmpty)
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          for (final (from, to) in item.pairs)
                            _PairChip(from: from, to: to),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// "from -> to" shown as two chips joined by an arrow, always left to right
/// because the examples are in German, Dutch or Spanish.
class _PairChip extends StatelessWidget {
  const _PairChip({required this.from, required this.to});
  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget chip(String s, {bool strong = false}) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: strong
            ? scheme.primary.withValues(alpha: 0.14)
            : scheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: scheme.primary.withValues(alpha: strong ? 0.5 : 0.2),
        ),
      ),
      child: BidiText(
        s,
        style: TextStyle(
          fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          chip(from),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: scheme.primary,
            ),
          ),
          chip(to, strong: true),
        ],
      ),
    );
  }
}

class _GrammarTable extends StatelessWidget {
  const _GrammarTable({required this.headers, required this.rows});
  final List<String> headers;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: DataTable(
            headingRowColor: WidgetStatePropertyAll(
              scheme.primary.withValues(alpha: 0.12),
            ),
            headingTextStyle: TextStyle(
              fontWeight: FontWeight.w700,
              color: scheme.primary,
            ),
            columns: [for (final h in headers) DataColumn(label: BidiText(h))],
            rows: [
              for (final (i, row) in rows.indexed)
                DataRow(
                  color: WidgetStatePropertyAll(
                    i.isOdd
                        ? scheme.primary.withValues(alpha: 0.04)
                        : Colors.transparent,
                  ),
                  cells: [for (final cell in row) DataCell(BidiText(cell))],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Links to YouTube lessons on [topic]: explained in Arabic, in English and
/// in the language itself.
class YouTubeCard extends ConsumerWidget {
  const YouTubeCard({super.key, required this.topic, required this.lang});
  final String topic;
  final Lang lang;

  static const _native = {
    Lang.de: 'Deutsch erklärt',
    Lang.nl: 'Nederlands uitleg',
    Lang.es: 'español explicación',
  };

  /// A YouTube search for lessons on [topic] in [lang].
  static Uri searchUrl(String topic, Lang lang, String flavour) {
    final clean = topic
        .replaceAll(RegExp(r'[()]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return Uri.https('www.youtube.com', '/results', {
      'search_query': '$clean ${lang.nameEn} $flavour'.trim(),
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final explain = ref.watch(explainLangProvider);
    final options = [
      (
        Icons.translate,
        l.videoInArabic,
        searchUrl(topic, lang, 'grammar شرح بالعربي'),
      ),
      (
        Icons.language,
        l.videoInEnglish,
        searchUrl(topic, lang, 'grammar explained'),
      ),
      (
        Icons.record_voice_over,
        l.videoNative(lang.displayName(ref.watch(uiLanguageProvider))),
        searchUrl(topic, lang, _native[lang]!),
      ),
    ];
    if (explain == ExplainLang.en) {
      options.insert(0, options.removeAt(1));
    }
    return Glass(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0000),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BidiText(
                      l.videosTitle,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    BidiText(
                      l.videosHint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (icon, label, url) in options)
                ActionChip(
                  avatar: Icon(icon, size: 18),
                  label: BidiText(label),
                  onPressed: () =>
                      launchUrl(url, mode: LaunchMode.externalApplication),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The week of Piece of German (pieceofgerman.com, a free day-by-day German
/// plan with Arabic notes and curated videos) that matches our [level] and
/// unit [order]. We only link to it; the plan is the author's own.
Uri? pieceOfGermanUrl(String level, int order) {
  String? path;
  switch (level) {
    case 'A0':
      path = '/a1/week-1';
    case 'A1':
      path = order <= 12 ? '/a1/week-$order' : '/a1/exam-week';
    case 'A2':
      path = order <= 12 ? '/a2/week-$order' : '/a2';
    case 'B1':
      path = order <= 3 ? '/b1/week-$order' : '/b1';
    case 'B2':
      path = order <= 2 ? '/b2/lesson-$order' : '/b2';
    case 'C1':
      path = order <= 2 ? '/c1/lesson-$order' : '/c1';
  }
  return path == null ? null : Uri.https('www.pieceofgerman.com', path);
}

class PieceOfGermanCard extends StatelessWidget {
  const PieceOfGermanCard({super.key, required this.url});
  final Uri url;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: scheme.tertiaryContainer,
          child: Icon(Icons.event_note, color: scheme.onTertiaryContainer),
        ),
        title: BidiText(
          l.pieceOfGermanTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: BidiText(l.pieceOfGermanHint),
        trailing: const Icon(Icons.open_in_new),
        onTap: () => launchUrl(url, mode: LaunchMode.externalApplication),
      ),
    );
  }
}
