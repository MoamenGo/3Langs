// Plans one study day across the three languages. Pure Dart: no Flutter, no
// storage, so the rules are easy to test (test/session_planner_test.dart).
//
// The rules, from the three-language design:
// * Every study day, two languages get a new lesson and the third gets a
//   skill block (listening, reading, speaking or writing). Over six study days
//   each language gets four new lessons. Sunday is reviews only.
// * German and Dutch are close, so new lessons in those two never come back
//   to back: Spanish, a review or a skill block goes between them.
// * Reviews come first. When a language has more than two days of reviews
//   waiting, its new cards are cut in half until it catches up.
// * Three or more mix-ups between languages in the last 7 days add a
//   contrast drill.
// * The blocks are scaled to fit the minutes you have today.

import '../../core/lang/lang.dart';

enum BlockKind { review, newLesson, skill, contrast }

enum SkillKind { listening, reading, speaking, writing }

class SessionBlock {
  const SessionBlock({
    required this.kind,
    required this.minutes,
    this.lang,
    this.lessonId,
    this.skill,
  });

  final BlockKind kind;

  /// Null for the contrast block, which mixes languages.
  final Lang? lang;
  final int minutes;

  /// For new lessons: the lesson to study.
  final String? lessonId;

  /// For skill blocks.
  final SkillKind? skill;

  /// Stable id within a day, used to remember which blocks are done.
  String get id => switch (kind) {
    BlockKind.review => 'review-${lang!.name}',
    BlockKind.newLesson => 'lesson-${lang!.name}',
    BlockKind.skill => 'skill-${lang!.name}-${skill!.name}',
    BlockKind.contrast => 'contrast',
  };

  SessionBlock withMinutes(int m) => SessionBlock(
    kind: kind,
    minutes: m,
    lang: lang,
    lessonId: lessonId,
    skill: skill,
  );

  @override
  String toString() => '$id(${minutes}m)';
}

/// What the planner needs to know about one language today.
class LangDay {
  const LangDay({
    required this.lang,
    required this.active,
    this.share = 1 / 3,
    this.dueCards = 0,
    this.newCardsPerDay = 10,
    this.nextLessonId,
    this.lessonsDone = 0,
  });

  final Lang lang;

  /// Started and not paused.
  final bool active;

  /// Share of the daily minutes (from the language track).
  final double share;
  final int dueCards;
  final int newCardsPerDay;

  /// The next lesson in this language, or null when there is none (level
  /// finished and waiting for its exam, or no content).
  final String? nextLessonId;

  /// Lessons completed in this language so far, to spot a language that
  /// falls behind its share.
  final int lessonsDone;
}

class SessionPlan {
  const SessionPlan({
    required this.day,
    required this.blocks,
    required this.newCardLimit,
  });

  final DateTime day;
  final List<SessionBlock> blocks;

  /// New flashcards allowed today, per language.
  final Map<Lang, int> newCardLimit;

  int get totalMinutes => blocks.fold(0, (sum, b) => sum + b.minutes);
}

class SessionPlanner {
  const SessionPlanner();

  /// Which two languages get new lessons on each weekday (Monday = 1).
  /// The third language gets a skill block. Sunday (7) is reviews only.
  static const rotation = <int, List<Lang>>{
    DateTime.monday: [Lang.de, Lang.nl],
    DateTime.tuesday: [Lang.de, Lang.es],
    DateTime.wednesday: [Lang.es, Lang.nl],
    DateTime.thursday: [Lang.nl, Lang.de],
    DateTime.friday: [Lang.es, Lang.de],
    DateTime.saturday: [Lang.nl, Lang.es],
  };

  /// Skills rotate through the week so each one comes up for each language.
  static SkillKind skillFor(Lang lang, DateTime day) {
    final n = SkillKind.values.length;
    return SkillKind.values[(day.weekday + lang.index) % n];
  }

  static const lessonMinutes = 20;
  static const skillMinutes = 15;
  static const contrastMinutes = 10;

  /// Rough time per due card, in seconds.
  static const secondsPerCard = 12;

  /// A backlog is more than this many days of reviews.
  static const backlogDays = 2;

  /// Mix-ups in the last 7 days that add a contrast drill.
  static const contrastThreshold = 3;

