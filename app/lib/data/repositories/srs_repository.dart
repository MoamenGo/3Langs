import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

import '../../srs/fsrs.dart';
import '../local/local_db.dart';
import '../models/learner.dart';

/// Flashcard state and reviews, scheduled with FSRS.
class SrsRepository {
  SrsRepository(this.local, {Fsrs? fsrs}) : fsrs = fsrs ?? Fsrs();
  final LocalDb local;
  Fsrs fsrs;
  static const _uuid = Uuid();

  Future<CardState?> card(String cardId) async {
    final row = await local.get(LocalDb.cardStates, cardId);
    return row == null ? null : CardState.fromJson(row);
  }

  /// Adds cards learned in a lesson to the review queue (skips known ones).
  Future<int> introduce(Iterable<String> cardIds, {DateTime? now}) async {
    now ??= DateTime.now().toUtc();
    var added = 0;
    for (final id in cardIds) {
      if (await local.get(LocalDb.cardStates, id) != null) continue;
      await local.putLocal(
        LocalDb.cardStates,
        id,
        CardState.fresh(id, now).toJson(),
      );
      added++;
    }
    return added;
  }

  /// Cards due now, oldest first. New cards are capped per day.
  Future<List<CardState>> dueCards({DateTime? now, int newLimit = 20}) async {
    now ??= DateTime.now().toUtc();
    final rows = await local.all(
      LocalDb.cardStates,
      filter: Filter.equals('deleted', false),
    );
    final cards = rows.map(CardState.fromJson).toList();
    final due =
        cards
            .where((c) => c.phase != CardPhase.newCard && !c.due.isAfter(now!))
            .toList()
          ..sort((a, b) => a.due.compareTo(b.due));
    final fresh = cards
        .where((c) => c.phase == CardPhase.newCard)
        .take(newLimit);
    return [...due, ...fresh];
  }

  Stream<int> watchDueCount() => local
      .watchAll(LocalDb.cardStates, filter: Filter.equals('deleted', false))
      .map((rows) {
        final now = DateTime.now().toUtc();
        return rows
            .map(CardState.fromJson)
            .where((c) => !c.due.isAfter(now))
            .length;
      });

  Future<CardState> answer(
    CardState card,
    Rating rating, {
    int? durationMs,
    DateTime? now,
  }) async {
    final result = fsrs.review(
      card,
      rating,
      now ?? DateTime.now(),
      logId: _uuid.v4(),
      durationMs: durationMs,
    );
    await local.putLocal(LocalDb.cardStates, card.cardId, result.card.toJson());
    await local.putLocal(
      LocalDb.reviewLogs,
      result.log.id,
      result.log.toJson(),
    );
    return result.card;
  }

  /// Words whose memory is stable (in review phase), for progress stats.
  Future<int> knownCount() async {
    final rows = await local.all(
      LocalDb.cardStates,
      filter: Filter.equals('state', CardPhase.review.index),
    );
    return rows.length;
  }
}
