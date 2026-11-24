import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../data/models/learner.dart';
import '../listening/dictation.dart';
import '../reading/reading_view.dart';
import '../../data/repositories/assessment_repository.dart';
import '../../data/repositories/content_repository.dart';
import '../../domain/assessment/assessment.dart';
import 'exam_runner.dart';
import 'exercises.dart';

/// Runs one lesson. Vocab lessons: study cards, then a quiz. Grammar: rule,
/// table, then fill-in exercises. Listening: dictation. Reading: text and
/// questions. Review: quiz over the whole unit. At the end, the lesson is
/// marked complete and its words join the flashcard queue.
class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({super.key, required this.lessonId});

  /// For example `de.a1.u03.l02`; the language and level come from the id.
  final String lessonId;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  ({double score, int added})? _result;
  ({double score, String? next})? _exam;

  Future<void> _finishExam(Lesson lesson, LevelContent c, double score) async {
    final passed = score >= examPassMark;
    await ref
        .read(assessmentRepositoryProvider)
        .record(
          lang: c.lang,
          level: c.level.id,
          kind: AssessmentKind.exam,
          score: score,
          passed: passed,
        );
    String? next;
    if (passed) {
      await ref.read(progressRepositoryProvider).completeLesson(lesson.id, score);
      next = ContentRepository.nextPackLevel(c.lang, c.level.id);
      if (next != null) await setTrackLevel(ref, c.lang, next);
    }
    ref.read(syncServiceProvider).schedule();
    if (mounted) setState(() => _exam = (score: score, next: next));
  }

  Future<void> _finish(Lesson lesson, double score) async {
    await ref.read(progressRepositoryProvider).completeLesson(lesson.id, score);
    var added = 0;
    if (lesson.type == LessonType.vocab || lesson.type == LessonType.review) {
      added = await ref.read(srsRepositoryProvider).introduce(lesson.items);
    }
    ref.read(syncServiceProvider).schedule();
    if (mounted) setState(() => _result = (score: score, added: added));
  }

  @override
  Widget build(BuildContext context) {
    final content = ref.watch(levelContentProvider(packKeyOf(widget.lessonId)));
    final lang = ref.watch(explainLangProvider);
    return StudyTimer(
      activity: Activity.lesson,
      child: AsyncView(
        value: content,
        builder: (c) {
          final lesson = c.lessons[widget.lessonId]!;
          return Scaffold(
            appBar: AppBar(title: Text(lesson.title.get(lang))),
            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _exam != null
                        ? _ExamResult(
                            score: _exam!.score,
                            level: c.level.id,
                            next: _exam!.next,
                            onRetry: () => setState(() => _exam = null),
                          )
                        : _result != null
                        ? _LessonResult(
                            score: _result!.score,
                            added: _result!.added,
                          )
                        : _body(lesson, c, (s) => _finish(lesson, s)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(Lesson lesson, LevelContent c, void Function(double) done) {
    final words = lesson.items
        .map((id) => c.vocab[id])
        .whereType<VocabItem>()
        .toList();
    switch (lesson.type) {
      case LessonType.vocab:
        return _VocabLesson(words: words, content: c, onDone: done);
      case LessonType.review:
        return ChoiceQuiz(
          items: words,
          pool: c.vocab.values.toList(),
          onDone: done,
        );
      case LessonType.grammar:
        return _GrammarLesson(
          point: c.grammar[lesson.grammarId]!,
          content: c,
          onDone: done,
        );
      case LessonType.listening:
        final sentences = lesson.items
            .map((id) => c.sentences[id])
            .whereType<Sentence>()
            .toList();
        return DictationRunner(sentences: sentences, onDone: done);
      case LessonType.reading:
        return ReadingView(
          text: c.texts[lesson.textId]!,
          content: c,
          onDone: done,
        );
      case LessonType.exam:
        return ExamRunner(
          content: c,
          onDone: (s) => _finishExam(lesson, c, s),
        );
    }
  }
}

class _VocabLesson extends StatefulWidget {
  const _VocabLesson({
    required this.words,
    required this.content,
    required this.onDone,
  });
  final List<VocabItem> words;
  final LevelContent content;
  final void Function(double) onDone;

  @override
  State<_VocabLesson> createState() => _VocabLessonState();
}

class _VocabLessonState extends State<_VocabLesson> {
  int _index = 0;
  bool _quiz = false;

  @override
  Widget build(BuildContext context) {
    if (_quiz) {
      return ChoiceQuiz(
        items: widget.words,
        pool: widget.content.vocab.values.toList(),
        onDone: widget.onDone,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: (_index + 1) / widget.words.length),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: WordCard(
              item: widget.words[_index],
              content: widget.content,
            ),
          ),
        ),
        Row(
          children: [
            if (_index > 0)
              IconButton(
                onPressed: () => setState(() => _index--),
                icon: const Icon(Icons.arrow_back),
              ),
            const Spacer(),
            FilledButton(
              onPressed: () => setState(() {
                if (_index + 1 < widget.words.length) {
                  _index++;
                } else {
                  _quiz = true;
                }
              }),
              child: Text(context.l10n.next),
            ),
          ],
        ),
      ],
    );
  }
}

class _GrammarLesson extends ConsumerStatefulWidget {
  const _GrammarLesson({
    required this.point,
    required this.content,
    required this.onDone,
  });
  final GrammarPoint point;
  final LevelContent content;
  final void Function(double) onDone;

  @override
  ConsumerState<_GrammarLesson> createState() => _GrammarLessonState();
}

class _GrammarLessonState extends ConsumerState<_GrammarLesson> {
  bool _practice = false;

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(explainLangProvider);
    final p = widget.point;
    if (_practice) {
      return FillBlankRunner(exercises: p.exercises, onDone: widget.onDone);
    }
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            children: [
              Text(p.title.get(lang), style: theme.headlineSmall),
              const SizedBox(height: 12),
              Text(
                p.explanation.get(lang),
                style: theme.bodyLarge?.copyWith(height: 1.5),
              ),
              if (p.tableRows.isNotEmpty) ...[
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      for (final h in p.tableHeaders)
                        DataColumn(label: Text(h)),
                    ],
                    rows: [
                      for (final row in p.tableRows)
                        DataRow(
                          cells: [for (final cell in row) DataCell(Text(cell))],
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              for (final id in p.exampleSentenceIds)
                if (widget.content.sentences[id] case final s?)
                  ListTile(
                    title: Text(s.text),
                    subtitle: Text(s.translations.get(lang)),
                    trailing: SpeakButton(s.text),
                  ),
            ],
          ),
        ),
        FilledButton(
          onPressed: () => setState(() => _practice = true),
          child: Text(context.l10n.next),
        ),
      ],
    );
  }
}

