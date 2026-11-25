// Shared pieces of the Polyglot Matrix screens: bilingual strings, language
// badges, the top bar (streak, daily goal ring, quick links, interface
// language switch, data menu) and small helpers.

import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers.dart';
import '../../core/theme.dart';
import 'controller.dart';
import 'data_io.dart';
import 'models.dart';

extension TrX on BuildContext {
  /// Interface language of this screen (`ar` or `en`).
  String get ui =>
      Localizations.localeOf(this).languageCode == 'ar' ? 'ar' : 'en';

  bool get isAr => ui == 'ar';

  /// Picks the English or the Arabic wording.
  String tr(String en, String ar) => isAr ? ar : en;
}

/// Direction of a line in [lang].
TextDirection dirOf(LanguageDef? lang) =>
    lang?.rtl == true ? TextDirection.rtl : TextDirection.ltr;

Color langColor(LanguageDef l) => Color(l.colorValue);

/// Opens a link outside the app.
Future<void> openLink(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  final ok =
      uri != null && await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    showSnack(context, context.tr('Could not open $url', 'تعذر فتح $url'));
  }
}

void showSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

/// Reads [text] aloud in [lang]; says so when the device has no voice.
Future<void> speak(
  BuildContext context,
  WidgetRef ref,
  String text,
  LanguageDef lang, {
  bool slow = false,
}) async {
  final ok = await ref
      .read(ttsProvider)
      .speakLocale(text, lang.tts, slow: slow);
  if (!ok && context.mounted) {
    showSnack(
      context,
      context.tr(
        'No speech voice for ${lang.name} on this device. Try the IPA, or install a ${lang.name} voice in your system settings.',
        'لا يوجد صوت ${lang.nameAr} على هذا الجهاز. استعن بالنطق الصوتي (IPA) أو ثبّت صوتًا من إعدادات النظام.',
      ),
    );
  }
}

/// Mono metadata text (ISO codes, IPA labels).
TextStyle monoStyle(BuildContext context, {double size = 11.5, Color? color}) =>
    TextStyle(
      fontFamily: kMonoFont,
      fontFamilyFallback: kFontFallback,
      fontSize: size,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.04 * size,
      height: 1.5,
      color: color ?? context.mx.muted,
    );

/// IPA in the phonetic font (falls back to Noto Sans for IPA letters).
TextStyle ipaStyle(BuildContext context) => TextStyle(
  fontFamily: 'NotoSansIPA',
  fontFamilyFallback: const ['NotoSansArabic'],
  fontSize: 14,
  height: 1.7,
  letterSpacing: 0.3,
  color: context.mx.muted,
);

/// Uppercase section label with an icon, like "CONCEPT OF THE DAY".
class SectionLabel extends StatelessWidget {
  const SectionLabel(
    this.text, {
    super.key,
    this.icon,
    this.color,
    this.trailing,
  });
  final String text;
  final IconData? icon;
  final Color? color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.mx.primary;
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: c),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            context.isAr ? text : text.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium!
                .copyWith(color: c, letterSpacing: context.isAr ? 0 : 1.1),
          ),
        ),
        if (trailing != null) Flexible(child: trailing!),
      ],
    );
  }
}

/// Flag, three-letter code and CEFR level of a language.
class LangBadge extends StatelessWidget {
  const LangBadge(
    this.lang, {
    super.key,
    this.showName = true,
    this.dense = false,
  });
  final LanguageDef lang;
  final bool showName;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(lang.flag, style: TextStyle(fontSize: dense ? 14 : 18)),
        const SizedBox(width: 8),
        if (showName) ...[
          Flexible(
            child: Text(
              lang.displayName(context.ui),
              overflow: TextOverflow.ellipsis,
              style: (dense ? t.titleSmall : t.titleMedium),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          '${lang.iso3} · ${lang.level}',
          textDirection: TextDirection.ltr,
          style: monoStyle(context, size: dense ? 10.5 : 11.5),
        ),
      ],
    );
  }
}

/// Small tinted tag (part of speech, skill, RTL...).
class Tag extends StatelessWidget {
  const Tag(
    this.text, {
    super.key,
    this.color,
    this.icon,
    this.onTap,
    this.filled = false,
  });
  final String text;
  final Color? color;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.mx.muted;
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: filled ? c : c.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: filled ? Colors.white : c),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: filled ? Colors.white : c,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
    return onTap == null
        ? child
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            child: child,
          );
  }
}

Color stageColor(BuildContext context, Stage s) => switch (s) {
  Stage.fresh => context.mx.muted,
  Stage.learning => context.mx.amber,
  Stage.mastered => context.mx.primary,
};

IconData stageIcon(Stage s) => switch (s) {
  Stage.fresh => Icons.fiber_new_outlined,
  Stage.learning => Icons.autorenew,
  Stage.mastered => Icons.verified_outlined,
};

