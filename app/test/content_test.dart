import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:three_lang/core/lang/lang.dart';
import 'package:three_lang/data/models/content.dart';
import 'package:three_lang/data/models/contrast.dart';
import 'package:three_lang/data/repositories/content_repository.dart';

LevelContent load(Lang lang, String level) => LevelContent.fromJson(
  jsonDecode(
    File('assets/content/${lang.name}/${level.toLowerCase()}.json')
        .readAsStringSync(),
  ) as Map<String, dynamic>,
);

const articles = {
  Lang.de: {'der', 'die', 'das'},
  Lang.nl: {'de', 'het'},
  Lang.es: {'el', 'la'},
};

void main() {
  final packs = <(Lang, String), LevelContent>{};

  setUpAll(() {
    for (final MapEntry(key: lang, value: levels)
        in ContentRepository.bundled.entries) {
      for (final level in levels) {
        packs[(lang, level)] = load(lang, level);
      }
    }
  });

  test('every language ships A0 and A1', () {
    for (final lang in Lang.values) {
      expect(ContentRepository.bundled[lang], ['A0', 'A1'], reason: '$lang');
    }
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

  test('packs parse with four units each', () {
    for (final MapEntry(key: (lang, level), value: p) in packs.entries) {
      expect(p.lang, lang);
      expect(p.level.id, level);
      expect(p.units.map((u) => u.order), [1, 2, 3, 4], reason: '$lang');
      expect(
        p.vocab.length,
        greaterThanOrEqualTo(level == 'A0' ? 50 : 100),
        reason: '$lang $level',
      );
    }
  });

  test('every lesson points at existing content', () {
    for (final p in packs.values) {
      for (final lesson in p.lessons.values) {
        for (final id in lesson.items) {
          final found = lesson.type == LessonType.listening
              ? p.sentences.containsKey(id)
              : p.vocab.containsKey(id);
          expect(found, isTrue, reason: '${lesson.id} -> $id');
        }
        if (lesson.type == LessonType.grammar) {
          expect(p.grammar.containsKey(lesson.grammarId), isTrue);
        }
        if (lesson.type == LessonType.reading) {
          expect(p.texts.containsKey(lesson.textId), isTrue);
        }
      }
    }
  });

  test('words, sentences and grammar are explained in Arabic and English', () {
    for (final p in packs.values) {
      for (final lang in ExplainLang.values) {
        for (final v in p.vocab.values) {
          expect(v.translations.values[lang.name], isNotEmpty, reason: v.id);
        }
        for (final s in p.sentences.values) {
          expect(s.translations.values[lang.name], isNotEmpty, reason: s.id);
        }
        for (final g in p.grammar.values) {
          expect(g.title.values[lang.name], isNotEmpty, reason: g.id);
          expect(g.explanation.values[lang.name], isNotEmpty, reason: g.id);
        }
      }
    }
  });

  test('nouns carry an article of their own language', () {
    for (final MapEntry(key: (lang, _), value: p) in packs.entries) {
      for (final v in p.vocab.values.where((v) => v.article != null)) {
        expect(articles[lang], contains(v.article), reason: v.id);
      }
    }
    final de = packs[(Lang.de, 'A1')]!;
    expect(de.vocab['de.a1.vocab.name']!.display, 'der Name');
    expect(de.vocab['de.a1.vocab.stadt']!.plural, 'Städte');
    expect(
      packs[(Lang.nl, 'A1')]!.vocab['nl.a1.vocab.huis']!.display,
      'het huis',
    );
    expect(
      packs[(Lang.es, 'A1')]!.vocab['es.a1.vocab.mesa']!.display,
      'la mesa',
    );
  });

  test('every id carries its language and level', () {
    for (final MapEntry(key: (lang, level), value: p) in packs.entries) {
      final ids = [
        ...p.units.map((u) => u.id),
        ...p.lessons.keys,
        ...p.vocab.keys,
        ...p.sentences.keys,
        ...p.grammar.keys,
        ...p.texts.keys,
      ];
      for (final id in ids) {
        final parsed = ContentId.parse(id);
        expect(parsed?.lang, lang, reason: id);
        expect(parsed?.level, level, reason: id);
      }
    }
  });

  test('units follow the shared syllabus in every language', () {
    for (final MapEntry(key: (_, level), value: p) in packs.entries) {
      final l = level.toLowerCase();
      expect(p.units.map((u) => u.sharedUnitId), [
        'u.$l.01',
        'u.$l.02',
        'u.$l.03',
        'u.$l.04',
      ]);
    }
  });

  test('the three languages teach the same concepts at each level', () {
    for (final level in ['A0', 'A1']) {
      Set<String?> concepts(Lang lang) =>
          packs[(lang, level)]!.vocab.values.map((v) => v.conceptId).toSet();
      final de = concepts(Lang.de);
      expect(de, isNot(contains(null)), reason: level);
      expect(concepts(Lang.nl), de, reason: level);
      expect(concepts(Lang.es), de, reason: level);
    }
  });

  test('a word is never taught twice in one language', () {
    for (final lang in Lang.values) {
      final a0 = packs[(lang, 'A0')]!.vocab.values.map((v) => v.display);
      final a1 = packs[(lang, 'A1')]!.vocab.values.map((v) => v.display);
      expect(a0.toSet().intersection(a1.toSet()), isEmpty, reason: '$lang');
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

  test('every A1 unit has vocab, grammar, listening, reading and review', () {
    for (final lang in Lang.values) {
      final p = packs[(lang, 'A1')]!;
      for (final unit in p.units) {
        final types = p.lessonsOf(unit).map((l) => l.type).toSet();
        expect(
          types,
          containsAll(LessonType.values.where((t) => t != LessonType.exam)),
          reason: unit.id,
        );
      }
    }
  });

  test('every word has an example sentence that uses it', () {
    for (final p in packs.values) {
      for (final v in p.vocab.values) {
        expect(v.sentenceIds, isNotEmpty, reason: v.id);
      }
    }
  });

  group('contrast dictionary', () {
    late List<ContrastEntry> entries;
    setUpAll(() {
      final raw = jsonDecode(
        File('assets/content/contrast.json').readAsStringSync(),
      );
      entries = (raw['entries'] as List)
          .map((e) => ContrastEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('has all three kinds, with notes in Arabic and English', () {
      for (final kind in ContrastKind.values) {
        expect(entries.where((e) => e.kind == kind), isNotEmpty);
      }
      for (final e in entries) {
        expect(e.note.values['ar'], isNotEmpty, reason: e.id);
        expect(e.note.values['en'], isNotEmpty, reason: e.id);
        expect(e.forms.length, greaterThanOrEqualTo(2), reason: e.id);
      }
    });

    test('flags Dutch wie (who) against German wie (how)', () {
      final wieNl = packs[(Lang.nl, 'A0')]!.vocab['nl.a0.vocab.wie']!;
      final hits = entries.where((e) => e.concerns(wieNl));
      expect(hits.map((e) => e.kind), contains(ContrastKind.falseFriend));
    });

    test('flags der Tisch against la mesa', () {
      final mesa = packs[(Lang.es, 'A1')]!.vocab['es.a1.vocab.mesa']!;
      expect(
        entries.where((e) => e.concerns(mesa)).map((e) => e.kind),
        contains(ContrastKind.genderMismatch),
      );
    });
  });
}
