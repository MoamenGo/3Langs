// End-of-level exams and the placement test. Both are built from the course
// packs, so they grow with the content and never need a separate question
// bank.

import 'dart:math';

import '../../core/lang/lang.dart';
import '../../data/models/content.dart';

/// Score needed to pass an end-of-level exam (and to move up a level).
const examPassMark = 0.7;

/// Score per level in the placement test that counts as "you know this".
const placementPassMark = 0.7;

class ExamPlan {
  const ExamPlan({required this.words, required this.exercises});

  /// Meaning questions ("Which word means ...?").
  final List<VocabItem> words;

  /// Grammar gap fills from the whole level.
  final List<GrammarExercise> exercises;

  int get length => words.length + exercises.length;
}

/// Builds an end-of-level exam: words from every unit (so the exam covers the
/// whole level) and grammar exercises from every grammar point.
ExamPlan buildLevelExam(
  LevelContent c, {
  Random? random,
  int wordCount = 20,
  int grammarCount = 10,
}) {
  final rnd = random ?? Random();
  final byUnit = <String, List<VocabItem>>{};
  final vocabLessons = c.lessons.values.where(
    (l) => l.type == LessonType.vocab,
  );
  for (final l in vocabLessons) {
    for (final id in l.items) {
      final v = c.vocab[id];
      if (v != null) byUnit.putIfAbsent(l.unitId, () => []).add(v);
    }
  }
  // Round-robin over the units so each one is represented.
  for (final list in byUnit.values) {
    list.shuffle(rnd);
  }
  final words = <VocabItem>[];
  final seen = <String>{};
  final pools = byUnit.values.toList()..shuffle(rnd);
  var i = 0;
  while (words.length < wordCount && pools.any((p) => p.length > i)) {
    for (final p in pools) {
      if (p.length > i && seen.add(p[i].id)) words.add(p[i]);
      if (words.length >= wordCount) break;
    }
    i++;
  }
  final exercises = [for (final g in c.grammar.values) ...g.exercises]
    ..shuffle(rnd);
  return ExamPlan(
    words: words,
    exercises: exercises.take(grammarCount).toList(),
  );
}

/// Placement test: a few words from each level, easiest first.
class PlacementPlan {
  const PlacementPlan(this.lang, this.byLevel);
  final Lang lang;

  /// Level id -> words to ask, in level order (A1 ... C1).
  final Map<String, List<VocabItem>> byLevel;
}

PlacementPlan buildPlacement(
  Lang lang,
  List<LevelContent> packs, {
  int perLevel = 6,
  Random? random,
}) {
  final rnd = random ?? Random();
  final byLevel = <String, List<VocabItem>>{};
  for (final level in cefrLevels.skip(1)) {
    final pack = packs.where((p) => p.lang == lang && p.level.id == level);
    if (pack.isEmpty) continue;
    final words = pack.first.vocab.values.toList()..shuffle(rnd);
    byLevel[level] = words.take(perLevel).toList();
  }
  return PlacementPlan(lang, byLevel);
}

/// The level to start at from placement scores (level -> 0..1). You start at
/// the first level you did not pass; passing nothing means A0.
String placementLevel(Map<String, double> scores) {
  var start = 'A0';
  for (final level in cefrLevels.skip(1)) {
    final s = scores[level];
    if (s == null) break;
    if (s >= placementPassMark) {
      final next = cefrLevels.indexOf(level) + 1;
      start = next < cefrLevels.length ? cefrLevels[next] : level;
    } else {
      // A0 is only for complete beginners: some A1 words known means A1.
      if (level == 'A1' && s >= 0.3) start = 'A1';
      break;
    }
  }
  return start;
}
