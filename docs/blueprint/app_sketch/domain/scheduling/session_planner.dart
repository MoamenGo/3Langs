// Blueprint sketch of the daily planner. Pure Dart, unit-tested.
import '../../core/lang/lang.dart';
import '../learner/language_track.dart';

enum BlockKind { review, newLesson, contrast, skill }

class SessionBlock {
  const SessionBlock(this.kind, this.minutes, {this.lang, this.itemIds = const []});
  final BlockKind kind;
  final int minutes;
  final Lang? lang;           // null = mixed (contrast block)
  final List<String> itemIds;
}

class SessionPlan {
  const SessionPlan(this.date, this.blocks);
  final DateTime date;
  final List<SessionBlock> blocks;
}

abstract class SessionPlanner {
  /// Rules (see design doc, section "الجلسة اليومية"):
  /// 1. review first, grouped in chunks of one language;
  /// 2. two languages get new lessons, the third gets a skill block, rotating;
  /// 3. never two new blocks of a high-similarity pair (de-nl) next to each other;
  /// 4. a contrast block when >= 3 interference events this week;
  /// 5. less new material in a language whose review backlog is > 2 days.
  SessionPlan planDay({
    required DateTime date,
    required int availableMinutes,
    required List<LanguageTrack> tracks,
    required Map<Lang, int> dueCards,
    required int interferenceEventsThisWeek,
  });
}
