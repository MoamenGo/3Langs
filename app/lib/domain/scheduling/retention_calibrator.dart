// Per-language spaced repetition. Each language has its own difficulty for
// you (Dutch may be easy after German, Spanish verbs harder), so once a
// language has enough reviews, its target retention is nudged until the
// recall you actually show matches the target. Intervals in that language
// then stretch or shrink accordingly.

import '../../core/lang/lang.dart';
import '../../data/models/learner.dart';

/// One review of a card that had already been learned.
typedef ReviewOutcome = ({String cardId, CardPhase before, Rating rating});

class RetentionCalibrator {
  const RetentionCalibrator({
    this.minReviews = 50,
    this.lowest = 0.8,
    this.highest = 0.95,
  });

  /// Reviews needed in a language before its retention is personalised.
  final int minReviews;
  final double lowest;
  final double highest;

  /// Target retention per language. A language without enough reviews keeps
  /// [base].
  Map<Lang, double> calibrate(List<ReviewOutcome> reviews, double base) {
    final out = <Lang, double>{};
    for (final lang in Lang.values) {
      final mine = reviews.where(
        (r) =>
            r.cardId.startsWith('${lang.name}.') &&
            r.before == CardPhase.review,
      );
      final n = mine.length;
      if (n < minReviews) {
        out[lang] = base;
        continue;
      }
      final recalled = mine.where((r) => r.rating != Rating.again).length;
      final observed = recalled / n;
      // Forgetting more than planned -> aim higher (shorter intervals), and
      // the other way round. Half of the gap, so it settles gently.
      final target = base + (base - observed) * 0.5;
      out[lang] = target.clamp(lowest, highest).toDouble();
    }
    return out;
  }
}
