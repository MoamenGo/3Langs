import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../data/models/learner.dart';
import '../../data/sync/sync_service.dart';

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
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l.appLanguage),
            trailing: DropdownButton<String>(
              value: settings.uiLanguage,
              items: [
                for (final e in _languageNames.entries)
                  DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              onChanged: (v) => save(settings.copyWith(uiLanguage: v)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text(l.explanationLanguage),
            trailing: DropdownButton<ExplainLang>(
              value: settings.explanationLanguage,
              items: [
                for (final lang in ExplainLang.values)
                  DropdownMenuItem(
                    value: lang,
                    child: Text(_languageNames[lang.name]!),
                  ),
              ],
              onChanged: (v) => save(settings.copyWith(explanationLanguage: v)),
            ),
          ),
          const _TracksSection(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: Text(l.dailyGoal),
            subtitle: Slider(
              value: settings.dailyGoalMinutes.toDouble(),
              min: 15,
              max: 240,
              divisions: 15,
              label: l.minutesShort(settings.dailyGoalMinutes),
              onChanged: (v) =>
                  save(settings.copyWith(dailyGoalMinutes: v.round())),
            ),
            trailing: Text(l.minutesShort(settings.dailyGoalMinutes)),
          ),
          ListTile(
            leading: const Icon(Icons.style),
            title: Text(l.newCardsPerDay),
            subtitle: Slider(
              value: settings.newCardsPerDay.toDouble(),
              min: 0,
              max: 60,
              divisions: 12,
              label: '${settings.newCardsPerDay}',
              onChanged: (v) =>
                  save(settings.copyWith(newCardsPerDay: v.round())),
            ),
            trailing: Text('${settings.newCardsPerDay}'),
          ),
          const Divider(),
          _AccountSection(sync: sync),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.about),
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
        title: Text(l.account),
        subtitle: Text(l.syncDisabled),
      );
    }
    final user = ref.watch(authUserProvider).value;
    if (user == null) {
      return ListTile(
        leading: const Icon(Icons.cloud_outlined),
        title: Text(l.account),
        subtitle: Text(l.signIn),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/sign-in'),
      );
    }
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.cloud_done_outlined),
          title: Text(l.signedInAs(user.email ?? '')),
          subtitle: ValueListenableBuilder<DateTime?>(
            valueListenable: sync.lastSyncedAt,
            builder: (_, t, _) =>
                Text(t == null ? '' : l.lastSynced(DateFormat.Hm().format(t))),
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
          title: Text(l.signOut),
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
          child: Text(
            l.languages,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        for (final t in tracks.values)
          ListTile(
            leading: CircleAvatar(
              backgroundColor: t.lang.color,
              foregroundColor: Colors.white,
              child: Text(t.lang.code),
            ),
            title: Text(t.lang.displayName(ui)),
            subtitle: Text(
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
                    child: Text(l.pauseLanguage),
                  )
                : TextButton(
                    onPressed: () => save(
                      t.copyWith(status: TrackStatus.active, startDate: today),
                    ),
                    child: Text(l.resumeLanguage),
                  ),
          ),
      ],
    );
  }
}
