// Blueprint sketch: spot answers that are right, but in the wrong language.
import '../../core/lang/lang.dart';

class InterferenceHit {
  const InterferenceHit(this.expected, this.intruder, this.answer, {this.contrastId});
  final Lang expected;
  final Lang intruder;
  final String answer;
  final String? contrastId;
}

abstract class InterferenceDetector {
  /// Looks the wrong answer up in the other two languages' lexicons
  /// (normalised: lowercase, no articles, no accents). Returns a hit when it
  /// matches a word you have studied there; null for ordinary mistakes.
  InterferenceHit? check({required Lang expected, required String itemId, required String answer});
}
