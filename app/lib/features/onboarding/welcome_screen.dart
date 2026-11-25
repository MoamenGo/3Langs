import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/lang/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../data/models/learner.dart';
import '../today/today_plan.dart';
import '../../core/bidi.dart';

/// First run: interface language, daily minutes, which languages and when
/// each starts, and an optional placement test per language.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final settings = ref.watch(settingsProvider).value;
    final tracks = ref.watch(tracksProvider).value;
    final ui = ref.watch(uiLanguageProvider);
    final theme = Theme.of(context).textTheme;
    if (settings == null || tracks == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    Future<void> saveSettings(UserSettings s) =>
        ref.read(settingsRepositoryProvider).save(s);
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);

    return Scaffold(
      appBar: AppBar(title: BidiText(l.welcomeTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              BidiText(l.welcomeIntro, style: theme.bodyLarge),
              const SizedBox(height: 24),
              BidiText(l.stepInterface, style: theme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'ar', label: BidiText('العربية')),
                  ButtonSegment(value: 'en', label: BidiText('English')),
                ],
                selected: {settings.uiLanguage},
                onSelectionChanged: (v) => saveSettings(
                  settings.copyWith(
                    uiLanguage: v.first,
                    explanationLanguage: v.first == 'en'
                        ? ExplainLang.en
                        : ExplainLang.ar,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BidiText(l.stepMinutes, style: theme.titleMedium),
              Slider(
                value: settings.dailyGoalMinutes.toDouble().clamp(30, 240),
                min: 30,
                max: 240,
                divisions: 14,
                label: l.minutesShort(settings.dailyGoalMinutes),
                onChanged: (v) => saveSettings(
                  settings.copyWith(dailyGoalMinutes: v.round()),
                ),
              ),
              BidiText(
                l.minutesPerLanguage(
                  settings.dailyGoalMinutes,
                  settings.dailyGoalMinutes ~/ 3,
                ),
              ),
              const SizedBox(height: 24),
              BidiText(l.stepLanguages, style: theme.titleMedium),
              BidiText(l.stepLanguagesHint, style: theme.bodySmall),
              for (final lang in Lang.values)
                Builder(
                  builder: (context) {
                    final t = tracks[lang]!;
                    final week = t.startDate == null
                        ? 1
                        : (t.startDate!.difference(today).inDays / 7)
                                  .ceil()
                                  .clamp(0, 52) +
                              1;
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            SwitchListTile(
                              key: ValueKey('learn-${lang.name}'),
                              secondary: CircleAvatar(
                                backgroundColor: lang.color,
                                foregroundColor: Colors.white,
                                child: BidiText(lang.code),
                              ),
                              title: BidiText(
                                '${lang.displayName(ui)} · ${t.currentLevel}',
                              ),
                              value: t.status != TrackStatus.paused,
                              onChanged: (on) => ref
                                  .read(trackRepositoryProvider)
                                  .save(
                                    t.copyWith(
                                      status: on
                                          ? (week <= 1
                                                ? TrackStatus.active
                                                : TrackStatus.scheduled)
                                          : TrackStatus.paused,
                                    ),
                                  ),
                            ),
                            if (t.status != TrackStatus.paused)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  8,
                                ),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    BidiText(l.startIn),
                                    for (final w in const [1, 3, 9])
                                      ChoiceChip(
                                        label: BidiText(
                                          w == 1 ? l.startNow : l.weekN(w),
                                        ),
                                        selected: week == w,
                                        onSelected: (_) => ref
                                            .read(trackRepositoryProvider)
                                            .save(
                                              t.copyWith(
                                                startDate: today.add(
                                                  Duration(days: 7 * (w - 1)),
                                                ),
                                                status: w == 1
                                                    ? TrackStatus.active
                                                    : TrackStatus.scheduled,
                                              ),
                                            ),
                                      ),
                                    OutlinedButton.icon(
                                      key: ValueKey('placement-${lang.name}'),
                                      icon: const Icon(Icons.quiz, size: 18),
                                      label: BidiText(l.placementButton),
                                      onPressed: () => context.push(
                                        '/placement/${lang.name}',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24),
              FilledButton(
                key: const ValueKey('finish-setup'),
                onPressed: () async {
                  await ref.read(localDbProvider).setMeta('onboarded', true);
                  await rebuildTodayPlan(ref);
                  ref.read(syncServiceProvider).schedule();
                  if (context.mounted) context.go('/today');
                },
                child: BidiText(l.finishSetup),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