class _LessonResult extends StatelessWidget {
  const _LessonResult({required this.score, required this.added});
  final double score;
  final int added;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.celebration, size: 72, color: Colors.amber),
        const SizedBox(height: 16),
        Text(l.lessonDone, style: Theme.of(context).textTheme.headlineSmall),
        Text(l.scoreLabel((score * 100).round())),
        const SizedBox(height: 8),
        Text(l.wordsAddedToReview(added)),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.pop(),
          child: Text(l.backToCourse),
        ),
      ],
    );
  }
}

class _ExamResult extends StatelessWidget {
  const _ExamResult({
    required this.score,
    required this.level,
    required this.next,
    required this.onRetry,
  });
  final double score;
  final String level;
  final String? next;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final passed = score >= examPassMark;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          passed ? Icons.workspace_premium : Icons.replay,
          size: 72,
          color: passed ? Colors.amber : Colors.blueGrey,
        ),
        const SizedBox(height: 16),
        Text(
          passed ? l.examPassed(level) : l.examFailed(level),
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        Text(l.scoreLabel((score * 100).round())),
        if (passed && next != null) ...[
          const SizedBox(height: 8),
          Text(l.nowAtLevel(next!), textAlign: TextAlign.center),
        ],
        const SizedBox(height: 24),
        if (!passed)
          OutlinedButton(onPressed: onRetry, child: Text(l.tryAgain)),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () => context.pop(),
          child: Text(l.backToCourse),
        ),
      ],
    );
  }
}
