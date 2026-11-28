// Dialogs for languages: add a custom language, manage active languages
// and levels, and write or correct one language's line of a concept.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/lang/lang.dart' show cefrLevels;
import '../../core/theme.dart';
import 'controller.dart';
import 'models.dart';
import 'ui.dart';

/// Ready-made picks for common extra languages.
const _presets = [
  ('it', 'Italian', 'الإيطالية', 'Italiano', '🇮🇹', 'it-IT', false),
  ('pt', 'Portuguese', 'البرتغالية', 'Português', '🇵🇹', 'pt-PT', false),
  ('tr', 'Turkish', 'التركية', 'Türkçe', '🇹🇷', 'tr-TR', false),
  ('ru', 'Russian', 'الروسية', 'Русский', '🇷🇺', 'ru-RU', false),
  ('sv', 'Swedish', 'السويدية', 'Svenska', '🇸🇪', 'sv-SE', false),
  ('ja', 'Japanese', 'اليابانية', '日本語', '🇯🇵', 'ja-JP', false),
  ('zh', 'Chinese', 'الصينية', '中文', '🇨🇳', 'zh-CN', false),
  ('fa', 'Persian', 'الفارسية', 'فارسی', '🇮🇷', 'fa-IR', true),
  ('he', 'Hebrew', 'العبرية', 'עברית', '🇮🇱', 'he-IL', true),
];

const _palette = [
  0xFF6A4C93,
  0xFF1982C4,
  0xFF8AC926,
  0xFFC87D28,
  0xFF5A6572,
  0xFFB5179E,
];

Future<void> showAddLanguageDialog(BuildContext context, WidgetRef ref) async {
  final name = TextEditingController();
  final nameAr = TextEditingController();
  final native = TextEditingController();
  final code = TextEditingController();
  final flag = TextEditingController();
  final tts = TextEditingController();
  var rtl = false;
  var level = 'A0';
  String? error;
  final existing = {
    for (final l in ref.read(polyglotProvider).languages) l.code,
  };

  await showDialog<void>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => AlertDialog(
        title: Text(c.tr('Add a language', 'إضافة لغة')),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.tr('Quick picks', 'اختيارات سريعة'),
                  style: Theme.of(c).textTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final p in _presets)
                      if (!existing.contains(p.$1))
                        ActionChip(
                          key: Key('preset-${p.$1}'),
                          label: Text('${p.$5} ${c.isAr ? p.$3 : p.$2}'),
                          onPressed: () => setState(() {
                            code.text = p.$1;
                            name.text = p.$2;
                            nameAr.text = p.$3;
                            native.text = p.$4;
                            flag.text = p.$5;
                            tts.text = p.$6;
                            rtl = p.$7;
                          }),
                        ),
                  ],
                ),
                const SizedBox(height: 16),
                field(
                  name,
                  c.tr('Name in English', 'الاسم بالإنجليزية'),
                  key: const Key('lang-name'),
                ),
                field(
                  nameAr,
                  c.tr('Name in Arabic (optional)', 'الاسم بالعربية (اختياري)'),
                  dir: TextDirection.rtl,
                ),
                field(
                  native,
                  c.tr('Name in the language itself', 'اسم اللغة بلغتها'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: field(
                        code,
                        c.tr('ISO code (it, pt...)', 'رمز ISO ‏(it, pt...)'),
                        key: const Key('lang-code'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: field(flag, c.tr('Flag emoji', 'علم (إيموجي)')),
                    ),
                  ],
                ),
                field(
                  tts,
                  c.tr('Speech locale (it-IT)', 'لغة النطق (it-IT)'),
                  hint: c.tr(
                    'Leave empty to use the ISO code',
                    'اتركه فارغًا لاستخدام الرمز',
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: level,
                        decoration: InputDecoration(
                          labelText: c.tr('My level', 'مستواي'),
                        ),
                        items: [
                          for (final l in cefrLevels)
                            DropdownMenuItem(value: l, child: Text(l)),
                        ],
                        onChanged: (v) => setState(() => level = v ?? level),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(c.tr('Right to left', 'من اليمين لليسار')),
                        value: rtl,
                        onChanged: (v) => setState(() => rtl = v),
                      ),
                    ),
                  ],
                ),
                if (error != null)
                  Text(
                    error!,
                    style: TextStyle(color: Theme.of(c).colorScheme.error),
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
            key: const Key('lang-save'),
            onPressed: () {
              final cd = code.text.trim().toLowerCase();
              if (name.text.trim().isEmpty ||
                  !RegExp(r'^[a-z]{2,3}$').hasMatch(cd)) {
                setState(
                  () => error = c.tr(
                    'Give a name and a 2–3 letter code.',
                    'أدخل اسمًا ورمزًا من حرفين أو ثلاثة.',
                  ),
                );
                return;
              }
              if (existing.contains(cd)) {
                setState(
                  () => error = c.tr(
                    'This language is already in the list.',
                    'هذه اللغة موجودة بالفعل.',
                  ),
                );
                return;
              }
              ref
                  .read(polyglotProvider.notifier)
                  .addLanguage(
                    LanguageDef(
                      code: cd,
                      name: name.text.trim(),
                      nameAr: nameAr.text.trim().isEmpty
                          ? name.text.trim()
                          : nameAr.text.trim(),
                      nativeName: native.text.trim().isEmpty
                          ? name.text.trim()
                          : native.text.trim(),
                      flag: flag.text.trim().isEmpty ? '🏳️' : flag.text.trim(),
                      tts: tts.text.trim().isEmpty ? cd : tts.text.trim(),
                      rtl: rtl,
                      level: level,
                      custom: true,
                      colorValue: _palette[existing.length % _palette.length],
                    ),
                  );
              Navigator.pop(c);
              showSnack(
                context,
                context.tr(
                  '${name.text.trim()} added. Use "Add your translation" on each card to fill it in.',
                  'تمت إضافة ${name.text.trim()}. استعمل "أضف ترجمتك" في كل بطاقة لتعبئتها.',
                ),
              );
            },
            child: Text(c.tr('Add', 'إضافة')),
          ),
        ],
      ),
    ),
  );
}

