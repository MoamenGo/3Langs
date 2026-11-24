import 'package:uuid/uuid.dart';

import '../../core/lang/lang.dart';
import '../local/local_db.dart';

enum AssessmentKind { placement, exam }

/// A placement test or end-of-level exam result.
class LevelAssessment {
  const LevelAssessment({
    required this.id,
    required this.lang,
    required this.level,
    required this.kind,
    required this.score,
    required this.passed,
    required this.takenAt,
  });

  final String id;
  final Lang lang;
  final String level;
  final AssessmentKind kind;
  final double score;
  final bool passed;
  final DateTime takenAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'lang': lang.name,
    'level': level,
    'kind': kind.name,
    'score': score,
    'passed': passed,
    'taken_at': takenAt.toIso8601String(),
    'updated_at': takenAt.toIso8601String(),
  };

  factory LevelAssessment.fromJson(Map<String, dynamic> j) => LevelAssessment(
    id: j['id'] as String,
    lang: Lang.tryParse(j['lang'] as String?) ?? Lang.de,
    level: j['level'] as String,
    kind: AssessmentKind.values.byName(j['kind'] as String? ?? 'exam'),
    score: (j['score'] as num).toDouble(),
    passed: j['passed'] as bool? ?? false,
    takenAt: DateTime.parse(j['taken_at'] as String).toUtc(),
  );
}

class AssessmentRepository {
  AssessmentRepository(this.local);
  final LocalDb local;
  static const _uuid = Uuid();

  Future<LevelAssessment> record({
    required Lang lang,
    required String level,
    required AssessmentKind kind,
    required double score,
    required bool passed,
  }) async {
    final a = LevelAssessment(
      id: _uuid.v4(),
      lang: lang,
      level: level,
      kind: kind,
      score: score,
      passed: passed,
      takenAt: DateTime.now().toUtc(),
    );
    await local.putLocal(LocalDb.levelAssessments, a.id, a.toJson());
    return a;
  }

  Stream<List<LevelAssessment>> watch() => local
      .watchAll(LocalDb.levelAssessments)
      .map(
        (rows) =>
            rows.map((r) => LevelAssessment.fromJson(Map.of(r))).toList()
              ..sort((a, b) => b.takenAt.compareTo(a.takenAt)),
      );
}
