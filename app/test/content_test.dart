import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:three_lang/data/models/content.dart';

void main() {
  late LevelContent a1;

  setUpAll(() {
    final raw = File('assets/content/a1.json').readAsStringSync();
    a1 = LevelContent.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  test('A1 starter file parses', () {
    expect(a1.level.id, 'A1');
    expect(a1.units, isNotEmpty);
    expect(a1.vocab.length, greaterThanOrEqualTo(100));
    expect(a1.units.map((u) => u.order), [1, 2, 3, 4]);
  });

  test('every lesson points at existing content', () {
    for (final lesson in a1.lessons.values) {
      for (final id in lesson.items) {
        final found = lesson.type == LessonType.listening
            ? a1.sentences.containsKey(id)
            : a1.vocab.containsKey(id);
        expect(found, isTrue, reason: '${lesson.id} -> $id');
      }
      if (lesson.type == LessonType.grammar) {
        expect(a1.grammar.containsKey(lesson.grammarId), isTrue);
      }
      if (lesson.type == LessonType.reading) {
        expect(a1.texts.containsKey(lesson.textId), isTrue);
      }
    }
  });

  test('all words are explained in English, Dutch and Spanish', () {
    for (final v in a1.vocab.values) {
      for (final lang in ExplainLang.values) {
        expect(
          v.translations.values[lang.name],
          isNotEmpty,
          reason: '${v.id} ${lang.name}',
        );
      }
    }
  });

  test('nouns carry their article', () {
    expect(a1.vocab['a1.vocab.name']!.display, 'der Name');
    expect(a1.vocab['a1.vocab.stadt']!.plural, 'Städte');
  });

  test('outline covers 24 months', () {
    final raw = jsonDecode(
      File('assets/content/course_outline.json').readAsStringSync(),
    );
    final levels = (raw['levels'] as List)
        .map((e) => OutlineLevel.fromJson(e as Map<String, dynamic>))
        .toList();
    expect(levels.map((l) => l.id), ['A1', 'A2', 'B1', 'B2', 'C1']);
    expect(levels.last.months.last, 24);
  });

  test('every unit has vocab, grammar, listening, reading and review', () {
    for (final unit in a1.units) {
      final types = a1.lessonsOf(unit).map((l) => l.type).toSet();
      expect(
        types,
        containsAll(LessonType.values.where((t) => t != LessonType.exam)),
        reason: unit.id,
      );
    }
  });

  test('every word has an example sentence', () {
    for (final v in a1.vocab.values) {
      expect(v.sentenceIds, isNotEmpty, reason: v.id);
    }
  });
}