Future<void> showManageLanguages(
  BuildContext context,
  WidgetRef ref,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (c) => Consumer(
    builder: (c, ref, _) {
      final s = ref.watch(polyglotProvider);
      final ctl = ref.read(polyglotProvider.notifier);
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(c).height * 0.8,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Text(
                c.tr('Languages & levels', 'اللغات والمستويات'),
                style: Theme.of(c).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                c.tr(
                  'Tick the languages to study together. Four or more is the Polyglot Matrix sweet spot; the planner shares your time between them.',
                  'اختر اللغات التي تدرسها معًا. أربع لغات أو أكثر هو المثالي، والمخطط يوزع وقتك بينها.',
                ),
                style: Theme.of(c).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              for (final l in s.languages)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Checkbox(
                    value: s.active.contains(l.code),
                    onChanged: (_) => ctl.toggleLanguage(l.code),
                  ),
                  title: Text('${l.flag}  ${l.displayName(c.ui)}'),
                  subtitle: Text(
                    '${l.nativeName} · ${l.iso3}${l.rtl ? ' · RTL' : ''}${l.custom ? ' · ${c.tr('custom', 'مخصصة')}' : ''}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<String>(
                        value: cefrLevels.contains(l.level) ? l.level : 'A1',
                        underline: const SizedBox(),
                        items: [
                          for (final v in cefrLevels)
                            DropdownMenuItem(value: v, child: Text(v)),
                        ],
                        onChanged: (v) => ctl.setLevel(l.code, v ?? l.level),
                      ),
                      if (l.custom)
                        IconButton(
                          tooltip: c.tr('Remove', 'حذف'),
                          onPressed: () => ctl.removeLanguage(l.code),
                          icon: const Icon(Icons.delete_outline),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(c);
                  showAddLanguageDialog(context, ref);
                },
                icon: const Icon(Icons.add),
                label: Text(c.tr('Add a custom language', 'إضافة لغة مخصصة')),
              ),
            ],
          ),
        ),
      );
    },
  ),
);

Future<void> showEditLineDialog(
  BuildContext context,
  WidgetRef ref,
  Concept concept,
  LanguageDef lang,
) async {
  final line = concept.lines[lang.code];
  final text = TextEditingController(text: line?.text ?? '');
  final ipa = TextEditingController(text: line?.ipa ?? '');
  final lit = TextEditingController(text: line?.literal ?? '');
  await showDialog<void>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text('${lang.flag} ${concept.title(c.ui)}'),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Inset(
              child: Text(
                '${c.tr('Meaning', 'المعنى')}: ${concept.meaning(c.ui)}',
                style: Theme.of(c).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 12),
            field(
              text,
              c.tr('In ${lang.name}', 'باللغة ${lang.nameAr}'),
              dir: dirOf(lang),
              key: const Key('line-text'),
            ),
            field(
              ipa,
              c.tr(
                'IPA / transliteration (optional)',
                'النطق الصوتي (اختياري)',
              ),
              dir: TextDirection.ltr,
            ),
            field(
              lit,
              c.tr(
                'Word-for-word gloss (optional)',
                'الترجمة الحرفية (اختياري)',
              ),
              dir: TextDirection.ltr,
            ),
            Text(
              c.tr(
                'Tip: check your line on Tatoeba or with a native speaker.',
                'نصيحة: راجع جملتك على Tatoeba أو مع متحدث أصلي.',
              ),
              style: Theme.of(c).textTheme.bodySmall!
                  .copyWith(color: c.mx.muted),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: Text(c.tr('Cancel', 'إلغاء')),
        ),
        FilledButton(
          key: const Key('line-save'),
          onPressed: () {
            if (text.text.trim().isEmpty) return;
            ref
                .read(polyglotProvider.notifier)
                .setLine(
                  concept.id,
                  lang.code,
                  ConceptLine(
                    text: text.text.trim(),
                    ipa: ipa.text.trim(),
                    literal: lit.text.trim(),
                  ),
                );
            Navigator.pop(c);
          },
          child: Text(c.tr('Save', 'حفظ')),
        ),
      ],
    ),
  );
}
