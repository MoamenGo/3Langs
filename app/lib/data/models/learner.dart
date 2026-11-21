// Learner data: personal, synced between devices through Supabase.
// Field names in toJson() match the Supabase columns in
// supabase/migrations/20261121000000_init.sql, so a record can be pushed as is.

import 'content.dart';

/// FSRS card states. Values match the `state` smallint in the database.
enum CardPhase { newCard, learning, review, relearning }

/// The four answer buttons. Values match `rating` in review_logs.
enum Rating {
  again(1),
  hard(2),
  good(3),
  easy(4);

  const Rating(this.value);
  final int value;
}

DateTime _date(Object? v) => DateTime.parse(v as String).toUtc();
DateTime? _dateOrNull(Object? v) => v == null ? null : _date(v);

class CardState {
  const CardState({
    required this.cardId,
    required this.due,
    required this.updatedAt,
    this.stability = 0,
    this.difficulty = 0,
    this.reps = 0,
    this.lapses = 0,
    this.phase = CardPhase.newCard,
    this.lastReview,
    this.deleted = false,
  });

  final String cardId;
  final double stability;
  final double difficulty;
  final int reps;
  final int lapses;
  final CardPhase phase;
  final DateTime due;
  final DateTime? lastReview;
  final bool deleted;
  final DateTime updatedAt;

  factory CardState.fresh(String cardId, DateTime now) =>
      CardState(cardId: cardId, due: now, updatedAt: now);

  CardState copyWith({
    double? stability,
    double? difficulty,
    int? reps,
    int? lapses,
    CardPhase? phase,
    DateTime? due,
    DateTime? lastReview,
    DateTime? updatedAt,
  }) => CardState(
    cardId: cardId,
    stability: stability ?? this.stability,
    difficulty: difficulty ?? this.difficulty,
    reps: reps ?? this.reps,
    lapses: lapses ?? this.lapses,
    phase: phase ?? this.phase,
    due: due ?? this.due,
    lastReview: lastReview ?? this.lastReview,
    deleted: deleted,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Map<String, dynamic> toJson() => {
    'card_id': cardId,
    'stability': stability,
    'difficulty': difficulty,
    'reps': reps,
    'lapses': lapses,
    'state': phase.index,
    'due': due.toIso8601String(),
    'last_review': lastReview?.toIso8601String(),
    'deleted': deleted,
    'updated_at': updatedAt.toIso8601String(),
  };

  factory CardState.fromJson(Map<String, dynamic> j) => CardState(
    cardId: j['card_id'] as String,
    stability: (j['stability'] as num).toDouble(),
    difficulty: (j['difficulty'] as num).toDouble(),
    reps: j['reps'] as int,
    lapses: j['lapses'] as int,
    phase: CardPhase.values[j['state'] as int],
    due: _date(j['due']),
    lastReview: _dateOrNull(j['last_review']),
    deleted: j['deleted'] as bool? ?? false,
    updatedAt: _date(j['updated_at']),
  );
}

class ReviewLog {
  const ReviewLog({
    required this.id,
    required this.cardId,
    required this.rating,
    required this.phaseBefore,
    required this.elapsedDays,
    required this.scheduledDays,
    required this.reviewedAt,
    this.durationMs,
  });

  final String id;
  final String cardId;
  final Rating rating;
  final CardPhase phaseBefore;
  final double elapsedDays;
  final double scheduledDays;
  final DateTime reviewedAt;
  final int? durationMs;

  Map<String, dynamic> toJson() => {
    'id': id,
    'card_id': cardId,
    'rating': rating.value,
    'state_before': phaseBefore.index,
    'elapsed_days': elapsedDays,
    'scheduled_days': scheduledDays,
    'reviewed_at': reviewedAt.toIso8601String(),
    'duration_ms': durationMs,
    'updated_at': reviewedAt.toIso8601String(),
  };
}

enum LessonStatus { notStarted, inProgress, completed }

class LessonProgress {
  const LessonProgress({
    required this.lessonId,
    required this.status,
    required this.updatedAt,
    this.bestScore,
    this.attempts = 0,
    this.completedAt,
  });

  final String lessonId;
  final LessonStatus status;
  final double? bestScore;
  final int attempts;
  final DateTime? completedAt;
  final DateTime updatedAt;

  static const _statusNames = {
    LessonStatus.notStarted: 'not_started',
    LessonStatus.inProgress: 'in_progress',
    LessonStatus.completed: 'completed',
  };

