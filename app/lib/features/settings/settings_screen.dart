import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers.dart';
import '../../core/lang/lang.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../data/models/learner.dart';
import '../../data/sync/sync_service.dart';
import '../../core/bidi.dart';
import '../polyglot/ui.dart' show TrX;
import 'update_tile.dart';

/// Page with the latest Android build, published by the "Android APK"
/// GitHub workflow.
const androidApkUrl =
    'https://github.com/MoamenGo/3Langs/releases/tag/android-latest';

/// Interface and explanation languages, each named in itself.
const _languageNames = {'ar': 'العربية', 'en': 'English'};

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final settings = ref.watch(settingsProvider).value;
    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final repo = ref.read(settingsRepositoryProvider);
    final sync = ref.read(syncServiceProvider);
    Future<void> save(UserSettings s) async {
      await repo.save(s);
      sync.schedule();
    }

    return Scaffold(
      appBar: AppBar(title: BidiText(l.settings)),
      body: ListView(
        children: [
          const UpdateTile(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: BidiText(l.appLanguage),
            trailing: DropdownButton<String>(
              value: settings.uiLanguage,
              items: [
                for (final e in _languageNames.entries)
                  DropdownMenuItem(value: e.key, child: BidiText(e.value)),
              ],
              onChanged: (v) => save(settings.copyWith(uiLanguage: v)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: BidiText(l.explanationLanguage),
            trailing: DropdownButton<ExplainLang>(
              value: settings.explanationLanguage,
              items: [
                for (final lang in ExplainLang.values)
                  DropdownMenuItem(
                    value: lang,
                    child: BidiText(_languageNames[lang.name]!),
                  ),
              ],
              onChanged: (v) => save(settings.copyWith(explanationLanguage: v)),
            ),
          ),
          const _AppearanceSection(),
          SwitchListTile(
            secondary: const Icon(Icons.record_voice_over_outlined),
            title: BidiText(l.humanVoice),
            subtitle: BidiText(l.humanVoiceHint),
            value: ref.watch(humanVoiceProvider).value ?? true,
            onChanged: (v) =>
                ref.read(localDbProvider).setMeta('human_voice', v),
          ),
          const Divider(),
          const _TracksSection(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: BidiText(l.dailyGoal),
            subtitle: Slider(
              value: settings.dailyGoalMinutes.toDouble(),
              min: 15,
              max: 240,
              divisions: 15,
              label: l.minutesShort(settings.dailyGoalMinutes),
              onChanged: (v) =>
                  save(settings.copyWith(dailyGoalMinutes: v.round())),
            ),
            trailing: BidiText(l.minutesShort(settings.dailyGoalMinutes)),
          ),
          ListTile(
            leading: const Icon(Icons.style),
            title: BidiText(l.newCardsPerDay),
            subtitle: Slider(
              value: settings.newCardsPerDay.toDouble(),
              min: 0,
              max: 60,
              divisions: 12,
              label: '${settings.newCardsPerDay}',
              onChanged: (v) =>
                  save(settings.copyWith(newCardsPerDay: v.round())),
            ),
            trailing: BidiText('${settings.newCardsPerDay}'),
          ),
          ListTile(
            key: const Key('choose-languages'),
            leading: const Icon(Icons.flag_outlined),
            title: BidiText(context.tr('Choose your languages', 'اختر لغاتك')),
            subtitle: BidiText(
              context.tr(
                'Languages, levels and daily time for the roadmap and course',
                'اللغات والمستويات والوقت اليومي للخطة والمنهج',
              ),
            ),
            onTap: () => context.push('/start'),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: BidiText(l.languagesAndPlan),
            subtitle: BidiText(l.languagesAndPlanHint),
            onTap: () => context.push('/welcome'),
          ),
          if (kIsWeb) ...[
            const Divider(),
            ListTile(
              key: const Key('get-android-app'),
              leading: const Icon(Icons.android),
              title: BidiText(l.androidApp),
              subtitle: BidiText(l.androidAppHint),
              trailing: const Icon(Icons.download_outlined),
              onTap: () => launchUrl(Uri.parse(androidApkUrl)),
            ),
          ],
          const Divider(),
          _AccountSection(sync: sync),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: BidiText(l.about),
            onTap: () => context.push('/settings/about'),
          ),
        ],
      ),
    );
  }
}

