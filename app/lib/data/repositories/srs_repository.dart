import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

import '../../core/lang/lang.dart';
import '../../domain/scheduling/retention_calibrator.dart';
import '../../srs/fsrs.dart';
import '../local/local_db.dart';
import '../models/learner.dart';

/// Flashcard state and reviews, scheduled with FSRS. Each language gets its
/// own target retention once it has enough reviews (RetentionCalibrator).
class SrsRepository {
  SrsRepository(this.local, {Fsrs? fsrs}) : fsrs = fsrs ?? Fsrs();
  final LocalDb local;

  /// The scheduler with your global settings.
  Fsrs fsrs;
  static const _uuid = Uuid();

  Map<Lang, Fsrs>? _perLang;

  /// Target retention in use per language (after calibration).
  Future<Map<Lang, double>> retentionByLang() async {
    final m = await _schedulers();
    return {for (final e in m.entries) e.key: e.value.desiredRetention};
  }

  Future<Map<Lang, Fsrs>> _schedulers() async {
    if (_perLang != null) return _perLang!;
    final logs = await local.all(LocalDb.reviewLogs);
    final outcomes = <ReviewOutcome>[
      for (final r in logs)
        (
          cardId: r['card_id'] as String,
          before: CardPhase.values[(r['state_before'] as int?) ?? 0],
          rating: Rating.values.firstWhere(
            (x) => x.value == r['rating'],
            orElse: () => Rating.good,
          ),
        ),
    ];
    final targets = const RetentionCalibrator().calibrate(
      outcomes,
      fsrs.desiredRetention,
    );
    return _perLang = {
      for (final e in targets.entries)
        e.key: e.value == fsrs.desiredRetention
            ? fsrs
            : Fsrs(desiredRetention: e.value, weights: fsrs.w),
    };
  }

  /// The scheduler for one card, by the language in its id.
  Future<Fsrs> fsrsFor(String cardId) async {
    final lang = ContentId.parse(cardId)?.lang;
    if (lang == null) return fsrs;
    return (await _schedulers())[lang] ?? fsrs;
  }

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

  /// Cards due now, oldest first. New cards are capped per day. With
  /// [lang], only that language's cards.
  Future<List<CardState>> dueCards({
    DateTime? now,
    int newLimit = 20,
    Lang? lang,
  }) async {
    now ??= DateTime.now().toUtc();
    final rows = await local.all(
      LocalDb.cardStates,
      filter: Filter.equals('deleted', false),
    );
    final cards = rows
        .map(CardState.fromJson)
        .where((c) => lang == null || c.cardId.startsWith('${lang.name}.'))
        .toList();
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

  /// Due cards per language (new cards not counted).
  Stream<Map<Lang, int>> watchDueByLang() => local
      .watchAll(LocalDb.cardStates, filter: Filter.equals('deleted', false))
      .map((rows) {
        final now = DateTime.now().toUtc();
        final out = {for (final l in Lang.values) l: 0};
        for (final c in rows.map(CardState.fromJson)) {
          if (c.due.isAfter(now)) continue;
          final lang = ContentId.parse(c.cardId)?.lang;
          if (lang != null) out[lang] = out[lang]! + 1;
        }
        return out;
      });

  Future<CardState> answer(
    CardState card,
    Rating rating, {
    int? durationMs,
    DateTime? now,
  }) async {
    final scheduler = await fsrsFor(card.cardId);
    final result = scheduler.review(
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
