import 'package:flutter_test/flutter_test.dart';
import 'package:three_lang/core/lang/lang.dart';
import 'package:three_lang/domain/scheduling/session_planner.dart';

LangDay day(Lang l, {int due = 0, bool active = true, String? next = 'x'}) =>
    LangDay(
      lang: l,
      active: active,
      dueCards: due,
      nextLessonId: next == null ? null : '${l.name}.a1.u01.l01',
    );

void main() {
  const planner = SessionPlanner();
  final all = [day(Lang.de, due: 30), day(Lang.es, due: 10), day(Lang.nl)];

  test('two new lessons and one skill block on a study day', () {
    for (var d = 23; d <= 28; d++) {
      // 2026-11-23 is a Monday.
      final plan = planner.plan(
        day: DateTime(2026, 11, d),
        minutes: 120,
        langs: all,
      );
      final lessons = plan.blocks.where((b) => b.kind == BlockKind.newLesson);
      final skills = plan.blocks.where((b) => b.kind == BlockKind.skill);
      expect(lessons.length, 2, reason: 'day $d');
      expect(skills.length, 1, reason: 'day $d');
      expect({
        ...lessons.map((b) => b.lang),
        ...skills.map((b) => b.lang),
      }, Lang.values.toSet());
    }
  });

  test('each language gets four new lessons a week', () {
    final count = {for (final l in Lang.values) l: 0};
    for (var d = 23; d <= 29; d++) {
      final plan = planner.plan(
        day: DateTime(2026, 11, d),
        minutes: 120,
        langs: all,
      );
      for (final b in plan.blocks.where((b) => b.kind == BlockKind.newLesson)) {
        count[b.lang!] = count[b.lang!]! + 1;
      }
    }
    expect(count, {Lang.de: 4, Lang.es: 4, Lang.nl: 4});
  });

  test('German and Dutch new lessons are never back to back', () {
    for (var d = 23; d <= 28; d++) {
      final blocks = planner
          .plan(day: DateTime(2026, 11, d), minutes: 240, langs: all)
          .blocks;
      for (var i = 1; i < blocks.length; i++) {
        final a = blocks[i - 1], b = blocks[i];
        final clash =
            a.kind == BlockKind.newLesson &&
            b.kind == BlockKind.newLesson &&
            Lang.areSimilar(a.lang!, b.lang!);
        expect(clash, isFalse, reason: 'day $d: $blocks');
      }
    }
  });

  test('reviews come first and Sunday is reviews only', () {
    final plan = planner.plan(
      day: DateTime(2026, 11, 29),
      minutes: 120,
      langs: all,
    );
    expect(plan.blocks.every((b) => b.kind == BlockKind.review), isTrue);
    expect(plan.blocks.first.lang, Lang.de); // biggest pile first
  });

  test('a review backlog halves new cards', () {
    final plan = planner.plan(
      day: DateTime(2026, 11, 23),
      minutes: 120,
      langs: [day(Lang.de, due: 500), day(Lang.es), day(Lang.nl)],
    );
    expect(plan.newCardLimit[Lang.de], 5);
    expect(plan.newCardLimit[Lang.es], 10);
  });

  test('mix-ups add a contrast drill', () {
    final plan = planner.plan(
      day: DateTime(2026, 11, 23),
      minutes: 180,
      langs: all,
      interferenceThisWeek: 3,
    );
    expect(plan.blocks.any((b) => b.kind == BlockKind.contrast), isTrue);
  });

  test('a paused language gives its slot to another', () {
    final plan = planner.plan(
      day: DateTime(2026, 11, 23), // Monday: de + nl
      minutes: 120,
      langs: [day(Lang.de), day(Lang.es), day(Lang.nl, active: false)],
    );
    final lessons = plan.blocks
        .where((b) => b.kind == BlockKind.newLesson)
        .map((b) => b.lang)
        .toSet();
    expect(lessons, {Lang.de, Lang.es});
  });

  test('short days keep reviews and drop extras', () {
    final plan = planner.plan(
      day: DateTime(2026, 11, 23),
      minutes: 30,
      langs: all,
    );
    expect(plan.blocks.where((b) => b.kind == BlockKind.review).length, 2);
    expect(plan.blocks.any((b) => b.kind == BlockKind.skill), isFalse);
  });
}