class _AccountSection extends ConsumerWidget {
  const _AccountSection({required this.sync});
  final SyncService sync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final client = ref.watch(supabaseProvider);
    if (client == null) {
      return ListTile(
        leading: const Icon(Icons.cloud_off),
        title: BidiText(l.account),
        subtitle: BidiText(l.syncDisabled),
      );
    }
    final user = ref.watch(authUserProvider).value;
    if (user == null) {
      return ListTile(
        leading: const Icon(Icons.cloud_outlined),
        title: BidiText(l.account),
        subtitle: BidiText(l.signIn),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/sign-in'),
      );
    }
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.cloud_done_outlined),
          title: BidiText(l.signedInAs(user.email ?? '')),
          subtitle: ValueListenableBuilder<DateTime?>(
            valueListenable: sync.lastSyncedAt,
            builder: (_, t, _) => BidiText(
              t == null ? '' : l.lastSynced(DateFormat.Hm().format(t)),
            ),
          ),
          trailing: ValueListenableBuilder<SyncStatus>(
            valueListenable: sync.status,
            builder: (_, s, _) => s == SyncStatus.syncing
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.sync),
                    tooltip: l.syncNow,
                    onPressed: sync.syncNow,
                  ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: BidiText(l.signOut),
          onTap: () async {
            await sync.syncNow(); // push anything not yet uploaded
            await client.auth.signOut();
            await ref.read(localDbProvider).clearAll();
          },
        ),
      ],
    );
  }
}

/// The three languages, with their level and plan. A scheduled language can
/// start early; an active one can be paused.
class _TracksSection extends ConsumerWidget {
  const _TracksSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ui = ref.watch(uiLanguageProvider);
    final tracks = ref.watch(tracksProvider).value;
    if (tracks == null) return const SizedBox.shrink();
    final today = DateTime.now().toUtc();
    Future<void> save(LanguageTrack t) async {
      await ref.read(trackRepositoryProvider).save(t);
      ref.read(syncServiceProvider).schedule();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 4),
          child: BidiText(
            l.languages,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        for (final t in tracks.values)
          ListTile(
            leading: CircleAvatar(
              backgroundColor: t.lang.color,
              foregroundColor: Colors.white,
              child: BidiText(t.lang.code),
            ),
            title: BidiText(t.lang.displayName(ui)),
            subtitle: BidiText(
              '${l.levelN(t.currentLevel)} · ${t.isActiveOn(today)
                  ? l.trackActive
                  : t.status == TrackStatus.paused
                  ? l.trackPaused
                  : l.trackScheduled(formatDay(t.startDate!))}',
            ),
            trailing: t.isActiveOn(today)
                ? TextButton(
                    onPressed: () =>
                        save(t.copyWith(status: TrackStatus.paused)),
                    child: BidiText(l.pauseLanguage),
                  )
                : TextButton(
                    onPressed: () => save(
                      t.copyWith(status: TrackStatus.active, startDate: today),
                    ),
                    child: BidiText(l.resumeLanguage),
                  ),
          ),
      ],
    );
  }
}

/// The style (light or dark glass) and the colour theme.
class _AppearanceSection extends ConsumerWidget {
  const _AppearanceSection();

