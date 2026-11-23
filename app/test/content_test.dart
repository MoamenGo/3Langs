import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:three_lang/core/lang/lang.dart';
import 'package:three_lang/data/models/content.dart';
import 'package:three_lang/data/repositories/content_repository.dart';

void main() {
  late LevelContent a1;

  setUpAll(() {
    final raw = File('assets/content/de/a1.json').readAsStringSync();
    a1 = LevelContent.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  test('German A1 pack parses', () {
    expect(a1.lang, Lang.de);
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

  test('all words are explained in Arabic and English', () {
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
    expect(a1.vocab['de.a1.vocab.name']!.display, 'der Name');
    expect(a1.vocab['de.a1.vocab.stadt']!.plural, 'Städte');
  });

  test('every id carries its language and level', () {
    final ids = [
      ...a1.units.map((u) => u.id),
      ...a1.lessons.keys,
      ...a1.vocab.keys,
      ...a1.sentences.keys,
      ...a1.grammar.keys,
      ...a1.texts.keys,
    ];
    for (final id in ids) {
      final parsed = ContentId.parse(id);
      expect(parsed?.lang, Lang.de, reason: id);
      expect(parsed?.level, 'A1', reason: id);
    }
  });

  test('every unit belongs to a unit of the shared syllabus', () {
    expect(a1.units.map((u) => u.sharedUnitId), [
      'u.a1.01',
      'u.a1.02',
      'u.a1.03',
      'u.a1.04',
    ]);
  });

  test('bundled packs exist on disk', () {
    for (final MapEntry(key: lang, value: levels)
        in ContentRepository.bundled.entries) {
      for (final level in levels) {
        expect(
          File('assets/content/${lang.name}/${level.toLowerCase()}.json')
              .existsSync(),
          isTrue,
          reason: '$lang $level',
        );
      }
    }
  });

  test('shared outline runs A0 to C1 with 70 units', () {
    final raw = jsonDecode(
      File('assets/content/course_outline.json').readAsStringSync(),
    );
    final levels = (raw['levels'] as List)
        .map((e) => OutlineLevel.fromJson(e as Map<String, dynamic>))
        .toList();
    expect(levels.map((l) => l.id), cefrLevels);
    expect(levels.fold(0, (n, l) => n + l.unitIds.length), 70);
    for (final level in levels) {
      for (final theme in level.unitThemes) {
        expect(theme.values['ar'], isNotEmpty);
      }
    }
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
