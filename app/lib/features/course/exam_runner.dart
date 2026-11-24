import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../domain/assessment/assessment.dart';
import 'exercises.dart';

/// End-of-level exam: meaning questions from every unit, then grammar gap
/// fills. Calls [onDone] with the overall score (0..1).
class ExamRunner extends ConsumerStatefulWidget {
  const ExamRunner({super.key, required this.content, required this.onDone});
  final LevelContent content;
  final void Function(double score) onDone;

  @override
  ConsumerState<ExamRunner> createState() => _ExamRunnerState();
}

class _ExamRunnerState extends ConsumerState<ExamRunner> {
  late final ExamPlan _plan = buildLevelExam(widget.content);
  bool _started = false;
  double? _wordScore;

  void _finish(double grammarScore) {
    final p = _plan;
    final total = p.words.length * (_wordScore ?? 0) +
        p.exercises.length * grammarScore;
    widget.onDone(p.length == 0 ? 0 : total / p.length);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (!_started) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.workspace_premium, size: 64),
          const SizedBox(height: 16),
          Text(
            l.examIntro(
              widget.content.level.id,
              _plan.length,
              (examPassMark * 100).round(),
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const ValueKey('start-exam'),
            onPressed: () => setState(() => _started = true),
            child: Text(l.startExam),
          ),
        ],
      );
    }
    if (_wordScore == null && _plan.words.isNotEmpty) {
      return ChoiceQuiz(
        items: _plan.words,
        pool: widget.content.vocab.values.toList(),
        onDone: (s) {
          if (_plan.exercises.isEmpty) {
            _wordScore = s;
            _finish(0);
          } else {
            setState(() => _wordScore = s);
          }
        },
      );
    }
    return FillBlankRunner(exercises: _plan.exercises, onDone: _finish);
  }
}