  static String themeName(BuildContext context, AppTheme t) => switch (t) {
    AppTheme.lagoon => context.tr('Lagoon', 'بحيرة'),
    AppTheme.aurora => context.tr('Aurora', 'شفق'),
    AppTheme.ocean => context.tr('Ocean', 'محيط'),
    AppTheme.sunset => context.tr('Sunset', 'غروب'),
    AppTheme.blossom => context.tr('Blossom', 'زهر'),
    AppTheme.forest => context.tr('Forest', 'غابة'),
    AppTheme.language => context.tr('Language colours', 'ألوان اللغة'),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final current = ref.watch(appThemeProvider).value ?? AppTheme.lagoon;
    final mode = ref.watch(themeModeProvider).value ?? ThemeMode.system;
    final db = ref.read(localDbProvider);
    final t = Theme.of(context).textTheme;
    // "Auto" shows the style the phone is using right now.
    final shown = mode == ThemeMode.system
        ? (MediaQuery.platformBrightnessOf(context) == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light)
        : mode;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.blur_on_rounded),
              const SizedBox(width: 16),
              BidiText(context.tr('Style', 'الستايل'), style: t.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final m in [ThemeMode.light, ThemeMode.dark]) ...[
                if (m == ThemeMode.dark) const SizedBox(width: 12),
                Expanded(
                  child: _StyleCard(
                    key: Key('style-${m.name}'),
                    dark: m == ThemeMode.dark,
                    theme: current,
                    label: m == ThemeMode.dark
                        ? context.tr('Dark glass', 'زجاجي غامق')
                        : context.tr('Light glass', 'زجاجي فاتح'),
                    selected: shown == m,
                    onTap: () => db.setMeta('theme_mode', m.name),
                  ),
                ),
              ],
            ],
          ),
          CheckboxListTile(
            key: const Key('style-auto'),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: mode == ThemeMode.system,
            title: BidiText(l.modeSystem),
            subtitle: BidiText(
              context.tr(
                'Follow the phone: light by day, dark at night.',
                'زي الموبايل: فاتح بالنهار وغامق بالليل.',
              ),
            ),
            onChanged: (v) =>
                db.setMeta('theme_mode', v == true ? 'system' : shown.name),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.palette_outlined),
              const SizedBox(width: 16),
              BidiText(l.colorTheme, style: t.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final th in AppTheme.values)
                _ThemeSwatch(
                  key: Key('theme-${th.name}'),
                  theme: th,
                  label: themeName(context, th),
                  selected: th == current,
                  onTap: () => db.setMeta('theme', th.name),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A small preview of the light or dark glass style in the chosen theme.
class _StyleCard extends StatelessWidget {
  const _StyleCard({
    super.key,
    required this.dark,
    required this.theme,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final bool dark;
  final AppTheme theme;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final g = theme.gradient;
    final base = dark ? const Color(0xFF0D121C) : const Color(0xFFF8F7F4);
    final panel = dark
        ? const Color(0xFF1B2333).withValues(alpha: 0.55)
        : Colors.white.withValues(alpha: 0.6);
    final line = dark
        ? Colors.white.withValues(alpha: 0.35)
        : const Color(0xFF1E242B).withValues(alpha: 0.25);
    Widget glow(Alignment at, Color c) => Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: at,
            radius: 0.9,
            colors: [
              c.withValues(alpha: dark ? 0.6 : 0.5),
              c.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outlineVariant,
            width: selected ? 2.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 1.25,
          child: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: base)),
              glow(const Alignment(-0.9, -0.9), g[0]),
              glow(const Alignment(0.9, 0.9), g[1]),
              Positioned(
                left: 12,
                right: 12,
                top: 12,
                child: Container(
                  height: 34,
                  decoration: BoxDecoration(
                    color: panel,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: dark ? 0.18 : 0.9),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(width: 40, height: 5, color: line),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 40,
                top: 54,
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: panel,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: dark ? 0.18 : 0.9),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 6,
                right: 6,
                bottom: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (selected)
                      Icon(Icons.check_circle, size: 18, color: scheme.primary),
                    if (selected) const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: dark ? Colors.white : const Color(0xFF1E242B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeSwatch extends StatelessWidget {
  const _ThemeSwatch({
    super.key,
    required this.theme,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final AppTheme theme;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = theme == AppTheme.language
        ? [for (final l in Lang.values) l.color]
        : theme.gradient;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 84,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  if (selected)
                    BoxShadow(
                      color: colors.first.withValues(alpha: 0.5),
                      blurRadius: 12,
                    ),
                ],
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 6),
            BidiText(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