IconData skillIcon(Skill s) => switch (s) {
  Skill.listening => Icons.headphones_outlined,
  Skill.speaking => Icons.record_voice_over_outlined,
  Skill.reading => Icons.menu_book_outlined,
  Skill.writing => Icons.edit_outlined,
  Skill.grammar => Icons.account_tree_outlined,
  Skill.vocabulary => Icons.translate,
  Skill.pronunciation => Icons.graphic_eq,
  Skill.review => Icons.replay_circle_filled_outlined,
  Skill.culture => Icons.public,
};

IconData aspectIcon(Aspect a) => switch (a) {
  Aspect.vocabulary => Icons.translate,
  Aspect.grammar => Icons.account_tree_outlined,
  Aspect.listening => Icons.headphones_outlined,
  Aspect.speaking => Icons.record_voice_over_outlined,
  Aspect.reading => Icons.menu_book_outlined,
  Aspect.writing => Icons.edit_note,
  Aspect.pragmatics => Icons.forum_outlined,
};

IconData formatIcon(ResourceFormat f) => switch (f) {
  ResourceFormat.video => Icons.smart_display_outlined,
  ResourceFormat.book => Icons.auto_stories_outlined,
  ResourceFormat.audio => Icons.podcasts,
  ResourceFormat.tool => Icons.handyman_outlined,
};

/// A Tier 1 panel with the design's padding.
class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderColor,
    this.onTap,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    return Frosted(
      child: Material(
        color: color ?? mx.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColor ?? mx.rule),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Tier 2 block inside a panel (cream).
class Inset extends StatelessWidget {
  const Inset({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.color,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: color ?? context.mx.surface2,
      borderRadius: BorderRadius.circular(6),
    ),
    child: child,
  );
}

/// Daily goal ring: minutes done today out of planned.
class GoalRing extends StatelessWidget {
  const GoalRing({
    super.key,
    required this.done,
    required this.planned,
    this.size = 40,
  });
  final int done;
  final int planned;
  final double size;

  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    final v = planned == 0 ? 0.0 : (done / planned).clamp(0.0, 1.0);
    return Tooltip(
      message: context.tr(
        'Daily goal: $done of $planned min',
        'هدف اليوم: $done من $planned دقيقة',
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size.square(size),
              painter: _RingPainter(v, mx.primary, mx.surface2),
            ),
            Text(
              '${(v * 100).round()}%',
              style: monoStyle(context, size: 9.5, color: mx.ink),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value, this.color, this.track);
  final double value;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 4.0;
    final rect = Offset.zero & size;
    final r = rect.deflate(stroke / 2);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(r, 0, math.pi * 2, false, p..color = track);
    if (value > 0) {
      canvas.drawArc(
        r,
        -math.pi / 2,
        math.pi * 2 * value,
        false,
        p..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter o) => o.value != value || o.color != color;
}

/// Top bar shared by the four Polyglot Matrix screens.
class PolyTopBar extends ConsumerWidget {
  const PolyTopBar({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(polyglotProvider);
    final ctl = ref.read(polyglotProvider.notifier);
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final (done, planned) = ctl.todayGoal;
    final narrow = MediaQuery.sizeOf(context).width < 520;
    return Container(
      decoration: BoxDecoration(
        color: mx.canvas,
        border: Border(bottom: BorderSide(color: mx.rule)),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 8, 10),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: mx.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.grid_view_rounded, color: mx.surface, size: 19),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.titleLarge!.copyWith(height: 1.2),
                  ),
                  if (subtitle != null && !narrow)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: monoStyle(context, size: 10.5),
                    ),
                ],
              ),
            ),
            Tooltip(
              message: context.tr('Study streak', 'أيام الدراسة المتتالية'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: mx.amber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: mx.amber,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      context.tr('${ctl.streak}d', '${ctl.streak} ي'),
                      style: monoStyle(context, size: 11.5, color: mx.amber),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => context.go('/notebook'),
              customBorder: const CircleBorder(),
              child: GoalRing(done: done, planned: planned, size: 38),
            ),
            if (!narrow) ...[
              IconButton(
                tooltip: context.tr('Notebook planner', 'مذكرة اللغات'),
                onPressed: () => context.go('/notebook'),
                icon: const Icon(Icons.edit_calendar_outlined),
              ),
              IconButton(
                tooltip: context.tr('Unified dictionary', 'القاموس الموحد'),
                onPressed: () => context.go('/dictionary'),
                icon: const Icon(Icons.menu_book_outlined),
              ),
            ],
            const UiLanguageToggle(),
            const PolyMenu(),
          ],
        ),
      ),
    );
  }
}

/// Switches the interface between Arabic (right to left) and English.
class UiLanguageToggle extends ConsumerWidget {
  const UiLanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = context.isAr;
    return Tooltip(
      message: ar ? 'English interface' : 'الواجهة بالعربية',
      child: TextButton(
        key: const Key('ui-lang-toggle'),
        style: TextButton.styleFrom(
          minimumSize: const Size(40, 36),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          side: BorderSide(color: context.mx.rule),
        ),
        onPressed: () async {
          final repo = ref.read(settingsRepositoryProvider);
          final s = await repo.get();
          await repo.save(s.copyWith(uiLanguage: ar ? 'en' : 'ar'));
          ref.read(syncServiceProvider).schedule();
        },
        child: Text(
          ar ? 'EN' : 'ع',
          style: TextStyle(
            fontFamily: ar ? kMonoFont : 'NotoSansArabic',
            fontWeight: FontWeight.w700,
            color: context.mx.ink,
          ),
        ),
      ),
    );
  }
}

