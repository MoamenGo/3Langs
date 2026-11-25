// Unified Polyglot Dictionary: every word and phrase of the selected
// languages in one searchable lexicon, with cross-language equivalents side
// by side, filters (language, part of speech, stage, tag), adding linked
// entries, and a quick self-test.

import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';
import 'controller.dart';
import 'models.dart';
import 'ui.dart';

class DictionaryScreen extends ConsumerStatefulWidget {
  const DictionaryScreen({super.key, this.query, this.group});
  final String? query;
  final String? group;

  @override
  ConsumerState<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends ConsumerState<DictionaryScreen> {
  late final _search = TextEditingController(text: widget.query ?? '');
  String? _lang; // null = every active language
  String? _pos;
  Stage? _stage;
  String? _tag;
  String? _group;
  bool _allLanguages = false;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
  }

  @override
  void didUpdateWidget(DictionaryScreen old) {
    super.didUpdateWidget(old);
    if (widget.query != old.query && widget.query != null) {
      _search.text = widget.query!;
    }
    if (widget.group != old.group) _group = widget.group;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matches(DictEntry e, String q) {
    if (q.isEmpty) return true;
    final hay = [
      e.term,
      e.meaningEn,
      e.meaningAr,
      e.ipa,
      e.example,
      e.note,
      ...e.tags,
    ].join(' ').toLowerCase();
    return hay.contains(q);
  }

  List<DictEntry> _filtered(PolyglotState s) {
    final q = _search.text.trim().toLowerCase();
    final langs = _allLanguages ? null : s.active.toSet();
    return [
      for (final e in s.dictionary)
        if ((langs == null || langs.contains(e.lang)) &&
            (_lang == null || e.lang == _lang) &&
            (_pos == null || e.pos == _pos) &&
            (_stage == null || e.stage == _stage) &&
            (_tag == null || e.tags.contains(_tag)) &&
            (_group == null || e.group == _group) &&
            _matches(e, q))
          e,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(polyglotProvider);
    final mx = context.mx;
    final results = _filtered(s);
    // Group matches by concept, keeping the dictionary order.
    final groups = <String, List<DictEntry>>{};
    for (final e in results) {
      (groups[e.group] ??= []).add(e);
    }
    final tagCounts = <String, int>{};
    for (final e in s.dictionary) {
      if (!s.active.contains(e.lang)) continue;
      for (final t in e.tags) {
        tagCounts[t] = (tagCounts[t] ?? 0) + 1;
      }
    }
    final topTags =
        (tagCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
            .take(12)
            .map((e) => e.key)
            .toList();
    final stageCounts = {
      for (final st in Stage.values)
        st: s.dictionary
            .where((e) => s.active.contains(e.lang) && e.stage == st)
            .length,
    };

    return Scaffold(
      body: Column(
        children: [
          PolyTopBar(
            title: context.tr('Unified Dictionary', 'القاموس الموحد'),
            subtitle: context.tr(
              'ONE LEXICON FOR ALL YOUR LANGUAGES',
              'قاموس واحد لكل لغاتك المختارة',
            ),
          ),
          Expanded(
            child: PageBody(
              maxWidth: 1100,
              children: [
                TextField(
                  key: const Key('dict-search'),
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: context.tr(
                      'Search a word, meaning, pronunciation or tag',
                      'ابحث بكلمة أو معنى أو نطق أو وسم',
                    ),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () => setState(_search.clear),
                            icon: const Icon(Icons.close),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                ChipRow(
                  children: [
                    FilterPill(
                      label: context.tr(
                        'All ${s.active.length} languages',
                        'كل اللغات (${s.active.length})',
                      ),
                      icon: Icons.layers_outlined,
                      selected: _lang == null,
                      onTap: () => setState(() => _lang = null),
                    ),
                    for (final l in s.activeLanguages)
                      LangChip(
                        lang: l,
                        selected: _lang == l.code,
                        onTap: () => setState(
                          () => _lang = _lang == l.code ? null : l.code,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                ChipRow(
                  children: [
                    for (final st in Stage.values)
                      FilterPill(
                        key: Key('stage-${st.name}'),
                        label: st.label(context.ui),
                        icon: stageIcon(st),
                        count: stageCounts[st],
                        selected: _stage == st,
                        onTap: () =>
                            setState(() => _stage = _stage == st ? null : st),
                      ),
                    _PosMenu(
                      value: _pos,
                      onChanged: (v) => setState(() => _pos = v),
                    ),
                    FilterPill(
                      label: context.tr(
                        'Include other languages',
                        'إظهار اللغات الأخرى',
                      ),
                      icon: Icons.public,
                      selected: _allLanguages,
                      onTap: () =>
                          setState(() => _allLanguages = !_allLanguages),
                    ),
                  ],
                ),
                if (topTags.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ChipRow(
                    spacing: 6,
                    children: [
                      for (final t in topTags)
                        Tag(
                          '#$t',
                          color: _tag == t ? mx.primary : mx.muted,
                          filled: _tag == t,
                          onTap: () =>
                              setState(() => _tag = _tag == t ? null : t),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      context.tr(
                        '${results.length} entries · ${groups.length} concepts',
                        '${results.length} مدخل · ${groups.length} مفهوم',
                      ),
                      style: monoStyle(context),
                    ),
                    if (_group != null)
                      TextButton.icon(
                        onPressed: () {
                          setState(() => _group = null);
                          context.go('/dictionary');
                        },
                        icon: const Icon(
                          Icons.filter_alt_off_outlined,
                          size: 18,
                        ),
                        label: Text(context.tr('Show all', 'عرض الكل')),
                      ),
                    OutlinedButton.icon(
                      key: const Key('dict-quiz'),
                      onPressed: results.isEmpty
                          ? null
                          : () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => QuizScreen(
                                  entryIds: [for (final e in results) e.id],
                                ),
                              ),
                            ),
                      icon: const Icon(Icons.quiz_outlined, size: 18),
                      label: Text(context.tr('Self-test', 'اختبار ذاتي')),
                    ),
                    FilledButton.icon(
                      key: const Key('dict-add'),
                      onPressed: () => showAddEntryDialog(context, ref),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(context.tr('Add word', 'إضافة كلمة')),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (groups.isEmpty)
                  Panel(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 36, color: mx.muted),
                        const SizedBox(height: 8),
                        Text(
                          context.tr(
                            'Nothing matches. Clear a filter or add the word yourself.',
                            'لا توجد نتائج. أزل أحد المرشحات أو أضف الكلمة بنفسك.',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () => showAddEntryDialog(
                            context,
                            ref,
                            initialTerm: _search.text.trim(),
                          ),
                          icon: const Icon(Icons.add),
                          label: Text(context.tr('Add a word', 'إضافة كلمة')),
                        ),
                      ],
                    ),
                  ),
                for (final g in groups.entries) ...[
                  _GroupCard(
                    key: ValueKey('group-${g.key}'),
                    entries: g.value,
                    all: [
                      for (final e in s.dictionary)
                        if (e.group == g.key) e,
                    ],
                    state: s,
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PosMenu extends StatelessWidget {
  const _PosMenu({required this.value, required this.onChanged});
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    tooltip: context.tr('Part of speech', 'نوع الكلمة'),
    onSelected: (v) => onChanged(v == '*' ? null : v),
    itemBuilder: (_) => [
      PopupMenuItem(
        value: '*',
        child: Text(context.tr('Any part of speech', 'كل الأنواع')),
      ),
      for (final p in partsOfSpeech)
        PopupMenuItem(value: p, child: Text(context.isAr ? posAr[p]! : p)),
    ],
    child: IgnorePointer(
      child: FilterPill(
        label: value == null
            ? context.tr('POS: any', 'النوع: الكل')
            : '${context.tr('POS', 'النوع')}: ${context.isAr ? posAr[value]! : value}',
        icon: Icons.category_outlined,
        selected: value != null,
        onTap: () {},
      ),
    ),
  );
}

/// One concept: its matching entries plus the other languages' equivalents.
class _GroupCard extends ConsumerWidget {
  const _GroupCard({
    super.key,
    required this.entries,
    required this.all,
    required this.state,
  });
  final List<DictEntry> entries;
  final List<DictEntry> all;
  final PolyglotState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final first = entries.first;
    final others = [
      for (final e in all)
        if (!entries.contains(e) && state.active.contains(e.lang)) e,
    ];
    return Panel(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Tag(
                context.isAr ? (posAr[first.pos] ?? first.pos) : first.pos,
                color: first.pos == 'verb' ? mx.primary : mx.amber,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  first.meaning(context.ui),
                  style: t.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                context.tr('${all.length} linked', '${all.length} مرتبطة'),
                style: monoStyle(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final e in entries)
            _EntryTile(entry: e, lang: state.lang(e.lang)),
          if (others.isNotEmpty) ...[
            const SizedBox(height: 4),
            Inset(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Wrap(
                spacing: 12,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    context.tr('Equivalents:', 'المقابلات:'),
                    style: t.labelSmall,
                  ),
                  for (final o in others)
                    Text(
                      '${state.lang(o.lang)?.flag ?? ''} ${o.gender.isNotEmpty && o.gender.length < 4 ? '${o.gender} ' : ''}${o.term}',
                      style: t.bodySmall!.copyWith(color: mx.ink),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _EntryTile extends ConsumerStatefulWidget {
  const _EntryTile({required this.entry, required this.lang});
  final DictEntry entry;
  final LanguageDef? lang;

  @override
  ConsumerState<_EntryTile> createState() => _EntryTileState();
}

class _EntryTileState extends ConsumerState<_EntryTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final l = widget.lang;
    final ctl = ref.read(polyglotProvider.notifier);
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final dir = dirOf(l);
    final hasMore =
        e.example.isNotEmpty || e.note.isNotEmpty || e.source.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: mx.rule, height: 1),
        InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  child: Row(
                    children: [
                      Text(
                        l?.flag ?? '🏳️',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          l?.iso3 ?? e.lang.toUpperCase(),
                          overflow: TextOverflow.clip,
                          softWrap: false,
                          style: monoStyle(context, size: 10.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        e.term,
                        key: Key('term-${e.id}'),
                        textDirection: dir,
                        style: t.titleMedium!.copyWith(
                          fontSize: l?.rtl == true ? 18 : 16,
                          height: l?.rtl == true ? 1.8 : 1.5,
                        ),
                      ),
                      if (e.gender.isNotEmpty)
                        Text(
                          e.gender,
                          textDirection: dir,
                          style: t.bodySmall!.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      if (e.ipa.isNotEmpty)
                        Text(
                          e.ipa,
                          textDirection: TextDirection.ltr,
                          style: ipaStyle(context).copyWith(fontSize: 12.5),
                        ),
                    ],
                  ),
                ),
                Tag(
                  // Icon only on narrow phones.
                  MediaQuery.sizeOf(context).width < 480
                      ? ''
                      : e.stage.label(context.ui),
                  key: Key('entry-stage-${e.id}'),
                  icon: stageIcon(e.stage),
                  color: stageColor(context, e.stage),
                  filled: e.stage == Stage.mastered,
                  onTap: () => ctl.setStage(e.id, e.stage.next),
                ),
                if (l != null)
                  IconButton(
                    tooltip: context.tr('Play', 'تشغيل'),
                    visualDensity: VisualDensity.compact,
                    color: mx.primary,
                    onPressed: () => speak(context, ref, e.term, l),
                    icon: const Icon(Icons.volume_up_outlined, size: 20),
                  ),
                PopupMenuButton<String>(
                  tooltip: context.tr('More', 'المزيد'),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (v) async {
                    if (v == 'edit') await showEditEntryDialog(context, ref, e);
                    if (v == 'delete') ctl.deleteEntry(e.id);
                    if (v == 'source' && context.mounted) {
                      openLink(context, e.source);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text(context.tr('Edit', 'تعديل')),
                    ),
                    if (e.source.isNotEmpty)
                      PopupMenuItem(
                        value: 'source',
                        child: Text(context.tr('Open source', 'فتح المصدر')),
                      ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(context.tr('Delete', 'حذف')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_open && hasMore)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 64, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (e.example.isNotEmpty)
                  Inset(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '“${e.example}”',
                          textDirection: dir,
                          style: t.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (e.exampleEn.isNotEmpty && e.lang != 'en')
                          Text(
                            e.exampleEn,
                            style: t.bodySmall!.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                if (e.note.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.record_voice_over_outlined,
                        size: 15,
                        color: mx.amber,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          e.note,
                          textDirection: TextDirection.ltr,
                          style: t.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
                if (e.source.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => openLink(context, e.source),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: Text(Uri.tryParse(e.source)?.host ?? e.source),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Adds one word in all active languages at once (linked as equivalents).
Future<void> showAddEntryDialog(
  BuildContext context,
  WidgetRef ref, {
  String initialTerm = '',
}) async {
  final s = ref.read(polyglotProvider);
  final terms = {
    for (final l in s.activeLanguages) l.code: TextEditingController(),
  };
  if (initialTerm.isNotEmpty && terms.isNotEmpty) {
    terms.values.first.text = initialTerm;
  }
  final meaning = TextEditingController();
  final meaningAr = TextEditingController();
  final tags = TextEditingController();
  final note = TextEditingController();
  var pos = 'noun';
  await showDialog<void>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => AlertDialog(
        title: Text(
          c.tr('Add a word in every language', 'إضافة كلمة بكل اللغات'),
        ),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.tr(
                    'Fill in the languages you know; the entries are linked as equivalents.',
                    'املأ اللغات التي تعرفها، وستُربط المدخلات كمقابلات لبعضها.',
                  ),
                  style: Theme.of(c).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                field(
                  meaning,
                  c.tr('Meaning in English', 'المعنى بالإنجليزية'),
                  key: const Key('add-meaning'),
                ),
                field(
                  meaningAr,
                  c.tr(
                    'Meaning in Arabic (optional)',
                    'المعنى بالعربية (اختياري)',
                  ),
                  dir: TextDirection.rtl,
                ),
                DropdownButtonFormField<String>(
                  initialValue: pos,
                  decoration: InputDecoration(
                    labelText: c.tr('Part of speech', 'نوع الكلمة'),
                  ),
                  items: [
                    for (final p in partsOfSpeech)
                      DropdownMenuItem(
                        value: p,
                        child: Text(c.isAr ? posAr[p]! : p),
                      ),
                  ],
                  onChanged: (v) => setState(() => pos = v ?? pos),
                ),
                const SizedBox(height: 12),
                for (final l in s.activeLanguages)
                  field(
                    terms[l.code]!,
                    '${l.flag} ${l.displayName(c.ui)}',
                    dir: dirOf(l),
                    key: Key('add-term-${l.code}'),
                  ),
                field(
                  tags,
                  c.tr('Tags (comma separated)', 'وسوم (مفصولة بفواصل)'),
                ),
                field(
                  note,
                  c.tr('Pronunciation or usage note', 'ملاحظة نطق أو استخدام'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(c.tr('Cancel', 'إلغاء')),
          ),
          FilledButton(
            key: const Key('add-save'),
            onPressed: () {
              final filled = {
                for (final e in terms.entries)
                  if (e.value.text.trim().isNotEmpty)
                    e.key: e.value.text.trim(),
              };
              if (filled.isEmpty) return;
              ref
                  .read(polyglotProvider.notifier)
                  .addWordGroup(
                    terms: filled,
                    pos: pos,
                    meaningEn: meaning.text.trim().isEmpty
                        ? filled.values.first
                        : meaning.text.trim(),
                    meaningAr: meaningAr.text.trim(),
                    tags: [
                      for (final t in tags.text.split(','))
                        if (t.trim().isNotEmpty) t.trim(),
                    ],
                    note: note.text.trim(),
                  );
              Navigator.pop(c);
            },
            child: Text(c.tr('Save', 'حفظ')),
          ),
        ],
      ),
    ),
  );
}

Future<void> showEditEntryDialog(
  BuildContext context,
  WidgetRef ref,
  DictEntry e,
) async {
  final lang = ref.read(polyglotProvider).lang(e.lang);
  final term = TextEditingController(text: e.term);
  final gender = TextEditingController(text: e.gender);
  final ipa = TextEditingController(text: e.ipa);
  final meaning = TextEditingController(text: e.meaningEn);
  final meaningAr = TextEditingController(text: e.meaningAr);
  final example = TextEditingController(text: e.example);
  final note = TextEditingController(text: e.note);
  final tags = TextEditingController(text: e.tags.join(', '));
  final source = TextEditingController(text: e.source);
  var pos = partsOfSpeech.contains(e.pos) ? e.pos : 'other';
  await showDialog<void>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => AlertDialog(
        title: Text('${lang?.flag ?? ''} ${e.term}'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                field(
                  term,
                  c.tr('Word or phrase', 'الكلمة أو العبارة'),
                  dir: dirOf(lang),
                ),
                Row(
                  children: [
                    Expanded(
                      child: field(
                        gender,
                        c.tr('Article / gender', 'الأداة / الجنس'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DropdownButtonFormField<String>(
                          initialValue: pos,
                          decoration: InputDecoration(
                            labelText: c.tr('Part of speech', 'نوع الكلمة'),
                          ),
                          items: [
                            for (final p in partsOfSpeech)
                              DropdownMenuItem(
                                value: p,
                                child: Text(c.isAr ? posAr[p]! : p),
                              ),
                          ],
                          onChanged: (v) => setState(() => pos = v ?? pos),
                        ),
                      ),
                    ),
                  ],
                ),
                field(ipa, 'IPA', dir: TextDirection.ltr),
                field(
                  meaning,
                  c.tr('Meaning in English', 'المعنى بالإنجليزية'),
                ),
                field(
                  meaningAr,
                  c.tr('Meaning in Arabic', 'المعنى بالعربية'),
                  dir: TextDirection.rtl,
                ),
                field(
                  example,
                  c.tr('Example sentence', 'جملة مثال'),
                  dir: dirOf(lang),
                  maxLines: 2,
                ),
                field(note, c.tr('Note', 'ملاحظة'), maxLines: 2),
                field(
                  tags,
                  c.tr('Tags (comma separated)', 'وسوم (مفصولة بفواصل)'),
                ),
                field(
                  source,
                  c.tr('Source link', 'رابط المصدر'),
                  dir: TextDirection.ltr,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(c.tr('Cancel', 'إلغاء')),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(polyglotProvider.notifier)
                  .updateEntry(
                    e.copyWith(
                      term: term.text.trim().isEmpty
                          ? e.term
                          : term.text.trim(),
                      gender: gender.text.trim(),
                      pos: pos,
                      ipa: ipa.text.trim(),
                      meaningEn: meaning.text.trim(),
                      meaningAr: meaningAr.text.trim(),
                      example: example.text.trim(),
                      note: note.text.trim(),
                      tags: [
                        for (final t in tags.text.split(','))
                          if (t.trim().isNotEmpty) t.trim(),
                      ],
                      source: source.text.trim(),
                    ),
                  );
              Navigator.pop(c);
            },
            child: Text(c.tr('Save', 'حفظ')),
          ),
        ],
      ),
    ),
  );
}

/// Quick self-test over the filtered entries: see the word, recall its
/// meaning and equivalents, then say whether you knew it.
class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, required this.entryIds});
  final List<String> entryIds;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  late final List<String> _ids;
  int _i = 0;
  bool _shown = false;
  int _knew = 0;

  @override
  void initState() {
    super.initState();
    final s = ref.read(polyglotProvider);
    final byId = {for (final e in s.dictionary) e.id: e};
    // Words not mastered yet come first; at most 20 per round.
    _ids = [...widget.entryIds]..shuffle(math.Random());
    _ids.sort(
      (a, b) =>
          (byId[a]?.stage.index ?? 0).compareTo(byId[b]?.stage.index ?? 0),
    );
    if (_ids.length > 20) _ids.removeRange(20, _ids.length);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(polyglotProvider);
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final done = _i >= _ids.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Self-test', 'اختبار ذاتي')),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Center(
              child: Text(
                '${math.min(_i + 1, _ids.length)} / ${_ids.length}',
                style: monoStyle(context, size: 12),
              ),
            ),
          ),
        ],
      ),
      body: PageBody(
        maxWidth: 640,
        children: [
          LinearProgressIndicator(value: _ids.isEmpty ? 1 : _i / _ids.length),
          const SizedBox(height: 20),
          if (done)
            Panel(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.emoji_events_outlined, size: 48, color: mx.amber),
                  const SizedBox(height: 12),
                  Text(
                    context.tr(
                      'You knew $_knew of ${_ids.length}',
                      'عرفت $_knew من ${_ids.length}',
                    ),
                    style: t.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.tr(
                      'Known words moved up a stage; missed ones are back to "learning".',
                      'الكلمات التي عرفتها ارتقت مرحلة، والتي فاتتك عادت إلى "قيد التعلم".',
                    ),
                    textAlign: TextAlign.center,
                    style: t.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const Key('quiz-done'),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      context.tr(
                        'Back to the dictionary',
                        'العودة إلى القاموس',
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Builder(
              builder: (context) {
                final e = s.dictionary.firstWhere(
                  (x) => x.id == _ids[_i],
                  orElse: () => s.dictionary.first,
                );
                final l = s.lang(e.lang);
                final eq = [
                  for (final o in s.dictionary)
                    if (o.group == e.group &&
                        o.id != e.id &&
                        s.active.contains(o.lang))
                      o,
                ];
                return Panel(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      if (l != null) LangBadge(l),
                      const SizedBox(height: 20),
                      Text(
                        '${e.gender.isNotEmpty && e.gender.length < 4 ? '${e.gender} ' : ''}${e.term}',
                        key: const Key('quiz-term'),
                        textAlign: TextAlign.center,
                        textDirection: dirOf(l),
                        style: t.displaySmall!.copyWith(
                          height: l?.rtl == true ? 1.8 : 1.3,
                        ),
                      ),
                      if (e.ipa.isNotEmpty)
                        Text(
                          e.ipa,
                          textDirection: TextDirection.ltr,
                          style: ipaStyle(context),
                        ),
                      if (l != null)
                        IconButton(
                          color: mx.primary,
                          onPressed: () => speak(context, ref, e.term, l),
                          icon: const Icon(Icons.volume_up_outlined),
                        ),
                      const SizedBox(height: 12),
                      if (!_shown)
                        FilledButton(
                          key: const Key('quiz-show'),
                          onPressed: () => setState(() => _shown = true),
                          child: Text(
                            context.tr('Show meaning', 'أظهر المعنى'),
                          ),
                        )
                      else ...[
                        Inset(
                          child: Column(
                            children: [
                              Text(
                                e.meaning(context.ui),
                                style: t.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                              if (eq.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 4,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    for (final o in eq)
                                      Text(
                                        '${s.lang(o.lang)?.flag ?? ''} ${o.term}',
                                        style: t.bodyMedium,
                                      ),
                                  ],
                                ),
                              ],
                              if (e.example.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  '“${e.example}”',
                                  textDirection: dirOf(l),
                                  style: t.bodySmall,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                key: const Key('quiz-missed'),
                                onPressed: () => _answer(e.id, false),
                                icon: const Icon(Icons.close),
                                label: Text(
                                  context.tr("Didn't know", 'لم أعرفها'),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton.icon(
                                key: const Key('quiz-knew'),
                                onPressed: () => _answer(e.id, true),
                                icon: const Icon(Icons.check),
                                label: Text(context.tr('Knew it', 'عرفتها')),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _answer(String id, bool knew) {
    ref.read(polyglotProvider.notifier).quizAnswer(id, knew);
    setState(() {
      if (knew) _knew++;
      _i++;
      _shown = false;
    });
  }
}
