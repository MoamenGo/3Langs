// Course content records, read from the JSON level files in assets/content/.
// These mirror content/schema/level.schema.json. Content is read-only in the
// app; learner progress points at the stable `id` of each record.

import '../../core/lang/lang.dart';

/// Language used for translations, explanations and the app interface.
/// Arabic is the default; English is the fallback when a text has no Arabic yet.
enum ExplainLang { ar, en }

/// Text available in Arabic and English.
class L10nText {
  const L10nText(this.values);
  final Map<String, String> values;

  factory L10nText.fromJson(Object? json) =>
      L10nText(Map<String, String>.from((json as Map?) ?? const {}));

  /// The text in [lang], falling back to English, then any language.
  /// While Arabic is being added, many texts still only have English.
  String get(ExplainLang lang) =>
      values[lang.name] ??
      values['en'] ??
      (values.isEmpty ? '' : values.values.first);
}

class AudioRef {
  const AudioRef({required this.kind, required this.ref, this.license});
  final String kind;
  final String ref;
  final String? license;

  static AudioRef? fromJson(Object? json) {
    if (json is! Map) return null;
    return AudioRef(
      kind: json['kind'] as String,
      ref: json['ref'] as String,
      license: json['license'] as String?,
    );
  }
}

class Level {
  const Level({
    required this.id,
    required this.title,
    required this.targetHours,
    required this.canDo,
  });
  final String id;
  final L10nText title;
  final int targetHours;
  final List<L10nText> canDo;

  factory Level.fromJson(Map<String, dynamic> j) => Level(
    id: j['id'] as String,
    title: L10nText.fromJson(j['title']),
    targetHours: j['targetHours'] as int,
    canDo: _list(j['canDo']).map(L10nText.fromJson).toList(),
  );
}

class Unit {
  const Unit({
    required this.id,
    required this.level,
    required this.order,
    required this.theme,
    required this.goals,
    required this.grammarIds,
    required this.lessonIds,
    this.sharedUnitId,
  });
  final String id;
  final String level;
  final int order;
  final L10nText theme;

  /// The unit of the shared three-language syllabus this unit realises,
  /// for example `u.a1.03` for "Home" in German, Dutch and Spanish.
  final String? sharedUnitId;
  final List<L10nText> goals;
  final List<String> grammarIds;
  final List<String> lessonIds;

  factory Unit.fromJson(Map<String, dynamic> j) => Unit(
    id: j['id'] as String,
    level: j['level'] as String,
    order: j['order'] as int,
    theme: L10nText.fromJson(j['theme']),
    goals: _list(j['goals']).map(L10nText.fromJson).toList(),
    grammarIds: _strings(j['grammarIds']),
    lessonIds: _strings(j['lessonIds']),
    sharedUnitId: j['sharedUnitId'] as String?,
  );
}

enum LessonType { vocab, grammar, listening, reading, review, exam }

class Lesson {
  const Lesson({
    required this.id,
    required this.unitId,
    required this.order,
    required this.type,
    required this.title,
    required this.items,
    this.grammarId,
    this.textId,
  });
  final String id;
  final String unitId;
  final int order;
  final LessonType type;
  final L10nText title;

  /// Vocabulary ids (vocab/review lessons) or sentence ids (listening).
  final List<String> items;
  final String? grammarId;
  final String? textId;

  factory Lesson.fromJson(Map<String, dynamic> j) => Lesson(
    id: j['id'] as String,
    unitId: j['unitId'] as String,
    order: j['order'] as int,
    type: LessonType.values.byName(j['type'] as String),
    title: L10nText.fromJson(j['title']),
    items: _strings(j['items']),
    grammarId: j['grammarId'] as String?,
    textId: j['textId'] as String?,
  );
}

class VocabItem {
  const VocabItem({
    required this.id,
    required this.lemma,
    required this.pos,
    required this.level,
    required this.translations,
    required this.sentenceIds,
    required this.source,
    required this.license,
    this.article,
    this.plural,
    this.freqRank,
    this.ipa,
    this.audio,
  });
  final String id;
  final String lemma;
  final String? article;
  final String? plural;
  final String pos;
  final String level;
  final int? freqRank;
  final String? ipa;
  final AudioRef? audio;
  final L10nText translations;
  final List<String> sentenceIds;
  final String source;
  final String license;