  Map<String, dynamic> toJson() => {
    'lesson_id': lessonId,
    'status': _statusNames[status],
    'best_score': bestScore,
    'attempts': attempts,
    'completed_at': completedAt?.toIso8601String(),
    'deleted': false,
    'updated_at': updatedAt.toIso8601String(),
  };

  factory LessonProgress.fromJson(Map<String, dynamic> j) => LessonProgress(
    lessonId: j['lesson_id'] as String,
    status: _statusNames.entries
        .firstWhere(
          (e) => e.value == j['status'],
          orElse: () => _statusNames.entries.first,
        )
        .key,
    bestScore: (j['best_score'] as num?)?.toDouble(),
    attempts: j['attempts'] as int? ?? 0,
    completedAt: _dateOrNull(j['completed_at']),
    updatedAt: _date(j['updated_at']),
  );
}

enum Activity { lesson, review, listening, reading, writing, speaking, exam }

class StudySession {
  const StudySession({
    required this.id,
    required this.activity,
    required this.startedAt,
    required this.durationS,
    required this.localDay,
    this.itemsDone = 0,
  });

  final String id;
  final Activity activity;
  final DateTime startedAt;
  final int durationS;
  final int itemsDone;

  /// The learner's own calendar day (yyyy-MM-dd), used for streaks.
  final String localDay;

  Map<String, dynamic> toJson() => {
    'id': id,
    'activity': activity.name,
    'started_at': startedAt.toIso8601String(),
    'duration_s': durationS,
    'items_done': itemsDone,
    'local_day': localDay,
    'updated_at': startedAt.add(Duration(seconds: durationS)).toIso8601String(),
  };

  factory StudySession.fromJson(Map<String, dynamic> j) => StudySession(
    id: j['id'] as String,
    activity: Activity.values.byName(j['activity'] as String),
    startedAt: _date(j['started_at']),
    durationS: j['duration_s'] as int,
    itemsDone: j['items_done'] as int? ?? 0,
    localDay: j['local_day'] as String,
  );
}

class UserSettings {
  const UserSettings({
    required this.updatedAt,
    this.uiLanguage = 'en',
    this.explanationLanguage = ExplainLang.en,
    this.dailyGoalMinutes = 120,
    this.newCardsPerDay = 20,
    this.desiredRetention = 0.9,
    this.currentLevel = 'A1',
  });

  /// App interface language: en, nl or es.
  final String uiLanguage;

  /// Language used for translations and grammar explanations.
  final ExplainLang explanationLanguage;
  final int dailyGoalMinutes;
  final int newCardsPerDay;
  final double desiredRetention;
  final String currentLevel;
  final DateTime updatedAt;

  UserSettings copyWith({
    String? uiLanguage,
    ExplainLang? explanationLanguage,
    int? dailyGoalMinutes,
    int? newCardsPerDay,
    double? desiredRetention,
    String? currentLevel,
  }) => UserSettings(
    uiLanguage: uiLanguage ?? this.uiLanguage,
    explanationLanguage: explanationLanguage ?? this.explanationLanguage,
    dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
    newCardsPerDay: newCardsPerDay ?? this.newCardsPerDay,
    desiredRetention: desiredRetention ?? this.desiredRetention,
    currentLevel: currentLevel ?? this.currentLevel,
    updatedAt: DateTime.now().toUtc(),
  );

  Map<String, dynamic> toJson() => {
    'ui_language': uiLanguage,
    'explanation_language': explanationLanguage.name,
    'daily_goal_minutes': dailyGoalMinutes,
    'new_cards_per_day': newCardsPerDay,
    'desired_retention': desiredRetention,
    'current_level': currentLevel,
    'updated_at': updatedAt.toIso8601String(),
  };

  factory UserSettings.fromJson(Map<String, dynamic> j) => UserSettings(
    uiLanguage: j['ui_language'] as String? ?? 'en',
    explanationLanguage: ExplainLang.values.byName(
      j['explanation_language'] as String? ?? 'en',
    ),
    dailyGoalMinutes: j['daily_goal_minutes'] as int? ?? 120,
    newCardsPerDay: j['new_cards_per_day'] as int? ?? 20,
    desiredRetention: (j['desired_retention'] as num?)?.toDouble() ?? 0.9,
    currentLevel: j['current_level'] as String? ?? 'A1',
    updatedAt: j['updated_at'] == null
        ? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)
        : _date(j['updated_at']),
  );
}
