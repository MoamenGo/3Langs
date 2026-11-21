import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../data/models/learner.dart';
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

/// A speaker button that reads German text aloud.
class SpeakButton extends ConsumerWidget {
  const SpeakButton(this.text, {super.key, this.slow = false});
  final String text;
  final bool slow;

  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
    tooltip: slow ? context.l10n.playSlow : context.l10n.playAudio,
    icon: Icon(slow ? Icons.slow_motion_video : Icons.volume_up),
    onPressed: () => ref.read(ttsProvider).speak(text, slow: slow),
  );
}

/// Lower-cases, trims and drops punctuation so typed answers compare fairly.
String normalizeAnswer(String s) => s
    .toLowerCase()
    .replaceAll(RegExp(r'[.,!?;:¿¡"„“”–-]'), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();
