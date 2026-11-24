// Blueprint sketch: one row per language in language_tracks.
import '../../core/lang/lang.dart';
import '../curriculum/curriculum.dart';

enum TrackStatus { scheduled, active, paused }

class LanguageTrack {
  const LanguageTrack({
    required this.lang,
    required this.status,
    required this.level,
    required this.currentUnitId,
    required this.timeShare,
    required this.newCardsPerDay,
    this.startDate,
  });
  final Lang lang;
  final TrackStatus status;
  final Cefr level;
  final String currentUnitId;
  final double timeShare;     // fraction of daily minutes
  final int newCardsPerDay;
  final DateTime? startDate;
}