/// Data menu: export, import, reset, settings.
class PolyMenu extends ConsumerWidget {
  const PolyMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => PopupMenuButton<String>(
    tooltip: context.tr('More', 'المزيد'),
    icon: const Icon(Icons.more_vert),
    onSelected: (v) {
      switch (v) {
        case 'export':
          exportData(context, ref);
        case 'import':
          importData(context, ref);
        case 'reset':
          resetData(context, ref);
        case 'resources':
          context.go('/resources');
        case 'settings':
          context.push('/settings');
      }
    },
    itemBuilder: (context) => [
      _item(
        context,
        'export',
        Icons.file_download_outlined,
        context.tr('Export data (JSON)', 'تصدير البيانات (JSON)'),
      ),
      _item(
        context,
        'import',
        Icons.file_upload_outlined,
        context.tr('Import data (JSON)', 'استيراد البيانات (JSON)'),
      ),
      _item(
        context,
        'reset',
        Icons.restart_alt,
        context.tr('Reset to sample data', 'العودة إلى البيانات النموذجية'),
      ),
      const PopupMenuDivider(),
      _item(
        context,
        'resources',
        Icons.library_books_outlined,
        context.tr('Free resources hub', 'مصادر التعلم المجانية'),
      ),
      _item(
        context,
        'settings',
        Icons.settings_outlined,
        context.tr('Settings', 'الإعدادات'),
      ),
    ],
  );

  PopupMenuItem<String> _item(BuildContext c, String v, IconData i, String t) =>
      PopupMenuItem(
        value: v,
        child: Row(
          children: [
            Icon(i, size: 20, color: c.mx.muted),
            const SizedBox(width: 12),
            Text(t),
          ],
        ),
      );
}

/// Page body with the design's outer margins and a readable max width.
class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children, this.maxWidth = 1360});
  final List<Widget> children;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final margin = w >= 1200 ? 32.0 : (w >= 768 ? 24.0 : 16.0);
    return ListView(
      padding: EdgeInsets.fromLTRB(margin, 16, margin, 110),
      children: [
        for (final c in children)
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: c,
            ),
          ),
      ],
    );
  }
}

/// Language filter chip (flag + name) used on several screens.
class LangChip extends StatelessWidget {
  const LangChip({
    super.key,
    required this.lang,
    required this.selected,
    required this.onTap,
    this.showLevel = false,
  });
  final LanguageDef lang;
  final bool selected;
  final VoidCallback onTap;
  final bool showLevel;

  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    final fg = selected ? Colors.white : mx.ink;
    return Material(
      color: selected ? mx.primary : mx.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: selected ? mx.primary : mx.rule),
      ),
      child: InkWell(
        key: Key('lang-chip-${lang.code}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(lang.flag, style: const TextStyle(fontSize: 15)),
              const SizedBox(width: 6),
              Text(
                lang.displayName(context.ui),
                style: Theme.of(context).textTheme.labelLarge!
                    .copyWith(color: fg),
              ),
              if (showLevel) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.18)
                        : mx.surface2,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    lang.rtl ? '${lang.level} · RTL' : lang.level,
                    textDirection: TextDirection.ltr,
                    style: monoStyle(context, size: 10, color: fg),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A simple choice chip in the design's style.
class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.count,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    final fg = selected ? Colors.white : mx.ink;
    return Material(
      color: selected ? mx.primary : mx.surface2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: selected ? mx.primary : mx.rule),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: selected ? Colors.white : mx.muted),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge!
                    .copyWith(color: fg, fontSize: 13),
              ),
              if (count != null) ...[
                const SizedBox(width: 6),
                Text(
                  '$count',
                  style: monoStyle(
                    context,
                    size: 10.5,
                    color: selected ? Colors.white70 : mx.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A row of chips that scrolls sideways on phones and wraps on wide screens.
class ChipRow extends StatelessWidget {
  const ChipRow({super.key, required this.children, this.spacing = 8});
  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width >= 760) {
      return Wrap(spacing: spacing, runSpacing: spacing, children: children);
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Text field used in the module's dialogs.
Widget field(
  TextEditingController c,
  String label, {
  int maxLines = 1,
  TextDirection? dir,
  String? hint,
  Key? key,
}) => Padding(
  padding: const EdgeInsets.only(bottom: 12),
  child: TextField(
    key: key,
    controller: c,
    maxLines: maxLines,
    minLines: 1,
    textDirection: dir,
    decoration: InputDecoration(labelText: label, hintText: hint),
  ),
);
