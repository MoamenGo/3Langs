import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:three_lang/core/lang/lang.dart';
import 'package:three_lang/data/models/content.dart';
import 'package:three_lang/data/models/learner.dart';
import 'package:three_lang/domain/assessment/assessment.dart';
import 'package:three_lang/domain/interference/contrast_drill.dart';
import 'package:three_lang/domain/interference/interference_detector.dart';
import 'package:three_lang/domain/scheduling/retention_calibrator.dart';

VocabItem w(String lang, String lemma, String? article) => VocabItem(
  id: '$lang.a1.vocab.$lemma',
  lemma: lemma,
  article: article,
  pos: 'noun',
  level: 'A1',
  translations: const L10nText({'en': 'house', 'ar': 'بيت'}),
  sentenceIds: const [],
  source: '',
  license: '',
  conceptId: 'c.a1.house',
);

void main() {
  final de = w('de', 'Haus', 'das');
  final nl = w('nl', 'huis', 'het');
  final es = w('es', 'casa', 'la');
  final concepts = {
    'c.a1.house': {Lang.de: de, Lang.nl: nl, Lang.es: es},
  };
  final detector = InterferenceDetector(concepts: concepts);

  test('German word typed in Dutch is a mix-up', () {
    final m = detector.check(nl, 'das Haus');
    expect(m?.otherLang, Lang.de);
    expect(detector.check(nl, 'Haus')?.otherLang, Lang.de);
  });

  test('right answers and unrelated mistakes are not mix-ups', () {
    expect(detector.check(nl, 'het huis'), isNull);
    expect(detector.check(nl, 'huis'), isNull);
    expect(detector.check(nl, 'auto'), isNull);
  });

  test('contrast drill offers all three words and a wrong article', () {
    final q = buildContrastDrill(
      concepts: concepts,
      contrast: const [],
      events: [
        InterferenceEvent(
          id: '1',
          lang: Lang.nl,
          otherLang: Lang.de,
          conceptId: 'c.a1.house',
          expected: 'het huis',
          given: 'das Haus',
          at: DateTime.now(),
        ),
      ],
      langs: Lang.values.toSet(),
      random: Random(1),
    );
    expect(q, hasLength(1));
    expect(q.first.options.where((o) => o.correct), hasLength(1));
    expect(q.first.options.length, 4);
  });

  test('placement starts at the first level not passed', () {
    expect(placementLevel({'A1': 0.1}), 'A0');
    expect(placementLevel({'A1': 0.5}), 'A1');
    expect(placementLevel({'A1': 1, 'A2': 0.4}), 'A2');
    expect(placementLevel({'A1': 1, 'A2': 1, 'B1': 1, 'B2': 1, 'C1': 1}), 'C1');
  });

  test('retention is calibrated per language', () {
    final reviews = [
      for (var i = 0; i < 100; i++)
        (
          cardId: 'nl.a1.vocab.x$i',
          before: CardPhase.review,
          rating: i < 30 ? Rating.again : Rating.good,
        ),
    ];
    final r = const RetentionCalibrator().calibrate(reviews, 0.9);
    expect(r[Lang.nl]!, greaterThan(0.9)); // forgot more than planned
    expect(r[Lang.de], 0.9); // not enough reviews yet
  });
}
