import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';

import '../../core/bidi.dart';
import '../../core/theme.dart';
import '../../services/update/app_update.dart';
import '../polyglot/ui.dart' show TrX;

/// "Check for updates": installs the newest build over the app (Android)
/// or loads the newest version of the site (web), keeping all data.
class UpdateTile extends StatefulWidget {
  const UpdateTile({super.key});

  @override
  State<UpdateTile> createState() => _UpdateTileState();
}

class _UpdateTileState extends State<UpdateTile> {
  bool _busy = false;

  Future<void> _check() async {
    if (kIsWeb) {
      setState(() => _busy = true);
      await installUpdate(null);
      return;
    }
    setState(() => _busy = true);
    final latest = await fetchLatestBuild();
    if (!mounted) return;
    setState(() => _busy = false);
    if (latest == null) {
      _snack(
        context.tr(
          'Could not check now. Try again when online.',
          'مقدرناش نتحقق دلوقتي. جرّب تاني وانت متصل بالإنترنت.',
        ),
      );
      return;
    }
    if (!latest.isNewer) {
      _snack(
        context.tr(
          'You have the latest version (build $currentBuild).',
          'عندك أحدث نسخة (بناء $currentBuild).',
        ),
      );
      return;
    }
    await showUpdateDialog(context, latest);
  }

  void _snack(String text) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: BidiText(text)));

  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    return ListTile(
      key: const Key('check-updates'),
      leading: Icon(Icons.system_update_outlined, color: mx.primary),
      title: BidiText(
        kIsWeb
            ? context.tr('Get the latest version', 'هات أحدث نسخة')
            : context.tr('Check for updates', 'تحقق من التحديثات'),
      ),
      subtitle: BidiText(
        kIsWeb
            ? context.tr(
                'Reloads the newest version. Your data stays.',
                'بيحمّل أحدث نسخة. بياناتك بتفضل زي ما هي.',
              )
            : context.tr(
                'Installs over this app; no uninstall, your data stays. '
                    'This version: build $currentBuild.',
                'بيتثبت فوق التطبيق من غير حذف، وبياناتك بتفضل. '
                    'النسخة الحالية: بناء $currentBuild.',
              ),
      ),
      trailing: _busy
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_right),
      onTap: _busy ? null : _check,
    );
  }
}

/// Offers the new build: downloading it and opening the file installs it
/// over the current app.
Future<void> showUpdateDialog(BuildContext context, LatestBuild latest) =>
    showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        icon: const Icon(Icons.system_update, size: 36),
        title: BidiText(c.tr('Update available', 'في تحديث جديد')),
        content: BidiText(
          c.tr(
            'Build ${latest.build} is ready (you have $currentBuild). '
                'Tap Update, then open the downloaded file and tap Update '
                'to install it over the app. Your progress is kept.',
            'البناء ${latest.build} جاهز (عندك $currentBuild). اضغط '
                'تحديث، وبعدين افتح الملف اللي اتحمّل واضغط تحديث عشان '
                'يتثبت فوق التطبيق. تقدمك بيفضل محفوظ.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: BidiText(c.tr('Later', 'بعدين')),
          ),
          FilledButton.icon(
            key: const Key('install-update'),
            onPressed: () {
              Navigator.pop(c);
              installUpdate(latest);
            },
            icon: const Icon(Icons.download),
            label: BidiText(c.tr('Update', 'تحديث')),
          ),
        ],
      ),
    );
