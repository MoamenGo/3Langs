import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../local/local_db.dart';
import '../models/learner.dart';

/// Lesson completion, study time and streaks.
class ProgressRepository {
  ProgressRepository(this.local);
  final LocalDb local;
  static const _uuid = Uuid();
  static final _day = DateFormat('yyyy-MM-dd');

  static String localDay(DateTime t) => _day.format(t.toLocal());

  Stream<Map<String, LessonProgress>> watchLessons() => local
      .watchAll(LocalDb.lessonProgress)
      .map(
        (rows) => {
          for (final r in rows.map(LessonProgress.fromJson)) r.lessonId: r,
        },
      );

  Future<void> completeLesson(String lessonId, double score) async {
    final now = DateTime.now().toUtc();
    final row = await local.get(LocalDb.lessonProgress, lessonId);
    final old = row == null ? null : LessonProgress.fromJson(row);
    final best = old?.bestScore == null || score > old!.bestScore!
        ? score
        : old.bestScore;
    final p = LessonProgress(
      lessonId: lessonId,
      status: LessonStatus.completed,
      bestScore: best,
      attempts: (old?.attempts ?? 0) + 1,
      completedAt: now,
      updatedAt: now,
    );
    await local.putLocal(LocalDb.lessonProgress, lessonId, p.toJson());
  }

  Future<void> logSession(
    Activity activity,
    DateTime startedAt, {
    int itemsDone = 0,
  }) async {
    final seconds = DateTime.now().difference(startedAt).inSeconds;
    if (seconds < 10) return; // ignore accidental taps
    final s = StudySession(
      id: _uuid.v4(),
      activity: activity,
      startedAt: startedAt.toUtc(),
      durationS: seconds,
      itemsDone: itemsDone,
      localDay: localDay(startedAt),
    );
    await local.putLocal(LocalDb.studySessions, s.id, s.toJson());
  }

  Stream<StudyStats> watchStats() => local
      .watchAll(LocalDb.studySessions)
      .map((rows) => StudyStats.from(rows.map(StudySession.fromJson).toList()));
}

class StudyStats {
  const StudyStats({
    required this.minutesToday,
    required this.totalHours,
    required this.streakDays,
    required this.minutesByDay,
  });

  final int minutesToday;
  final double totalHours;
  final int streakDays;

  /// Minutes studied per local day (yyyy-MM-dd).
  final Map<String, int> minutesByDay;

  factory StudyStats.from(List<StudySession> sessions, {DateTime? now}) {
    now ??= DateTime.now();
    final byDay = <String, int>{};
    var total = 0;
    for (final s in sessions) {
      byDay[s.localDay] = (byDay[s.localDay] ?? 0) + s.durationS;
      total += s.durationS;
    }
    final today = ProgressRepository.localDay(now);
    // A streak survives until the end of today even if today is still empty.
    var streak = 0;
    var day = DateTime(now.year, now.month, now.day);
    if (!byDay.containsKey(today)) day = day.subtract(const Duration(days: 1));
    while (byDay.containsKey(ProgressRepository.localDay(day))) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return StudyStats(
      minutesToday: (byDay[today] ?? 0) ~/ 60,
      totalHours: total / 3600,
      streakDays: streak,
      minutesByDay: byDay.map((k, v) => MapEntry(k, v ~/ 60)),
    );
  }
}
