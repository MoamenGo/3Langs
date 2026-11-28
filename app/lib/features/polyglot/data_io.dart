// JSON export / import of everything in the Polyglot Matrix module
// (languages, deck, dictionary, notebook, planner, resources, bookmarks).

import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'controller.dart';
import 'file_io_stub.dart' if (dart.library.js_interop) 'file_io_web.dart';
import 'models.dart';
import 'ui.dart';

String _fileName() => 'polyglot-matrix-${dayKey(DateTime.now())}.json';

Future<void> exportData(BuildContext context, WidgetRef ref) async {
  final json = ref.read(polyglotProvider).encode(pretty: true);
  if (canUseFiles && downloadText(_fileName(), json)) {
    showSnack(
      context,
      context.tr('Saved ${_fileName()}', 'تم حفظ ${_fileName()}'),
    );
    return;
  }
  await showDialog<void>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(c.tr('Export data', 'تصدير البيانات')),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              c.tr(
                'Copy this JSON and keep it somewhere safe. Import it on another device to move your data.',
                'انسخ هذا الملف واحفظه في مكان آمن. استورده على جهاز آخر لنقل بياناتك.',
              ),
            ),
            const SizedBox(height: 12),
            Inset(
              child: SizedBox(
                height: 220,
                child: SingleChildScrollView(
                  child: SelectableText(
                    json,
                    textDirection: TextDirection.ltr,
                    style: monoStyle(c, size: 11),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: Text(c.tr('Close', 'إغلاق')),
        ),
        FilledButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: json));
            if (c.mounted) {
              Navigator.pop(c);
              showSnack(context, context.tr('Copied', 'تم النسخ'));
            }
          },
          icon: const Icon(Icons.copy),
          label: Text(c.tr('Copy JSON', 'نسخ JSON')),
        ),
      ],
    ),
  );
}

Future<void> importData(BuildContext context, WidgetRef ref) async {
  final text = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(c.tr('Import data', 'استيراد البيانات')),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              c.tr(
                'Choose a Polyglot Matrix .json export, or paste its text. This replaces the data on this device.',
                'اختر ملف تصدير ‎.json أو الصق نصه. سيحل محل البيانات على هذا الجهاز.',
              ),
            ),
            const SizedBox(height: 12),
            if (canUseFiles)
              OutlinedButton.icon(
                onPressed: () async {
                  final t = await pickTextFile();
                  if (t != null) text.text = t;
                },
                icon: const Icon(Icons.folder_open_outlined),
                label: Text(c.tr('Choose file', 'اختيار ملف')),
              ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('import-json'),
              controller: text,
              maxLines: 8,
              minLines: 4,
              textDirection: TextDirection.ltr,
              style: monoStyle(c, size: 11),
              decoration: InputDecoration(
                hintText: c.tr('Paste JSON here', 'الصق JSON هنا'),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: Text(c.tr('Cancel', 'إلغاء')),
        ),
        FilledButton(
          key: const Key('import-confirm'),
          onPressed: () => Navigator.pop(c, true),
          child: Text(c.tr('Import', 'استيراد')),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  try {
    ref.read(polyglotProvider.notifier).importJson(text.text.trim());
    showSnack(context, context.tr('Data imported', 'تم استيراد البيانات'));
  } catch (e) {
    showSnack(
      context,
      context.tr(
        'This is not a Polyglot Matrix export file.',
        'هذا ليس ملف تصدير صالحًا.',
      ),
    );
  }
}

Future<void> resetData(BuildContext context, WidgetRef ref) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(
        c.tr('Reset to sample data?', 'العودة إلى البيانات النموذجية؟'),
      ),
      content: Text(
        c.tr(
          'Your notebook entries, dictionary words, tasks and bookmarks on this device will be replaced. Export first if you want to keep them.',
          'ستُستبدل مذكراتك وكلماتك ومهامك ومفضلاتك على هذا الجهاز. صدّرها أولًا إن أردت الاحتفاظ بها.',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: Text(c.tr('Cancel', 'إلغاء')),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, true),
          child: Text(c.tr('Reset', 'إعادة الضبط')),
        ),
      ],
    ),
  );
  if (ok == true) ref.read(polyglotProvider.notifier).resetToSample();
}
