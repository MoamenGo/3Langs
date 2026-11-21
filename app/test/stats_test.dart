import 'package:flutter_test/flutter_test.dart';
import 'package:three_lang/data/models/learner.dart';
import 'package:three_lang/data/repositories/progress_repository.dart';

StudySession s(DateTime day, int minutes) => StudySession(
  id: '$day',
  activity: Activity.lesson,
  startedAt: day.toUtc(),
  durationS: minutes * 60,
  localDay: ProgressRepository.localDay(day),
);

void main() {
  final now = DateTime(2026, 11, 21, 20);

  test('streak counts consecutive days ending today', () {
    final stats = StudyStats.from([
      s(now, 30),
      s(now.subtract(const Duration(days: 1)), 60),
      s(now.subtract(const Duration(days: 2)), 10),
      s(now.subtract(const Duration(days: 4)), 10),
    ], now: now);
    expect(stats.streakDays, 3);
    expect(stats.minutesToday, 30);
  });

  test('streak is kept until the end of today', () {
    final stats = StudyStats.from([
      s(now.subtract(const Duration(days: 1)), 60),
      s(now.subtract(const Duration(days: 2)), 60),
    ], now: now);
    expect(stats.streakDays, 2);
    expect(stats.minutesToday, 0);
    expect(stats.totalHours, 2);
  });
}
