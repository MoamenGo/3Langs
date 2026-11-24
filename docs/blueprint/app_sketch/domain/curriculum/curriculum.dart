// Blueprint sketch of the content model (read-only, from JSON packs).
import '../../core/lang/lang.dart';

enum Cefr { a0, a1, a2, b1, b2, c1 }
enum ConceptKind { sense, function, grammar, theme }
enum LessonType { vocab, grammar, listening, reading, speaking, writing, contrast, review, exam }
enum ContrastType { falseFriend, nearCognate, genderMismatch, spellingShift, grammarDivergence }

typedef Explain = Map<ExplainLang, String>;

/// Written once, shared by all languages. id: c.a1.home.house
class Concept {
  const Concept(this.id, this.level, this.kind, this.gloss, {this.prerequisites = const []});
  final String id;
  final Cefr level;
  final ConceptKind kind;
  final Explain gloss;
  final List<String> prerequisites;
}

/// A unit of the shared syllabus. id: u.a1.03
class SharedUnit {
  const SharedUnit(this.id, this.level, this.order, this.theme, this.conceptIds);
  final String id;
  final Cefr level;
  final int order;
  final Explain theme;
  final List<String> conceptIds;
}

/// The same unit in one language. id: de.u.a1.03
class LangUnit {
  const LangUnit(this.id, this.lang, this.sharedUnitId, this.lessonIds);
  final String id;
  final Lang lang;
  final String sharedUnitId;
  final List<String> lessonIds;
}

/// A word in one language, tied to a concept. id: de.a1.vocab.haus
class Realization {
  const Realization(this.id, this.lang, this.conceptId, this.lemma, {this.article, this.plural});
  final String id;
  final Lang lang;
  final String conceptId;
  final String lemma;
  final String? article;
  final String? plural;
}

class Lesson {
  const Lesson(this.id, this.lang, this.unitId, this.order, this.type, this.items);
  final String id;
  final Lang lang;
  final String unitId;
  final int order;
  final LessonType type;
  final List<String> items;
}

class ContrastPair {
  const ContrastPair(this.id, this.type, this.langA, this.textA, this.langB, this.textB, this.tip);
  final String id;
  final ContrastType type;
  final Lang langA;
  final String textA;
  final Lang langB;
  final String textB;
  final Explain tip;
}
