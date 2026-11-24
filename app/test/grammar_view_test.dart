import 'package:flutter_test/flutter_test.dart';
import 'package:three_lang/core/lang/lang.dart';
import 'package:three_lang/features/course/grammar_view.dart';

void main() {
  test('explanations split into points, bullets and from -> to pairs', () {
    final blocks = parseExplanation(
      'Formal German turns verbs into nouns.\n\n'
      '- verb stem + -ung (feminine): entscheiden -> die Entscheidung, entwickeln -> die Entwicklung\n'
      '- adjective + -heit: frei -> die Freiheit\n\n'
      'The object becomes a genitive.',
    );
    expect(blocks.length, 3);
    expect(blocks.first, isA<ParagraphBlock>());
    final bullets = (blocks[1] as BulletsBlock).items;
    expect(bullets.first.label, 'verb stem + -ung (feminine)');
    expect(bullets.first.pairs, [
      ('entscheiden', 'die Entscheidung'),
      ('entwickeln', 'die Entwicklung'),
    ]);
    expect(bullets[1].pairs, [('frei', 'die Freiheit')]);
  });

  test('a bullet without arrows keeps its text', () {
    final b = parseBullet(
      'ja: something we both know: Das ist ja interessant.',
    );
    expect(b.label, 'ja');
    expect(b.pairs, isEmpty);
    expect(b.text, contains('Das ist ja interessant'));
  });

  test('YouTube links search the exact topic in the language', () {
    final url = YouTubeCard.searchUrl(
      'The Präteritum',
      Lang.de,
      'grammar explained',
    );
    expect(url.host, 'www.youtube.com');
    expect(
      url.queryParameters['search_query'],
      'The Präteritum German grammar explained',
    );
  });

  test('German units link to the matching Piece of German week', () {
    expect(
      pieceOfGermanUrl('A1', 3).toString(),
      'https://www.pieceofgerman.com/a1/week-3',
    );
    expect(
      pieceOfGermanUrl('A1', 13).toString(),
      'https://www.pieceofgerman.com/a1/exam-week',
    );
    expect(
      pieceOfGermanUrl('B1', 9).toString(),
      'https://www.pieceofgerman.com/b1',
    );
    expect(
      pieceOfGermanUrl('B2', 2).toString(),
      'https://www.pieceofgerman.com/b2/lesson-2',
    );
  });
}
