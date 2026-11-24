import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../data/models/learner.dart';
import 'lang/lang.dart';
import '../data/repositories/progress_repository.dart';
import '../data/sync/sync_service.dart';
import '../l10n/app_localizations.dart';
import 'providers.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Shows a spinner, an error, or the data of an AsyncValue.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({super.key, required this.value, required this.builder});
  final AsyncValue<T> value;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) => value.when(
    data: builder,
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(context.l10n.errorMessage('$e')),
      ),
    ),
  );
}

/// Wrap a study screen in this to record the time spent as a study session
/// (used for daily goal, streaks and total hours).
class StudyTimer extends ConsumerStatefulWidget {
  const StudyTimer({super.key, required this.activity, required this.child});
  final Activity activity;
  final Widget child;

  @override
  ConsumerState<StudyTimer> createState() => _StudyTimerState();
}

class _StudyTimerState extends ConsumerState<StudyTimer> {
  final _started = DateTime.now();
  late final ProgressRepository _progress;
  late final SyncService _sync;

  @override
  void initState() {
    super.initState();
    // Read now: providers can't be read from dispose().
    _progress = ref.read(progressRepositoryProvider);
    _sync = ref.read(syncServiceProvider);
  }

  @override
  void dispose() {
    _progress
        .logSession(widget.activity, _started)
        .then((_) => _sync.schedule());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// A speaker button that reads text aloud in [lang] (default: the language
/// on screen).
class SpeakButton extends ConsumerWidget {
  const SpeakButton(this.text, {super.key, this.slow = false, this.lang});
  final String text;
  final bool slow;
  final Lang? lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
    tooltip: slow ? context.l10n.playSlow : context.l10n.playAudio,
    icon: Icon(slow ? Icons.slow_motion_video : Icons.volume_up),
    onPressed: () => ref
        .read(ttsProvider)
        .speak(text, lang: lang ?? ref.read(activeLangProvider), slow: slow),
  );
}

/// The three languages as chips at the top of the main screens. The one on
/// screen is filled with its colour; tapping another switches the app to it.
class LangSwitcher extends ConsumerWidget {
  const LangSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeLangProvider);
    final ui = ref.watch(uiLanguageProvider);
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final lang in Lang.values)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Tooltip(
                message: lang.displayName(ui),
                child: ChoiceChip(
                  key: ValueKey('lang-${lang.name}'),
                  label: Text(lang.code),
                  selected: lang == active,
                  showCheckmark: false,
                  selectedColor: lang.color,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: lang == active ? Colors.white : lang.color,
                  ),
                  side: BorderSide(color: lang.color),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MediaQuery.sizeOf(context).width < 420
                      ? MaterialTapTargetSize.shrinkWrap
                      : null,
                  labelPadding: MediaQuery.sizeOf(context).width < 420
                      ? const EdgeInsets.symmetric(horizontal: 2)
                      : null,
                  onSelected: (_) => switchLanguage(ref, lang),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Shown where the language on screen has no lessons in this build yet.
class NoContentYet extends ConsumerWidget {
  const NoContentYet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final track = ref.watch(activeTrackProvider);
    final ui = ref.watch(uiLanguageProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_top, size: 48, color: track.lang.color),
            const SizedBox(height: 16),
            Text(
              l.noContentYet(track.lang.displayName(ui)),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (track.startDate != null) ...[
              const SizedBox(height: 8),
              Text(
                l.startsOn(formatDay(track.startDate!)),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _day(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// yyyy-mm-dd, the same in every language. Wrapped in a left-to-right
/// isolate so Arabic text around it doesn't flip it to 07-12-2026.
String formatDay(DateTime d) => '\u2066${_day(d)}\u2069';

/// Lower-cases, trims and drops punctuation so typed answers compare fairly.
String normalizeAnswer(String s) => s
    .toLowerCase()
    .replaceAll(RegExp(r'[.,!?;:¿¡"„“”–-]'), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();