  /// "der Name" for nouns, the plain lemma otherwise.
  String get display => article == null ? lemma : '$article $lemma';

  factory VocabItem.fromJson(Map<String, dynamic> j) => VocabItem(
    id: j['id'] as String,
    lemma: j['lemma'] as String,
    article: j['article'] as String?,
    plural: j['plural'] as String?,
    pos: j['pos'] as String,
    level: j['level'] as String,
    freqRank: j['freqRank'] as int?,
    ipa: j['ipa'] as String?,
    audio: AudioRef.fromJson(j['audio']),
    translations: L10nText.fromJson(j['translations']),
    sentenceIds: _strings(j['sentenceIds']),
    source: j['source'] as String? ?? '',
    license: j['license'] as String? ?? '',
  );
}

class Sentence {
  const Sentence({
    required this.id,
    required this.text,
    required this.translations,
    required this.source,
    required this.license,
    this.audio,
  });
  final String id;

  /// The sentence in the pack's target language.
  final String text;
  final L10nText translations;
  final AudioRef? audio;
  final String source;
  final String license;

  factory Sentence.fromJson(Map<String, dynamic> j) => Sentence(
    id: j['id'] as String,
    text: (j['text'] ?? j['de']) as String,
    translations: L10nText.fromJson(j['translations']),
    audio: AudioRef.fromJson(j['audio']),
    source: j['source'] as String? ?? '',
    license: j['license'] as String? ?? '',
  );
}

class GrammarExercise {
  const GrammarExercise({
    required this.type,
    required this.prompt,
    required this.answer,
    this.base,
    this.options = const [],
  });
  final String type;
  final String prompt;
  final String answer;
  final String? base;
  final List<String> options;

  factory GrammarExercise.fromJson(Map<String, dynamic> j) => GrammarExercise(
    type: j['type'] as String,
    prompt: j['prompt'] as String,
    answer: j['answer'] as String,
    base: j['base'] as String?,
    options: _strings(j['options']),
  );
}

class GrammarPoint {
  const GrammarPoint({
    required this.id,
    required this.level,
    required this.title,
    required this.explanation,
    required this.exampleSentenceIds,
    required this.exercises,
    this.tableHeaders = const [],
    this.tableRows = const [],
  });
  final String id;
  final String level;
  final L10nText title;
  final L10nText explanation;
  final List<String> tableHeaders;
  final List<List<String>> tableRows;
  final List<String> exampleSentenceIds;
  final List<GrammarExercise> exercises;

