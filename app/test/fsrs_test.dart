import 'package:flutter_test/flutter_test.dart';
import 'package:three_lang/data/models/learner.dart';
import 'package:three_lang/srs/fsrs.dart';

void main() {
  final fsrs = Fsrs();
  final t0 = DateTime.utc(2026, 11, 21, 9);
  CardState fresh() => CardState.fresh('a1.vocab.haus', t0);

  test('interval equals stability at 90% retention', () {
    expect(fsrs.nextIntervalDays(10), 10);
    expect(fsrs.retrievability(10, 10), closeTo(0.9, 1e-9));
  });

  test('new card: Good goes to review in about 4 days', () {
    final r = fsrs.review(fresh(), Rating.good, t0, logId: 'x');
    expect(r.card.phase, CardPhase.review);
    expect(r.card.due.difference(t0).inDays, 4);
    expect(r.card.reps, 1);
    expect(r.log.rating, Rating.good);
  });

  test('new card: Again stays in learning for a minute', () {
    final r = fsrs.review(fresh(), Rating.again, t0, logId: 'x');
    expect(r.card.phase, CardPhase.learning);
    expect(r.card.due.difference(t0), const Duration(minutes: 1));
  });

  test('buttons give increasing intervals', () {
    final reviewed = fsrs.review(fresh(), Rating.good, t0, logId: 'x').card;
    final later = reviewed.due;
    final p = fsrs.preview(reviewed, later);
    expect(p[Rating.again]! < p[Rating.hard]!, isTrue);
    expect(p[Rating.hard]! <= p[Rating.good]!, isTrue);
    expect(p[Rating.good]! < p[Rating.easy]!, isTrue);
  });

  test('forgetting a review card counts a lapse and lowers stability', () {
    final reviewed = fsrs.review(fresh(), Rating.good, t0, logId: 'x').card;
    final r = fsrs.review(reviewed, Rating.again, reviewed.due, logId: 'y');
    expect(r.card.phase, CardPhase.relearning);
    expect(r.card.lapses, 1);
    expect(r.card.stability, lessThan(reviewed.stability));
  });

  test('successful reviews make intervals grow', () {
    var card = fsrs.review(fresh(), Rating.good, t0, logId: 'a').card;
    var last = card.due.difference(t0);
    for (var i = 0; i < 4; i++) {
      final now = card.due;
      card = fsrs.review(card, Rating.good, now, logId: 'r$i').card;
      final interval = card.due.difference(now);
      expect(interval, greaterThan(last));
      last = interval;
    }
  });

  test('card state survives a JSON round trip (sync format)', () {
    final card = fsrs.review(fresh(), Rating.good, t0, logId: 'x').card;
    final back = CardState.fromJson(card.toJson());
    expect(back.toJson(), card.toJson());
  });
}
