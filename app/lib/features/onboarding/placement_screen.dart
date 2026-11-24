import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/lang/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/repositories/assessment_repository.dart';
import '../../domain/assessment/assessment.dart';
import '../course/exercises.dart';

/// Placement test for one language: a few words per level, easiest first.
/// Stops at the first level you don't pass and starts you there.
class PlacementScreen extends ConsumerStatefulWidget {
  const PlacementScreen({super.key, required this.lang});
  final Lang lang;

  @override
  ConsumerState<PlacementScreen> createState() => _PlacementScreenState();
}

class _PlacementScreenState extends ConsumerState<PlacementScreen> {
  PlacementPlan? _plan;
  final _scores = <String, double>{};
  String? _result;
  bool _started = false;

  Future<void> _levelDone(String level, double score) async {
    _scores[level] = score;
    final levels = _plan!.byLevel.keys.toList();
    final i = levels.indexOf(level);
    if (score >= placementPassMark && i + 1 < levels.length) {
      setState(() {});
      return;
    }
    final start = placementLevel(_scores);
    await ref
        .read(assessmentRepositoryProvider)
        .record(
          lang: widget.lang,
          level: start,
          kind: AssessmentKind.placement,
          score: score,
          passed: score >= placementPassMark,
        );
    await setTrackLevel(ref, widget.lang, start);
    if (mounted) setState(() => _result = start);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ui = ref.watch(uiLanguageProvider);
    final name = widget.lang.displayName(ui);
    return Scaffold(
      appBar: AppBar(title: Text(l.placementTitle(name))),
      body: AsyncView(
        value: ref.watch(allContentProvider),
        builder: (packs) {
          _plan ??= buildPlacement(widget.lang, packs);
          final plan = _plan!;
          Widget body;
          if (_result != null) {
            body = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flag, size: 64, color: widget.lang.color),
                const SizedBox(height: 16),
                Text(
                  l.placementResult(name, _result!),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.pop(),
                  child: Text(l.done),
                ),
              ],
            );
          } else if (!_started) {
            body = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.quiz, size: 64, color: widget.lang.color),
                const SizedBox(height: 16),
                Text(
                  l.placementIntro(name),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  key: const ValueKey('start-placement'),
                  onPressed: () => setState(() => _started = true),
                  child: Text(l.startExam),
                ),
                TextButton(
                  onPressed: () async {
                    await setTrackLevel(ref, widget.lang, 'A0');
                    if (context.mounted) context.pop();
                  },
                  child: Text(l.placementBeginner),
                ),
              ],
            );
          } else {
            final level = plan.byLevel.keys.firstWhere(
              (lv) => !_scores.containsKey(lv),
            );
            body = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.placementLevel(level),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Expanded(
                  child: ChoiceQuiz(
                    key: ValueKey(level),
                    items: plan.byLevel[level]!,
                    pool: [for (final w in plan.byLevel.values) ...w],
                    onDone: (s) => _levelDone(level, s),
                  ),
                ),
              ],
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Padding(padding: const EdgeInsets.all(16), child: body),
            ),
          );
        },
      ),
    );
  }
}
