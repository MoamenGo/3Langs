import 'package:flutter_test/flutter_test.dart';
import 'package:three_lang/core/lang/lang.dart';
import 'package:three_lang/data/local/local_db.dart';
import 'package:three_lang/data/local/migrations.dart';
import 'package:three_lang/data/models/learner.dart';
import 'package:three_lang/data/repositories/content_repository.dart';
import 'package:three_lang/data/repositories/track_repository.dart';

void main() {
  group('ContentId', () {
    test('reads language and level from an id', () {
      final id = ContentId.parse('es.b1.u03.l02')!;
      expect(id.lang, Lang.es);
      expect(id.level, 'B1');
      expect(ContentId.parse('a1.vocab.haus'), isNull);
    });

    test('old German ids get the de prefix, new ids stay', () {
      expect(ContentId.migrateLegacy('a1.vocab.haus'), 'de.a1.vocab.haus');
      expect(ContentId.migrateLegacy('de.a1.vocab.haus'), 'de.a1.vocab.haus');
      expect(ContentId.migrateLegacy('nl.a1.vocab.huis'), 'nl.a1.vocab.huis');
    });
  });

  test('German and Dutch are a similar pair, Spanish is not', () {
    expect(Lang.areSimilar(Lang.de, Lang.nl), isTrue);
    expect(Lang.areSimilar(Lang.de, Lang.es), isFalse);
    expect(Lang.areSimilar(Lang.nl, Lang.es), isFalse);
  });

  test('a language without a pack at its level falls back upwards', () {
    expect(ContentRepository.packLevelFor(Lang.de, 'A0'), 'A1');
    expect(ContentRepository.packLevelFor(Lang.de, 'A1'), 'A1');
    expect(ContentRepository.packLevelFor(Lang.es, 'A0'), isNull);
  });

  test('default plan: German now, Spanish week 3, Dutch week 9', () {
    final start = DateTime.utc(2026, 11, 23);
    final de = LanguageTrack.defaultFor(Lang.de, start);
    final es = LanguageTrack.defaultFor(Lang.es, start);
    final nl = LanguageTrack.defaultFor(Lang.nl, start);
    expect(de.isActiveOn(start), isTrue);
    expect(es.startDate, DateTime.utc(2026, 12, 7));
    expect(nl.startDate, DateTime.utc(2027, 1, 18));
    expect(es.isActiveOn(start), isFalse);
    expect(es.isActiveOn(DateTime.utc(2026, 12, 7)), isTrue);
  });

  test('old settings map to the new language choices', () {
    final s = UserSettings.fromJson({
      'ui_language': 'nl',
      'explanation_language': 'es',
      'current_level': 'A1',
    });
    expect(s.uiLanguage, 'ar');
    expect(s.explanationLanguage.name, 'ar');
    expect(s.activeLanguage, Lang.de);
    final en = UserSettings.fromJson({
      'ui_language': 'en',
      'explanation_language': 'en',
    });
    expect(en.uiLanguage, 'en');
    expect(en.explanationLanguage.name, 'en');
  });

  group('local migration to three languages', () {
    late LocalDb db;
    setUp(() async => db = await LocalDb.memory());
    tearDown(() => db.db.close());

    test('moves saved progress to the new German ids', () async {
      await db.putRemote(LocalDb.cardStates, 'a1.vocab.haus', {
        'card_id': 'a1.vocab.haus',
        'stability': 3.0,
        'updated_at': '2026-11-22T10:00:00Z',
      });
      await db.putRemote(LocalDb.reviewLogs, 'log1', {
        'id': 'log1',
        'card_id': 'a1.vocab.haus',
      });
      await db.putRemote(LocalDb.lessonProgress, 'a1.u01.l01', {
        'lesson_id': 'a1.u01.l01',
        'status': 'completed',
      });
      await db.putRemote(LocalDb.userSettings, 'me', {
        'ui_language': 'es',
        'explanation_language': 'nl',
        'current_level': 'A2',
        'updated_at': '2026-11-22T10:00:00Z',
      });

      await LocalMigrations(db).run(now: DateTime.utc(2026, 11, 23));

      expect(await db.get(LocalDb.cardStates, 'a1.vocab.haus'), isNull);
      final card = (await db.get(LocalDb.cardStates, 'de.a1.vocab.haus'))!;
      expect(card['card_id'], 'de.a1.vocab.haus');
      expect(card['stability'], 3.0);
      expect(card[LocalDb.dirtyField], isTrue);
      expect(
        (await db.get(LocalDb.reviewLogs, 'log1'))!['card_id'],
        'de.a1.vocab.haus',
      );
      expect(await db.get(LocalDb.lessonProgress, 'de.a1.u01.l01'), isNotNull);

      final settings = (await db.get(LocalDb.userSettings, 'me'))!;
      expect(settings['ui_language'], 'ar');
      expect(settings['explanation_language'], 'ar');

      final tracks = await TrackRepository(db).all();
      expect(tracks.keys, containsAll(Lang.values));
      expect(tracks[Lang.de]!.currentLevel, 'A2');
      expect(tracks[Lang.es]!.status, TrackStatus.scheduled);
    });

    test('runs only once', () async {
      await LocalMigrations(db).run();
      await db.putRemote(LocalDb.cardStates, 'a1.vocab.x', {
        'card_id': 'a1.vocab.x',
      });
      await LocalMigrations(db).run();
      // Second run leaves data alone; sync pull handles stragglers.
      expect(await db.get(LocalDb.cardStates, 'a1.vocab.x'), isNotNull);
    });

    test('rows pulled from an old server get the new ids', () {
      final row = migrateLegacyRow(LocalDb.cardStates, {
        'card_id': 'a1.vocab.haus',
      });
      expect(row['card_id'], 'de.a1.vocab.haus');
    });
  });
}
