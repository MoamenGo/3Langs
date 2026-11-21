// FSRS (Free Spaced Repetition Scheduler), version 4.5.
//
// A compact, dependency-free implementation of the algorithm described at
// https://github.com/open-spaced-repetition/fsrs4anki/wiki/The-Algorithm
// It decides when each flashcard is shown again so that the chance of still
// remembering it (retrievability) stays near `desiredRetention`.
//
// Memory model, per card:
//   stability S  - days until recall probability drops to 90 %
//   difficulty D - 1 (easy) to 10 (hard)
//   R(t, S) = (1 + FACTOR * t / S) ^ DECAY

import 'dart:math' as math;

import '../data/models/learner.dart';

class Fsrs {
  Fsrs({
    this.desiredRetention = 0.9,
    this.maximumIntervalDays = 36500,
    List<double>? weights,
  }) : w = weights ?? defaultWeights;

  /// Default FSRS-4.5 weights, fitted on a large public review dataset.
  /// Can be re-fitted later from the learner's own review_logs.
  static const defaultWeights = <double>[
    0.4872, 1.4003, 3.7145, 13.8206, 5.1618, 1.2298, 0.8975, 0.031, 1.6474, //
    0.1367, 1.0461, 2.1072, 0.0793, 0.3246, 1.587, 0.2272, 2.8755,
  ];

  static const double decay = -0.5;
  static const double factor = 19 / 81; // makes R(S, S) == 0.9

  /// Short re-show delays for cards in the learning and relearning phases.
  static const learningSteps = {
    Rating.again: Duration(minutes: 1),
    Rating.hard: Duration(minutes: 5),
  };
  static const relearningStep = Duration(minutes: 10);

  final double desiredRetention;
  final int maximumIntervalDays;
  final List<double> w;

  /// Probability of recalling a card [elapsedDays] after the last review.
  double retrievability(double elapsedDays, double stability) =>
      math.pow(1 + factor * elapsedDays / stability, decay).toDouble();

  /// Days until retrievability falls to [desiredRetention].
  int nextIntervalDays(double stability) {
    final days =
        stability /
        factor *
        (math.pow(desiredRetention, 1 / decay).toDouble() - 1);
    return days.round().clamp(1, maximumIntervalDays);
  }

  double _initStability(Rating r) => math.max(w[r.value - 1], 0.1);

  double _initDifficulty(Rating r) =>
      (w[4] - (r.value - 3) * w[5]).clamp(1.0, 10.0);

  double _nextDifficulty(double d, Rating r) {
    final next = d - w[6] * (r.value - 3);
    // Mean reversion towards the difficulty of an "easy" first answer.
    final reverted = w[7] * _initDifficulty(Rating.easy) + (1 - w[7]) * next;
    return reverted.clamp(1.0, 10.0);
  }

  double _recallStability(double d, double s, double r, Rating rating) {
    final hardPenalty = rating == Rating.hard ? w[15] : 1.0;
    final easyBonus = rating == Rating.easy ? w[16] : 1.0;
    return s *
        (1 +
            math.exp(w[8]) *
                (11 - d) *
                math.pow(s, -w[9]) *
                (math.exp(w[10] * (1 - r)) - 1) *
                hardPenalty *
                easyBonus);
  }

  double _forgetStability(double d, double s, double r) =>
      w[11] *
      math.pow(d, -w[12]) *
      (math.pow(s + 1, w[13]) - 1) *
      math.exp(w[14] * (1 - r));

  /// Applies one answer to [card] and returns the new state and its log entry.
  ({CardState card, ReviewLog log}) review(
    CardState card,
    Rating rating,
    DateTime now, {
    required String logId,
    int? durationMs,
  }) {
    now = now.toUtc();
    final elapsed = card.lastReview == null
        ? 0.0
        : now.difference(card.lastReview!).inSeconds / 86400.0;

    double s = card.stability, d = card.difficulty;
    CardPhase phase;
    DateTime due;
    var lapses = card.lapses;

    switch (card.phase) {
      case CardPhase.newCard:
        s = _initStability(rating);
        d = _initDifficulty(rating);
        if (rating == Rating.again || rating == Rating.hard) {
          phase = CardPhase.learning;
          due = now.add(learningSteps[rating]!);
        } else {
          phase = CardPhase.review;
          due = now.add(Duration(days: _intervalFor(s, rating, null)));
        }
      case CardPhase.learning:
      case CardPhase.relearning:
        d = _nextDifficulty(d, rating);
        if (rating == Rating.again || rating == Rating.hard) {
          phase = card.phase;
          due = now.add(
            card.phase == CardPhase.learning
                ? learningSteps[rating]!
                : relearningStep,
          );
        } else {
          phase = CardPhase.review;
          due = now.add(Duration(days: _intervalFor(s, rating, null)));
        }
      case CardPhase.review:
        final r = retrievability(elapsed, s);
        d = _nextDifficulty(card.difficulty, rating);
        if (rating == Rating.again) {
          lapses += 1;
          s = math.min(_forgetStability(card.difficulty, s, r), s);
          phase = CardPhase.relearning;
          due = now.add(relearningStep);
        } else {
          s = _recallStability(card.difficulty, s, r, rating);
          phase = CardPhase.review;
          due = now.add(Duration(days: _intervalFor(s, rating, card)));
        }
    }

    final next = card.copyWith(
      stability: s,
      difficulty: d,
      reps: card.reps + 1,
      lapses: lapses,
      phase: phase,
      due: due,
      lastReview: now,
      updatedAt: now,
    );
    final log = ReviewLog(
      id: logId,
      cardId: card.cardId,
      rating: rating,
      phaseBefore: card.phase,
      elapsedDays: elapsed,
      scheduledDays: due.difference(now).inSeconds / 86400.0,
      reviewedAt: now,
      durationMs: durationMs,
    );
    return (card: next, log: log);
  }

  /// Interval in days, keeping hard < good < easy for review cards.
  int _intervalFor(double s, Rating rating, CardState? before) {
    var days = nextIntervalDays(s);
    if (before != null && before.lastReview != null) {
      if (rating == Rating.good || rating == Rating.easy) {
        final elapsed =
            before.due.difference(before.lastReview!).inHours / 24.0;
        days = math.max(days, elapsed.ceil() + (rating == Rating.easy ? 2 : 1));
      }
    }
    return days.clamp(1, maximumIntervalDays);
  }

  /// What each button would do right now, for showing "1m / 5m / 4d / 15d".
  Map<Rating, Duration> preview(CardState card, DateTime now) => {
    for (final r in Rating.values)
      r: review(
        card,
        r,
        now,
        logId: 'preview',
      ).card.due.difference(now.toUtc()),
  };
}
