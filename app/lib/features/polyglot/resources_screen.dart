// Free Resources Hub (مصادر التعلم المجانية): a filterable library of free
// videos, open books, podcasts and tools, grouped by language, with
// bookmarks and the learner's own links. Also the drawer opened from the
// Matrix hub.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';
import 'controller.dart';
import 'models.dart';
import 'ui.dart';

class ResourcesScreen extends ConsumerStatefulWidget {
  const ResourcesScreen({super.key});

  @override
  ConsumerState<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends ConsumerState<ResourcesScreen> {
  final _q = TextEditingController();
  bool _mine = true; // only the active languages
  String? _lang;
  ResourceFormat? _format;
  Skill? _skill;
  bool _saved = false;

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(polyglotProvider);
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final q = _q.text.trim().toLowerCase();
    bool keep(Resource r) =>
        (!_mine || s.active.any(r.covers)) &&
        (_lang == null || r.covers(_lang!)) &&
        (_format == null || r.format == _format) &&
        (_skill == null || r.skills.contains(_skill)) &&
        (!_saved || s.bookmarks.contains(r.id)) &&
        (q.isEmpty ||
            [
              r.title,
              r.descEn,
              r.descAr,
              r.provider,
              r.level,
            ].join(' ').toLowerCase().contains(q));
    final list = s.resources.where(keep).toList();

    // Group: one track per language (resources made for it), then the
    // multi-language tools.
    final langs = _lang != null
        ? [s.lang(_lang!)].whereType<LanguageDef>().toList()
        : (_mine ? s.activeLanguages : s.languages);
    final sections = <(String, String, List<Resource>)>[];
    final used = <String>{};
    for (final l in langs) {
      final items = [
        for (final r in list)
          if (!r.langs.contains('*') &&
              r.langs.length <= 2 &&
              r.langs.contains(l.code))
            r,
      ];
      used.addAll(items.map((r) => r.id));
      if (items.isNotEmpty) {
        sections.add((
          '${l.flag}  ${context.tr('${l.name} free track', 'مسار ${l.nameAr} المجاني')}',
          l.code,
          items,
        ));
      }
    }
    final multi = [
      for (final r in list)
        if (!used.contains(r.id)) r,
    ];
    if (multi.isNotEmpty) {
      sections.add((
        '🌐  ${context.tr('For every language', 'لكل اللغات')}',
        '*',
        multi,
      ));
    }

    return Scaffold(
      body: Column(
        children: [
          PolyTopBar(
            title: context.tr('Free Resources Hub', 'مصادر التعلم المجانية'),
            subtitle: context.tr(
              'OPEN CORPUS ARCHIVE',
              'أرشيف المصادر المفتوحة',
            ),
          ),
          Expanded(
            child: PageBody(
              maxWidth: 1200,
              children: [
                SectionLabel(
                  context.tr('Open corpus archive', 'أرشيف المصادر المفتوحة'),
                  icon: Icons.public,
                ),
                const SizedBox(height: 6),
                Text(
                  context.tr(
                    'Curated free learning resources',
                    'مصادر تعلم مجانية مختارة',
                  ),
                  style: t.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr(
                    'Free video courses, open textbooks, podcasts and practice tools for every skill. All links open the original site.',
                    'دورات فيديو مجانية وكتب مفتوحة وبودكاست وأدوات تدريب لكل مهارة. كل الروابط تفتح الموقع الأصلي.',
                  ),
                  style: t.bodyMedium!.copyWith(color: mx.muted),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _q,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: context.tr('Search resources', 'ابحث في المصادر'),
                  ),
                ),
                const SizedBox(height: 10),
                ChipRow(
                  spacing: 6,
                  children: [
                    FilterPill(
                      key: const Key('res-mine'),
                      label: context.tr('My languages', 'لغاتي'),
                      icon: Icons.layers_outlined,
                      count: s.active.length,
                      selected: _mine && _lang == null,
                      onTap: () => setState(() {
                        _mine = true;
                        _lang = null;
                      }),
                    ),
                    FilterPill(
                      label: context.tr('All languages', 'كل اللغات'),
                      selected: !_mine && _lang == null,
                      onTap: () => setState(() {
                        _mine = false;
                        _lang = null;
                      }),
                    ),
                    for (final l in (_mine ? s.activeLanguages : s.languages))
                      LangChip(
                        lang: l,
                        selected: _lang == l.code,
                        onTap: () => setState(
                          () => _lang = _lang == l.code ? null : l.code,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ChipRow(
                  spacing: 6,
                  children: [
                    FilterPill(
                      label: context.tr('All types', 'كل الأنواع'),
                      selected: _format == null,
                      onTap: () => setState(() => _format = null),
                    ),
                    for (final f in ResourceFormat.values)
                      FilterPill(
                        key: Key('format-${f.name}'),
                        label: f.label(context.ui),
                        icon: formatIcon(f),
                        selected: _format == f,
                        onTap: () =>
                            setState(() => _format = _format == f ? null : f),
                      ),
                    FilterPill(
                      key: const Key('res-saved'),
                      label: context.tr('Bookmarked', 'المفضلة'),
                      icon: Icons.bookmark_outline,
                      count: s.bookmarks.length,
                      selected: _saved,
                      onTap: () => setState(() => _saved = !_saved),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ChipRow(
                  spacing: 6,
                  children: [
                    for (final sk in Skill.values)
                      Tag(
                        sk.label(context.ui),
                        icon: skillIcon(sk),
                        color: _skill == sk ? mx.primary : mx.muted,
                        filled: _skill == sk,
                        onTap: () =>
                            setState(() => _skill = _skill == sk ? null : sk),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                if (list.isEmpty)
                  Panel(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      context.tr(
                        'No resources match. Clear a filter or add your own below.',
                        'لا توجد مصادر مطابقة. أزل أحد المرشحات أو أضف مصدرك بالأسفل.',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                for (final (title, _, items) in sections) ...[
                  Row(
                    children: [
                      Expanded(child: Text(title, style: t.titleLarge)),
                      Text(
                        context.tr(
                          '${items.length} open resources',
                          '${items.length} مصادر مفتوحة',
                        ),
                        style: monoStyle(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _ResourceGrid(items: items, state: s),
                  const SizedBox(height: 22),
                ],
                _SuggestCard(onAdd: () => showAddResourceDialog(context, ref)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceGrid extends StatelessWidget {
  const _ResourceGrid({required this.items, required this.state});
  final List<Resource> items;
  final PolyglotState state;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      const gap = 12.0;
      final cols = ((c.maxWidth + gap) / (340 + gap)).floor().clamp(1, 3);
      final w = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final r in items)
            SizedBox(
              width: w,
              child: ResourceCard(resource: r, state: state),
            ),
        ],
      );
    },
  );
}

class ResourceCard extends ConsumerWidget {
  const ResourceCard({super.key, required this.resource, required this.state});
  final Resource resource;
  final PolyglotState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = resource;
    final ctl = ref.read(polyglotProvider.notifier);
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final saved = state.bookmarks.contains(r.id);
    final flags = r.langs.contains('*')
        ? '🌐'
        : [for (final l in r.langs) state.lang(l)?.flag ?? ''].join(' ');
    return Panel(
      key: Key('res-${r.id}'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Tag(
                  r.format.label(context.ui),
                  icon: formatIcon(r.format),
                  color: mx.ink,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                r.level,
                style: monoStyle(context, size: 10.5),
                textDirection: TextDirection.ltr,
              ),
              const Spacer(),
              IconButton(
                key: Key('bookmark-${r.id}'),
                tooltip: saved
                    ? context.tr('Remove bookmark', 'إزالة من المفضلة')
                    : context.tr('Bookmark', 'إضافة للمفضلة'),
                visualDensity: VisualDensity.compact,
                color: saved ? mx.amber : mx.muted,
                onPressed: () => ctl.toggleBookmark(r.id),
                icon: Icon(saved ? Icons.bookmark : Icons.bookmark_outline),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Tag(
            context.tr('Free', 'مجاني') +
                (r.provider.isEmpty ? '' : ' · ${r.provider}'),
            color: mx.primary,
          ),
          const SizedBox(height: 8),
          Text(r.title, style: t.titleMedium, textDirection: TextDirection.ltr),
          const SizedBox(height: 4),
          Text(r.desc(context.ui), style: t.bodySmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(flags, style: const TextStyle(fontSize: 14)),
              for (final sk in r.skills)
                Tag(
                  sk.label(context.ui),
                  icon: skillIcon(sk),
                  color: mx.primary,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  key: Key('open-${r.id}'),
                  onPressed: () => openLink(context, r.url),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: Text(context.tr('Open source', 'فتح المصدر')),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.outlined(
                key: Key('note-${r.id}'),
                tooltip: context.tr('Add to notebook', 'أضف إلى المذكرة'),
                onPressed: () {
                  ctl.saveNote(
                    ctl.newNote(
                      title: r.title,
                      link: r.url,
                      skill: r.skills.isEmpty ? null : r.skills.first,
                    ),
                  );
                  showSnack(
                    context,
                    context.tr('Added to your notebook', 'أضيف إلى مذكرتك'),
                  );
                },
                icon: const Icon(Icons.note_add_outlined, size: 18),
              ),
              if (r.custom)
                IconButton(
                  tooltip: context.tr('Delete', 'حذف'),
                  onPressed: () => ctl.deleteResource(r.id),
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuggestCard extends StatelessWidget {
  const _SuggestCard({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    return Panel(
      color: mx.surface2,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_link, color: mx.amber),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.tr(
                    'Add your own free resource',
                    'أضف مصدرًا مجانيًا خاصًا بك',
                  ),
                  style: t.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            context.tr(
              'Found a free course, book, channel or tool? Save it here with its languages and skills.',
              'وجدت دورة أو كتابًا أو قناة أو أداة مجانية؟ احفظها هنا مع لغاتها ومهاراتها.',
            ),
            style: t.bodySmall,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            key: const Key('add-resource'),
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(context.tr('Add resource link', 'إضافة رابط مصدر')),
          ),
        ],
      ),
    );
  }
}

Future<void> showAddResourceDialog(BuildContext context, WidgetRef ref) async {
  final s = ref.read(polyglotProvider);
  final title = TextEditingController();
  final url = TextEditingController(text: 'https://');
  final desc = TextEditingController();
  final level = TextEditingController(text: 'A1-B2');
  final langs = <String>{...s.active.take(1)};
  var format = ResourceFormat.video;
  final skills = <Skill>{Skill.listening};
  String? error;
  await showDialog<void>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => AlertDialog(
        title: Text(c.tr('Add a free resource', 'إضافة مصدر مجاني')),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                field(
                  title,
                  c.tr('Title', 'العنوان'),
                  key: const Key('res-title'),
                ),
                field(
                  url,
                  c.tr('Link', 'الرابط'),
                  dir: TextDirection.ltr,
                  key: const Key('res-url'),
                ),
                field(
                  desc,
                  c.tr('What is it good for?', 'فيمَ يفيد؟'),
                  maxLines: 2,
                ),
                field(
                  level,
                  c.tr('Level (e.g. A1-B1)', 'المستوى (مثل A1-B1)'),
                  dir: TextDirection.ltr,
                ),
                Text(
                  c.tr('Languages', 'اللغات'),
                  style: Theme.of(c).textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    FilterChip(
                      label: Text('🌐 ${c.tr('Any', 'أي لغة')}'),
                      selected: langs.contains('*'),
                      onSelected: (on) => setState(
                        () => on ? langs.add('*') : langs.remove('*'),
                      ),
                    ),
                    for (final l in s.languages)
                      FilterChip(
                        label: Text('${l.flag} ${l.iso3}'),
                        selected: langs.contains(l.code),
                        onSelected: (on) => setState(
                          () => on ? langs.add(l.code) : langs.remove(l.code),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  c.tr('Format', 'النوع'),
                  style: Theme.of(c).textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final f in ResourceFormat.values)
                      ChoiceChip(
                        label: Text(f.label(c.ui)),
                        selected: format == f,
                        onSelected: (_) => setState(() => format = f),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  c.tr('Skills', 'المهارات'),
                  style: Theme.of(c).textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final sk in Skill.values)
                      FilterChip(
                        label: Text(sk.label(c.ui)),
                        selected: skills.contains(sk),
                        onSelected: (on) => setState(
                          () => on ? skills.add(sk) : skills.remove(sk),
                        ),
                      ),
                  ],
                ),
                if (error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    error!,
                    style: TextStyle(color: Theme.of(c).colorScheme.error),
                  ),
                ],
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
            key: const Key('res-save'),
            onPressed: () {
              final u = Uri.tryParse(url.text.trim());
              if (title.text.trim().isEmpty ||
                  u == null ||
                  !(u.isScheme('http') || u.isScheme('https')) ||
                  u.host.isEmpty) {
                setState(
                  () => error = c.tr(
                    'Give a title and a full http(s) link.',
                    'أدخل عنوانًا ورابطًا كاملًا يبدأ بـ http(s).',
                  ),
                );
                return;
              }
              if (langs.isEmpty) langs.add('*');
              final ctl = ref.read(polyglotProvider.notifier);
              ctl.addResource(
                Resource(
                  id: ctl.newResourceId(),
                  title: title.text.trim(),
                  url: u.toString(),
                  langs: langs.toList(),
                  format: format,
                  skills: skills.toList(),
                  level: level.text.trim(),
                  descEn: desc.text.trim(),
                  provider: u.host,
                  custom: true,
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

/// Bottom drawer opened from the hub: resources for the active languages.
Future<void> showResourcesDrawer(BuildContext context, WidgetRef ref) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (c) => Consumer(
        builder: (c, ref, _) {
          final s = ref.watch(polyglotProvider);
          final items =
              [
                for (final r in s.resources)
                  if (s.active.any(r.covers)) r,
              ]..sort((a, b) {
                // Bookmarks first, then language-specific before general.
                final ba = s.bookmarks.contains(a.id) ? 0 : 1;
                final bb = s.bookmarks.contains(b.id) ? 0 : 1;
                if (ba != bb) return ba - bb;
                return (a.langs.contains('*') ? 1 : 0) -
                    (b.langs.contains('*') ? 1 : 0);
              });
          return SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(c).height * 0.85,
              ),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.tr(
                            'Free resources for your languages',
                            'مصادر مجانية للغاتك',
                          ),
                          style: Theme.of(c).textTheme.titleLarge,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(c);
                          context.go('/resources');
                        },
                        child: Text(c.tr('Open hub', 'فتح المركز')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final r in items.take(12)) ...[
                    ResourceCard(resource: r, state: s),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
