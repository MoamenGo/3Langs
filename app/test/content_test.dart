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
  Lang.es: {'el', 'la', 'los', 'las'},
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

  test('every language ships every level, A0 to C1', () {
    for (final lang in Lang.values) {
      expect(ContentRepository.bundled[lang], cefrLevels, reason: '$lang');
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

  test('packs parse with every unit of their level', () {
    const units = {'A0': 4, 'A1': 12, 'A2': 12, 'B1': 16, 'B2': 14, 'C1': 12};
    for (final MapEntry(key: (lang, level), value: p) in packs.entries) {
      expect(p.lang, lang);
      expect(p.level.id, level);
      expect(p.units.map((u) => u.order), [
        for (var i = 1; i <= units[level]!; i++) i,
      ], reason: '$lang $level');
      expect(
        p.vocab.length,
        greaterThanOrEqualTo(level == 'A0' ? 50 : 100),
        reason: '$lang $level',
      );
    }
  });

  test('every level after A0 ends with an exam', () {
    for (final MapEntry(key: (_, level), value: p) in packs.entries) {
      if (level == 'A0') continue;
      final last = p.lessonsOf(p.units.last);
      expect(last.last.type, LessonType.exam, reason: p.units.last.id);
      expect(p.grammar.values.expand((g) => g.exercises), isNotEmpty);
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
        for (var i = 1; i <= p.units.length; i++)
          'u.$l.${i.toString().padLeft(2, '0')}',
      ]);
    }
  });

  test('the three languages teach the same concepts at each level', () {
    for (final level in cefrLevels) {
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
      final seen = <String>{};
      for (final level in cefrLevels) {
        for (final v in packs[(lang, level)]!.vocab.values) {
          expect(seen.add(v.display), isTrue, reason: '$lang ${v.id}');
        }
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

  test('every unit has vocab, grammar, listening and review', () {
    for (final p in packs.values) {
      if (p.level.id == 'A0') continue;
      for (final unit in p.units.take(p.units.length - 1)) {
        final types = p.lessonsOf(unit).map((l) => l.type).toSet();
        expect(
          types,
          containsAll([
            LessonType.vocab,
            LessonType.grammar,
            LessonType.listening,
            LessonType.review,
          ]),
          reason: unit.id,
        );
      }
    }
  });

  test('A1 units 1-4 also have a reading text', () {
    for (final lang in Lang.values) {
      final p = packs[(lang, 'A1')]!;
      for (final unit in p.units.take(4)) {
        expect(
          p.lessonsOf(unit).map((l) => l.type),
          contains(LessonType.reading),
          reason: unit.id,
        );
      }
    }
  });

  test('every starter word has an example sentence that uses it', () {
    // A0 and A1 units 1-4 have an example for every word; later units have
    // fewer example sentences, linked wherever a sentence uses the word.
    for (final p in packs.values) {
      if (p.level.id != 'A0' && p.level.id != 'A1') continue;
      final starter = p.units
          .where((u) => u.order <= 4)
          .expand(p.lessonsOf)
          .where((l) => l.type == LessonType.vocab)
          .expand((l) => l.items);
      for (final id in starter) {
        expect(p.vocab[id]!.sentenceIds, isNotEmpty, reason: id);
      }
    }
  });

  test('example sentences exist in every unit and level', () {
    for (final p in packs.values) {
      final linked = p.vocab.values.where((v) => v.sentenceIds.isNotEmpty);
      expect(
        linked.length,
        greaterThan(p.vocab.length * 0.25),
        reason: '${p.lang} ${p.level.id}',
      );
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

  test('every A0 sounds page has a sound-by-sound guide', () {
    for (final lang in Lang.values) {
      final c = load(lang, 'A0');
      final sounds = c.grammar['${lang.name}.a0.gram.sounds']!;
      expect(sounds.guide.length, greaterThanOrEqualTo(12), reason: lang.name);
      for (final s in sounds.guide) {
        expect(s.explain.values['ar'], isNotEmpty, reason: s.letters);
        expect(s.explain.values['en'], isNotEmpty, reason: s.letters);
        expect(s.examples, isNotEmpty, reason: s.letters);
        // Bundled fonts have no arrow glyphs.
        expect(s.like.values.values.join(), isNot(contains('→')));
      }
    }
  });
}