  SessionPlan plan({
    required DateTime day,
    required int minutes,
    required List<LangDay> langs,
    int interferenceThisWeek = 0,
  }) {
    final active = [
      for (final l in langs)
        if (l.active) l,
    ];
    final byLang = {for (final l in active) l.lang: l};

    // New card limits: halved for a language with a review backlog.
    final newLimit = <Lang, int>{};
    for (final l in active) {
      final perDay = l.newCardsPerDay * 3; // reviews a day settles at ~3x new
      final backlog = l.dueCards > backlogDays * (perDay < 20 ? 20 : perDay);
      newLimit[l.lang] = backlog ? l.newCardsPerDay ~/ 2 : l.newCardsPerDay;
    }

    // 1. Reviews first, biggest pile first.
    final reviews = [
      for (final l in [...active]..sort((a, b) => b.dueCards - a.dueCards))
        if (l.dueCards > 0)
          SessionBlock(
            kind: BlockKind.review,
            lang: l.lang,
            minutes: _reviewMinutes(l.dueCards),
          ),
    ];

    // 2. New lessons: today's rotation, limited to active languages that
    // have a next lesson. A language left out (paused, nothing to study)
    // gives its slot to the active language that is furthest behind.
    final newLangs = <Lang>[];
    if (day.weekday != DateTime.sunday) {
      for (final lang in rotation[day.weekday]!) {
        final l = byLang[lang];
        if (l != null && l.nextLessonId != null) newLangs.add(lang);
      }
      final wanted = active.length >= 2 ? 2 : active.length;
      final spare = [
        for (final l in active)
          if (!newLangs.contains(l.lang) && l.nextLessonId != null) l,
      ]..sort((a, b) => _behind(b, active).compareTo(_behind(a, active)));
      for (final l in spare) {
        if (newLangs.length >= wanted) break;
        newLangs.add(l.lang);
      }
    }
    final lessons = [
      for (final lang in newLangs)
        SessionBlock(
          kind: BlockKind.newLesson,
          lang: lang,
          minutes: lessonMinutes,
          lessonId: byLang[lang]!.nextLessonId,
        ),
    ];

    // 3. Skill blocks for the active languages without a new lesson.
    final skills = [
      if (day.weekday != DateTime.sunday)
        for (final l in active)
          if (!newLangs.contains(l.lang))
            SessionBlock(
              kind: BlockKind.skill,
              lang: l.lang,
              minutes: skillMinutes,
              skill: skillFor(l.lang, day),
            ),
    ];

    final contrast = [
      if (interferenceThisWeek >= contrastThreshold && active.length >= 2)
        const SessionBlock(kind: BlockKind.contrast, minutes: contrastMinutes),
    ];

    final ordered = _separateSimilar([
      ...reviews,
      ..._interleave(lessons, skills),
      ...contrast,
    ]);
    return SessionPlan(
      day: DateTime(day.year, day.month, day.day),
      blocks: _fit(ordered, minutes),
      newCardLimit: newLimit,
    );
  }

  static int _reviewMinutes(int due) {
    final m = (due * secondsPerCard / 60).ceil();
    return m < 5 ? 5 : (m > 40 ? 40 : m);
  }

  /// How far a language is behind its share of lessons (bigger = further).
  static double _behind(LangDay l, List<LangDay> all) {
    final total = all.fold<int>(0, (s, x) => s + x.lessonsDone);
    final shares = all.fold<double>(0, (s, x) => s + x.share);
    if (total == 0 || shares == 0) return l.share;
    return l.share / shares - l.lessonsDone / total;
  }

  /// lesson, skill, lesson, skill...: keeps new material spread out.
  static List<SessionBlock> _interleave(
    List<SessionBlock> lessons,
    List<SessionBlock> skills,
  ) {
    final out = <SessionBlock>[];
    for (var i = 0; i < lessons.length || i < skills.length; i++) {
      if (i < lessons.length) out.add(lessons[i]);
      if (i < skills.length) out.add(skills[i]);
    }
    return out;
  }

  /// No two new lessons in similar languages (German, Dutch) back to back.
  /// Moves a block from later in the list between them.
  static List<SessionBlock> _separateSimilar(List<SessionBlock> blocks) {
    final out = [...blocks];
    for (var i = 1; i < out.length; i++) {
      if (!_clash(out[i - 1], out[i])) continue;
      final j = out.indexWhere(
        (b) =>
            !_clash(out[i - 1], b) &&
            (i + 1 >= out.length || !_clash(b, out[i])),
        i + 1,
      );
      if (j > i) {
        out.insert(i, out.removeAt(j));
      } else {
        // Nothing to put between them: move the second lesson to the end.
        out.add(out.removeAt(i));
        if (_clash(out[out.length - 2], out.last)) break;
      }
    }
    return out;
  }

  static bool _clash(SessionBlock a, SessionBlock b) =>
      a.kind == BlockKind.newLesson &&
      b.kind == BlockKind.newLesson &&
      Lang.areSimilar(a.lang!, b.lang!);

  /// Scales the blocks to the minutes available. Reviews and new lessons are
  /// kept; skill and contrast blocks shrink (to 5 minutes) or drop first.
  static List<SessionBlock> _fit(List<SessionBlock> blocks, int minutes) {
    var total = blocks.fold<int>(0, (s, b) => s + b.minutes);
    if (total <= minutes) {
      // Spare time goes to skill blocks (more practice in every skill).
      final skills = blocks.where((b) => b.kind == BlockKind.skill).length;
      if (skills == 0 || minutes - total < skills) return blocks;
      final extra = (minutes - total) ~/ skills;
      return [
        for (final b in blocks)
          b.kind == BlockKind.skill
              ? b.withMinutes(b.minutes + (extra > 30 ? 30 : extra))
              : b,
      ];
    }
    final out = [...blocks];
    // Shrink optional blocks, then drop them from the end.
    for (var i = 0; i < out.length && total > minutes; i++) {
      final b = out[i];
      if (b.kind == BlockKind.skill || b.kind == BlockKind.contrast) {
        total -= b.minutes - 5;
        out[i] = b.withMinutes(5);
      }
    }
    for (var i = out.length - 1; i >= 0 && total > minutes; i--) {
      final b = out[i];
      if (b.kind == BlockKind.skill || b.kind == BlockKind.contrast) {
        total -= b.minutes;
        out.removeAt(i);
      }
    }
    // Still too long: keep at most one new lesson per language pair.
    for (var i = out.length - 1; i >= 0 && total > minutes; i--) {
      if (out[i].kind == BlockKind.newLesson &&
          out.where((b) => b.kind == BlockKind.newLesson).length > 1) {
        total -= out[i].minutes;
        out.removeAt(i);
      }
    }
    return out;
  }
}