  factory GrammarPoint.fromJson(Map<String, dynamic> j) {
    final table = j['table'] as Map<String, dynamic>?;
    return GrammarPoint(
      id: j['id'] as String,
      level: j['level'] as String,
      title: L10nText.fromJson(j['title']),
      explanation: L10nText.fromJson(j['explanation']),
      tableHeaders: _strings(table?['headers']),
      tableRows: _list(table?['rows']).map(_strings).toList(),
      exampleSentenceIds: _strings(j['exampleSentenceIds']),
      exercises: _list(j['exercises'])
          .map((e) => GrammarExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Question {
  const Question({
    required this.question,
    required this.options,
    required this.answer,
  });
  final String question;
  final List<String> options;
  final int answer;

  factory Question.fromJson(Map<String, dynamic> j) => Question(
    question: j['question'] as String,
    options: _strings(j['options']),
    answer: j['answer'] as int,
  );
}

class ContentText {
  const ContentText({
    required this.id,
    required this.level,
    required this.kind,
    required this.title,
    required this.glossary,
    required this.questions,
    required this.source,
    required this.license,
    this.body,
    this.url,
    this.translation,
  });
  final String id;
  final String level;

  /// reading, listening or external (a link to a free site such as DW).
  final String kind;
  final String title;
  final String? body;
  final String? url;
  final L10nText? translation;
  final List<String> glossary;
  final List<Question> questions;
  final String source;
  final String license;

  factory ContentText.fromJson(Map<String, dynamic> j) => ContentText(
    id: j['id'] as String,
    level: j['level'] as String,
    kind: j['kind'] as String,
    title: j['title'] as String,
    body: j['body'] as String?,
    url: j['url'] as String?,
    translation: j['translation'] == null
        ? null
        : L10nText.fromJson(j['translation']),
    glossary: _strings(j['glossary']),
    questions: _list(j['questions'])
        .map((e) => Question.fromJson(e as Map<String, dynamic>))
        .toList(),
    source: j['source'] as String? ?? '',
    license: j['license'] as String? ?? '',
  );
}

class WritingPrompt {
  const WritingPrompt({
    required this.id,
    required this.level,
    required this.prompt,
    this.minWords = 10,
  });
  final String id;
  final String level;
  final L10nText prompt;
  final int minWords;

  factory WritingPrompt.fromJson(Map<String, dynamic> j) => WritingPrompt(
    id: j['id'] as String,
    level: j['level'] as String,
    prompt: L10nText.fromJson(j['prompt']),
    minWords: j['minWords'] as int? ?? 10,
  );
}

/// A whole level file, indexed by id for quick lookups.
class LevelContent {
  LevelContent({
    required this.lang,
    required this.contentVersion,
    required this.level,
    required this.units,
    required this.lessons,
    required this.vocab,
    required this.sentences,
    required this.grammar,
    required this.texts,
    required this.writingPrompts,
  });

  /// The language this pack teaches.
  final Lang lang;
  final String contentVersion;
  final Level level;
  final List<Unit> units;
  final Map<String, Lesson> lessons;
  final Map<String, VocabItem> vocab;
  final Map<String, Sentence> sentences;
  final Map<String, GrammarPoint> grammar;
  final Map<String, ContentText> texts;
  final List<WritingPrompt> writingPrompts;

  factory LevelContent.fromJson(Map<String, dynamic> j) {
    Map<String, T> byId<T>(
      String key,
      T Function(Map<String, dynamic>) f,
      String Function(T) id,
    ) => {
      for (final e in _list(j[key])) id(f(e as Map<String, dynamic>)): f(e),
    };
    return LevelContent(
      lang: Lang.tryParse(j['lang'] as String?) ?? Lang.de,
      contentVersion: j['contentVersion'] as String,
      level: Level.fromJson(j['level'] as Map<String, dynamic>),
      units:
          _list(j['units'])
              .map((e) => Unit.fromJson(e as Map<String, dynamic>))
              .toList()
            ..sort((a, b) => a.order.compareTo(b.order)),
      lessons: byId('lessons', Lesson.fromJson, (l) => l.id),
      vocab: byId('vocab', VocabItem.fromJson, (v) => v.id),
      sentences: byId('sentences', Sentence.fromJson, (s) => s.id),
      grammar: byId('grammar', GrammarPoint.fromJson, (g) => g.id),
      texts: byId('texts', ContentText.fromJson, (t) => t.id),
      writingPrompts: _list(j['writingPrompts'])
          .map((e) => WritingPrompt.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  List<Lesson> lessonsOf(Unit unit) =>
      [for (final id in unit.lessonIds) lessons[id]]
          .whereType<Lesson>()
          .toList();
}

/// One level of the shared A0-C1 syllabus (assets/content/course_outline.json).
/// The same units are taught in every language; hours are per language.
class OutlineLevel {
  const OutlineLevel({
    required this.id,
    required this.title,
    required this.targetHours,
    required this.unitIds,
    required this.unitThemes,
  });
  final String id;
  final L10nText title;
  final int targetHours;

  /// Shared unit ids, for example `u.a1.03`.
  final List<String> unitIds;
  final List<L10nText> unitThemes;

  factory OutlineLevel.fromJson(Map<String, dynamic> j) => OutlineLevel(
    id: j['id'] as String,
    title: L10nText.fromJson(j['title']),
    targetHours: j['targetHours'] as int,
    unitIds: _list(j['units']).map((u) => (u as Map)['id'] as String).toList(),
    unitThemes: _list(j['units'])
        .map((u) => L10nText.fromJson((u as Map)['theme']))
        .toList(),
  );
}

List<Object?> _list(Object? v) => (v as List?) ?? const [];
List<String> _strings(Object? v) => _list(v).cast<String>().toList();
