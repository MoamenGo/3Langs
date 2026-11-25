// Data of the Polyglot Matrix module: the parallel concept deck, the unified
// dictionary, the notebook planner and the free resources hub.
//
// Everything lives in one [PolyglotState] that is saved as JSON (browser
// localStorage on the web, the local database elsewhere) and can be exported
// and imported as a file.

import 'dart:convert';

/// A language the learner can put on the deck: the five built in ones
/// (German, English, Dutch, Spanish, French, plus Arabic) or a custom one.
class LanguageDef {
  const LanguageDef({
    required this.code,
    required this.name,
    required this.nameAr,
    required this.nativeName,
    required this.flag,
    required this.tts,
    this.rtl = false,
    this.level = 'A1',
    this.custom = false,
    this.colorValue = 0xFF2A7B76,
  });

  /// ISO 639-1 code, lower case (`de`, `fr`, `it`).
  final String code;
  final String name;
  final String nameAr;
  final String nativeName;

  /// Emoji flag shown on the badge.
  final String flag;

  /// Speech synthesis locale (`de-DE`).
  final String tts;
  final bool rtl;

  /// CEFR level the learner is working at in this language.
  final String level;
  final bool custom;

  /// Accent colour of the language's badge (ARGB).
  final int colorValue;

  /// Three-letter label used on chips and badges, like the design (DEU, NLD).
  String get iso3 => _iso3[code] ?? code.toUpperCase();

  String displayName(String ui) => ui == 'ar' ? nameAr : name;

  LanguageDef copyWith({String? level, String? name, String? tts}) =>
      LanguageDef(
        code: code,
        name: name ?? this.name,
        nameAr: nameAr,
        nativeName: nativeName,
        flag: flag,
        tts: tts ?? this.tts,
        rtl: rtl,
        level: level ?? this.level,
        custom: custom,
        colorValue: colorValue,
      );

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'nameAr': nameAr,
    'nativeName': nativeName,
    'flag': flag,
    'tts': tts,
    'rtl': rtl,
    'level': level,
    'custom': custom,
    'color': colorValue,
  };

  factory LanguageDef.fromJson(Map j) => LanguageDef(
    code: '${j['code']}',
    name: '${j['name'] ?? j['code']}',
    nameAr: '${j['nameAr'] ?? j['name'] ?? j['code']}',
    nativeName: '${j['nativeName'] ?? j['name'] ?? ''}',
    flag: '${j['flag'] ?? '🏳️'}',
    tts: '${j['tts'] ?? j['code']}',
    rtl: j['rtl'] == true,
    level: '${j['level'] ?? 'A1'}',
    custom: j['custom'] == true,
    colorValue: (j['color'] as num?)?.toInt() ?? 0xFF2A7B76,
  );

  static const _iso3 = {
    'de': 'DEU',
    'en': 'ENG',
    'nl': 'NLD',
    'es': 'SPA',
    'fr': 'FRA',
    'ar': 'ARA',
    'it': 'ITA',
    'pt': 'POR',
    'tr': 'TUR',
    'ru': 'RUS',
    'ja': 'JPN',
    'zh': 'ZHO',
    'sv': 'SWE',
    'pl': 'POL',
  };
}

/// The seven learning methods the deck can switch between.
enum Aspect {
  vocabulary('Vocabulary & Collocations', 'المفردات والتلازمات'),
  grammar('Grammar & Sentence Structure', 'القواعد وبناء الجملة'),
  listening('Listening & Phonetics', 'الاستماع والأصوات'),
  speaking('Speaking & Shadowing', 'التحدث والمحاكاة'),
  reading('Reading & Comprehension', 'القراءة والفهم'),
  writing('Writing & Recall', 'الكتابة والاسترجاع'),
  pragmatics('Pragmatics & Usage', 'الاستخدام والسياق');

  const Aspect(this.en, this.ar);
  final String en;
  final String ar;

  String label(String ui) => ui == 'ar' ? ar : en;

  /// Short name for chips on small screens.
  String short(String ui) => label(ui).split(ui == 'ar' ? ' و' : ' & ').first;

  static Aspect parse(Object? v) =>
      values.firstWhere((a) => a.name == v, orElse: () => Aspect.vocabulary);
}

/// Skills a study task or a resource trains. Wider than [Aspect]: the
/// planner also needs pronunciation and spaced-repetition review.
enum Skill {
  listening('Listening', 'استماع'),
  speaking('Speaking', 'تحدث'),
  reading('Reading', 'قراءة'),
  writing('Writing', 'كتابة'),
  grammar('Grammar', 'قواعد'),
  vocabulary('Vocabulary', 'مفردات'),
  pronunciation('Pronunciation', 'نطق'),
  review('Spaced review', 'مراجعة متباعدة'),
  culture('Culture & input', 'ثقافة ومحتوى حقيقي');

  const Skill(this.en, this.ar);
  final String en;
  final String ar;
  String label(String ui) => ui == 'ar' ? ar : en;

  static Skill parse(Object? v) =>
      values.firstWhere((a) => a.name == v, orElse: () => Skill.vocabulary);
}

/// One language's version of a concept.
class ConceptLine {
  const ConceptLine({
    required this.text,
    this.ipa = '',
    this.literal = '',
    this.natural = '',
  });

  /// The sentence or phrase in the target language.
  final String text;

  /// IPA or transliteration.
  final String ipa;

  /// Word-for-word English gloss.
  final String literal;

  /// Natural English translation (when it differs from the concept's).
  final String natural;

  Map<String, dynamic> toJson() => {
    'text': text,
    if (ipa.isNotEmpty) 'ipa': ipa,
    if (literal.isNotEmpty) 'literal': literal,
    if (natural.isNotEmpty) 'natural': natural,
  };

  factory ConceptLine.fromJson(Map j) => ConceptLine(
    text: '${j['text'] ?? ''}',
    ipa: '${j['ipa'] ?? ''}',
    literal: '${j['literal'] ?? ''}',
    natural: '${j['natural'] ?? ''}',
  );
}

/// A core concept, sentence or grammar pattern shown side by side in every
/// active language.
class Concept {
  const Concept({
    required this.id,
    required this.aspect,
    required this.titleEn,
    required this.titleAr,
    required this.meaningEn,
    required this.meaningAr,
    required this.noteEn,
    required this.noteAr,
    required this.lines,
    this.level = 'A1',
    this.wordGroups = const [],
  });

  final String id;
  final Aspect aspect;
  final String titleEn;
  final String titleAr;

  /// Natural meaning of the whole line.
  final String meaningEn;
  final String meaningAr;

  /// The cross-language insight ("compare verb position...").
  final String noteEn;
  final String noteAr;
  final String level;

  /// Language code -> line.
  final Map<String, ConceptLine> lines;

  /// Dictionary word groups (conceptIds) this line teaches.
  final List<String> wordGroups;

  String title(String ui) => ui == 'ar' ? titleAr : titleEn;
  String meaning(String ui) => ui == 'ar' ? meaningAr : meaningEn;
  String note(String ui) => ui == 'ar' ? noteAr : noteEn;

  Concept withLine(String lang, ConceptLine line) => Concept(
    id: id,
    aspect: aspect,
    titleEn: titleEn,
    titleAr: titleAr,
    meaningEn: meaningEn,
    meaningAr: meaningAr,
    noteEn: noteEn,
    noteAr: noteAr,
    level: level,
    wordGroups: wordGroups,
    lines: {...lines, lang: line},
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'aspect': aspect.name,
    'titleEn': titleEn,
    'titleAr': titleAr,
    'meaningEn': meaningEn,
    'meaningAr': meaningAr,
    'noteEn': noteEn,
    'noteAr': noteAr,
    'level': level,
    'wordGroups': wordGroups,
    'lines': {for (final e in lines.entries) e.key: e.value.toJson()},
  };

  factory Concept.fromJson(Map j) => Concept(
    id: '${j['id']}',
    aspect: Aspect.parse(j['aspect']),
    titleEn: '${j['titleEn'] ?? ''}',
    titleAr: '${j['titleAr'] ?? j['titleEn'] ?? ''}',
    meaningEn: '${j['meaningEn'] ?? ''}',
    meaningAr: '${j['meaningAr'] ?? j['meaningEn'] ?? ''}',
    noteEn: '${j['noteEn'] ?? ''}',
    noteAr: '${j['noteAr'] ?? j['noteEn'] ?? ''}',
    level: '${j['level'] ?? 'A1'}',
    wordGroups: [for (final w in (j['wordGroups'] as List? ?? const [])) '$w'],
    lines: {
      for (final e in ((j['lines'] as Map?) ?? const {}).entries)
        '${e.key}': ConceptLine.fromJson(e.value as Map),
    },
  );
}

/// Learning stage of a word, a phrase or a concept in one language.
enum Stage {
  fresh('New', 'جديد'),
  learning('Learning', 'قيد التعلم'),
  mastered('Mastered', 'متقن');

  const Stage(this.en, this.ar);
  final String en;
  final String ar;
  String label(String ui) => ui == 'ar' ? ar : en;

  Stage get next => values[(index + 1) % values.length];

  static Stage parse(Object? v) =>
      values.firstWhere((s) => s.name == v, orElse: () => Stage.fresh);
}

/// Parts of speech the dictionary filters by.
const partsOfSpeech = [
  'noun',
  'verb',
  'adjective',
  'adverb',
  'phrase',
  'expression',
  'number',
  'other',
];

const posAr = {
  'noun': 'اسم',
  'verb': 'فعل',
  'adjective': 'صفة',
  'adverb': 'ظرف',
  'phrase': 'عبارة',
  'expression': 'تعبير',
  'number': 'عدد',
  'other': 'أخرى',
};

/// One word or phrase in one language. Entries with the same [group] are
/// equivalents across languages (cognates or translations).
class DictEntry {
  const DictEntry({
    required this.id,
    required this.lang,
    required this.term,
    required this.group,
    this.pos = 'noun',
    this.gender = '',
    this.ipa = '',
    this.meaningEn = '',
    this.meaningAr = '',
    this.example = '',
    this.exampleEn = '',
    this.note = '',
    this.tags = const [],
    this.stage = Stage.fresh,
    this.source = '',
    this.custom = false,
  });

  final String id;
  final String lang;
  final String term;

  /// Cross-language link (`c.house`).
  final String group;
  final String pos;

  /// Article or gender, as written in the language (der, het, la, f).
  final String gender;
  final String ipa;
  final String meaningEn;
  final String meaningAr;
  final String example;
  final String exampleEn;

  /// Pronunciation or usage note.
  final String note;
  final List<String> tags;
  final Stage stage;

  /// Where the word comes from (a link).
  final String source;
  final bool custom;

  String meaning(String ui) =>
      ui == 'ar' && meaningAr.isNotEmpty ? meaningAr : meaningEn;

  DictEntry copyWith({
    String? term,
    String? pos,
    String? gender,
    String? ipa,
    String? meaningEn,
    String? meaningAr,
    String? example,
    String? exampleEn,
    String? note,
    List<String>? tags,
    Stage? stage,
    String? source,
    String? group,
  }) => DictEntry(
    id: id,
    lang: lang,
    term: term ?? this.term,
    group: group ?? this.group,
    pos: pos ?? this.pos,
    gender: gender ?? this.gender,
    ipa: ipa ?? this.ipa,
    meaningEn: meaningEn ?? this.meaningEn,
    meaningAr: meaningAr ?? this.meaningAr,
    example: example ?? this.example,
    exampleEn: exampleEn ?? this.exampleEn,
    note: note ?? this.note,
    tags: tags ?? this.tags,
    stage: stage ?? this.stage,
    source: source ?? this.source,
    custom: custom,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'lang': lang,
    'term': term,
    'group': group,
    'pos': pos,
    if (gender.isNotEmpty) 'gender': gender,
    if (ipa.isNotEmpty) 'ipa': ipa,
    'meaningEn': meaningEn,
    if (meaningAr.isNotEmpty) 'meaningAr': meaningAr,
    if (example.isNotEmpty) 'example': example,
    if (exampleEn.isNotEmpty) 'exampleEn': exampleEn,
    if (note.isNotEmpty) 'note': note,
    if (tags.isNotEmpty) 'tags': tags,
    'stage': stage.name,
    if (source.isNotEmpty) 'source': source,
    if (custom) 'custom': true,
  };

  factory DictEntry.fromJson(Map j) => DictEntry(
    id: '${j['id']}',
    lang: '${j['lang']}',
    term: '${j['term'] ?? ''}',
    group: '${j['group'] ?? j['id']}',
    pos: '${j['pos'] ?? 'other'}',
    gender: '${j['gender'] ?? ''}',
    ipa: '${j['ipa'] ?? ''}',
    meaningEn: '${j['meaningEn'] ?? ''}',
    meaningAr: '${j['meaningAr'] ?? ''}',
    example: '${j['example'] ?? ''}',
    exampleEn: '${j['exampleEn'] ?? ''}',
    note: '${j['note'] ?? ''}',
    tags: [for (final t in (j['tags'] as List? ?? const [])) '$t'],
    stage: Stage.parse(j['stage']),
    source: '${j['source'] ?? ''}',
    custom: j['custom'] == true,
  );
}

/// A notebook page: one idea, linked across several languages.
class NoteEntry {
  const NoteEntry({
    required this.id,
    required this.title,
    required this.created,
    this.body = '',
    this.conceptId,
    this.perLang = const {},
    this.tags = const [],
    this.skill = Skill.grammar,
    this.link = '',
  });

  final String id;
  final String title;
  final String body;
  final DateTime created;
  final String? conceptId;

  /// Language code -> the learner's note or example in that language.
  final Map<String, String> perLang;
  final List<String> tags;
  final Skill skill;

  /// Optional resource link.
  final String link;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'created': created.toIso8601String(),
    if (conceptId != null) 'conceptId': conceptId,
    'perLang': perLang,
    'tags': tags,
    'skill': skill.name,
    if (link.isNotEmpty) 'link': link,
  };

  factory NoteEntry.fromJson(Map j) => NoteEntry(
    id: '${j['id']}',
    title: '${j['title'] ?? ''}',
    body: '${j['body'] ?? ''}',
    created: DateTime.tryParse('${j['created']}') ?? DateTime.now(),
    conceptId: j['conceptId'] as String?,
    perLang: {
      for (final e in ((j['perLang'] as Map?) ?? const {}).entries)
        '${e.key}': '${e.value}',
    },
    tags: [for (final t in (j['tags'] as List? ?? const [])) '$t'],
    skill: Skill.parse(j['skill']),
    link: '${j['link'] ?? ''}',
  );
}

/// How study time is shared between the languages.
enum PlanStrategy {
  equal(
    'Equal rotation',
    'تناوب متساوٍ',
    'Every language gets the same time each day.',
    'كل لغة تأخذ الوقت نفسه كل يوم.',
  ),
  coreLight(
    'Core + light touch',
    'لغات أساسية + لمسة خفيفة',
    'Two core languages get most of the time; the others get short daily touches so they are not forgotten.',
    'لغتان أساسيتان تأخذان معظم الوقت، والباقي لمسات قصيرة يومية حتى لا تُنسى.',
  ),
  focusSprint(
    'Focus sprint',
    'سباق تركيز',
    'One language gets half of the time this week (an exam or a trip); the rest keep a maintenance dose.',
    'لغة واحدة تأخذ نصف الوقت هذا الأسبوع (امتحان أو سفر)، والباقي جرعة صيانة.',
  );

  const PlanStrategy(this.en, this.ar, this.descEn, this.descAr);
  final String en;
  final String ar;
  final String descEn;
  final String descAr;
  String label(String ui) => ui == 'ar' ? ar : en;
  String desc(String ui) => ui == 'ar' ? descAr : descEn;

  static PlanStrategy parse(Object? v) =>
      values.firstWhere((s) => s.name == v, orElse: () => PlanStrategy.equal);
}

class PlanConfig {
  const PlanConfig({
    this.strategy = PlanStrategy.coreLight,
    this.minutesPerDay = 120,
    this.studyDays = 6,
    this.core = const ['de', 'nl'],
    this.focus = 'de',
  });

  final PlanStrategy strategy;
  final int minutesPerDay;

  /// Days a week with study, counted from Monday.
  final int studyDays;

  /// Core languages for [PlanStrategy.coreLight].
  final List<String> core;

  /// Sprint language for [PlanStrategy.focusSprint].
  final String focus;

  PlanConfig copyWith({
    PlanStrategy? strategy,
    int? minutesPerDay,
    int? studyDays,
    List<String>? core,
    String? focus,
  }) => PlanConfig(
    strategy: strategy ?? this.strategy,
    minutesPerDay: minutesPerDay ?? this.minutesPerDay,
    studyDays: studyDays ?? this.studyDays,
    core: core ?? this.core,
    focus: focus ?? this.focus,
  );

  Map<String, dynamic> toJson() => {
    'strategy': strategy.name,
    'minutesPerDay': minutesPerDay,
    'studyDays': studyDays,
    'core': core,
    'focus': focus,
  };

  factory PlanConfig.fromJson(Map j) => PlanConfig(
    strategy: PlanStrategy.parse(j['strategy']),
    minutesPerDay: ((j['minutesPerDay'] as num?) ?? 120).toInt().clamp(15, 600),
    studyDays: ((j['studyDays'] as num?) ?? 6).toInt().clamp(1, 7),
    core: [
      for (final c in (j['core'] as List? ?? const ['de', 'nl'])) '$c',
    ],
    focus: '${j['focus'] ?? 'de'}',
  );
}

/// One block in the weekly schedule.
class StudyTask {
  const StudyTask({
    required this.id,
    required this.day,
    required this.lang,
    required this.skill,
    required this.minutes,
    required this.title,
    this.done = false,
    this.custom = false,
    this.slot = 0,
  });

  final String id;

  /// 0 = Monday ... 6 = Sunday.
  final int day;

  /// Language code, or `*` for a task covering every active language.
  final String lang;
  final Skill skill;
  final int minutes;
  final String title;
  final bool done;
  final bool custom;

  /// 0 morning, 1 afternoon, 2 evening.
  final int slot;

  StudyTask copyWith({
    int? day,
    String? lang,
    Skill? skill,
    int? minutes,
    String? title,
    bool? done,
    int? slot,
  }) => StudyTask(
    id: id,
    day: day ?? this.day,
    lang: lang ?? this.lang,
    skill: skill ?? this.skill,
    minutes: minutes ?? this.minutes,
    title: title ?? this.title,
    done: done ?? this.done,
    custom: custom,
    slot: slot ?? this.slot,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'day': day,
    'lang': lang,
    'skill': skill.name,
    'minutes': minutes,
    'title': title,
    'done': done,
    if (custom) 'custom': true,
    'slot': slot,
  };

  factory StudyTask.fromJson(Map j) => StudyTask(
    id: '${j['id']}',
    day: ((j['day'] as num?) ?? 0).toInt().clamp(0, 6),
    lang: '${j['lang'] ?? '*'}',
    skill: Skill.parse(j['skill']),
    minutes: ((j['minutes'] as num?) ?? 15).toInt(),
    title: '${j['title'] ?? ''}',
    done: j['done'] == true,
    custom: j['custom'] == true,
    slot: ((j['slot'] as num?) ?? 0).toInt().clamp(0, 2),
  );
}

/// Formats of free resources.
enum ResourceFormat {
  video('Video & YouTube', 'فيديو ويوتيوب'),
  book('Free books & OER', 'كتب مجانية ومصادر مفتوحة'),
  audio('Audio & podcasts', 'صوتيات وبودكاست'),
  tool('Reference & practice tools', 'أدوات مرجعية وتدريب');

  const ResourceFormat(this.en, this.ar);
  final String en;
  final String ar;
  String label(String ui) => ui == 'ar' ? ar : en;

  static ResourceFormat parse(Object? v) =>
      values.firstWhere((f) => f.name == v, orElse: () => ResourceFormat.tool);
}

class Resource {
  const Resource({
    required this.id,
    required this.title,
    required this.url,
    required this.langs,
    required this.format,
    required this.skills,
    this.level = 'A1-B2',
    this.descEn = '',
    this.descAr = '',
    this.provider = '',
    this.custom = false,
  });

  final String id;
  final String title;
  final String url;

  /// Language codes covered; `*` means every language.
  final List<String> langs;
  final ResourceFormat format;
  final List<Skill> skills;
  final String level;
  final String descEn;
  final String descAr;
  final String provider;
  final bool custom;

  String desc(String ui) => ui == 'ar' && descAr.isNotEmpty ? descAr : descEn;

  bool covers(String lang) => langs.contains('*') || langs.contains(lang);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'url': url,
    'langs': langs,
    'format': format.name,
    'skills': [for (final s in skills) s.name],
    'level': level,
    'descEn': descEn,
    if (descAr.isNotEmpty) 'descAr': descAr,
    if (provider.isNotEmpty) 'provider': provider,
    if (custom) 'custom': true,
  };

  factory Resource.fromJson(Map j) => Resource(
    id: '${j['id']}',
    title: '${j['title'] ?? ''}',
    url: '${j['url'] ?? ''}',
    langs: [
      for (final l in (j['langs'] as List? ?? const ['*'])) '$l',
    ],
    format: ResourceFormat.parse(j['format']),
    skills: [
      for (final s in (j['skills'] as List? ?? const [])) Skill.parse(s),
    ],
    level: '${j['level'] ?? ''}',
    descEn: '${j['descEn'] ?? ''}',
    descAr: '${j['descAr'] ?? ''}',
    provider: '${j['provider'] ?? ''}',
    custom: j['custom'] == true,
  );
}

/// Everything the module saves.
class PolyglotState {
  const PolyglotState({
    required this.languages,
    required this.active,
    required this.concepts,
    required this.dictionary,
    required this.notes,
    required this.plan,
    required this.tasks,
    required this.weekStart,
    required this.resources,
    this.bookmarks = const {},
    this.mastery = const {},
    this.studyDays = const {},
    this.conceptIndex = 0,
    this.aspect,
  });

  static const version = 1;

  final List<LanguageDef> languages;

  /// Codes of the languages on the deck, in order.
  final List<String> active;
  final List<Concept> concepts;
  final List<DictEntry> dictionary;
  final List<NoteEntry> notes;
  final PlanConfig plan;
  final List<StudyTask> tasks;

  /// Monday of the week [tasks] belong to (yyyy-mm-dd).
  final String weekStart;
  final List<Resource> resources;
  final Set<String> bookmarks;

  /// `conceptId|lang` -> stage of that line.
  final Map<String, Stage> mastery;

  /// Days (yyyy-mm-dd) with any study activity, for the streak.
  final Set<String> studyDays;

  /// Position in the deck.
  final int conceptIndex;

  /// Learning method filter of the deck; null shows every concept.
  final Aspect? aspect;

  LanguageDef? lang(String code) {
    for (final l in languages) {
      if (l.code == code) return l;
    }
    return null;
  }

  List<LanguageDef> get activeLanguages => [
    for (final c in active)
      if (lang(c) != null) lang(c)!,
  ];

  PolyglotState copyWith({
    List<LanguageDef>? languages,
    List<String>? active,
    List<Concept>? concepts,
    List<DictEntry>? dictionary,
    List<NoteEntry>? notes,
    PlanConfig? plan,
    List<StudyTask>? tasks,
    String? weekStart,
    List<Resource>? resources,
    Set<String>? bookmarks,
    Map<String, Stage>? mastery,
    Set<String>? studyDays,
    int? conceptIndex,
    Aspect? aspect,
    bool clearAspect = false,
  }) => PolyglotState(
    languages: languages ?? this.languages,
    active: active ?? this.active,
    concepts: concepts ?? this.concepts,
    dictionary: dictionary ?? this.dictionary,
    notes: notes ?? this.notes,
    plan: plan ?? this.plan,
    tasks: tasks ?? this.tasks,
    weekStart: weekStart ?? this.weekStart,
    resources: resources ?? this.resources,
    bookmarks: bookmarks ?? this.bookmarks,
    mastery: mastery ?? this.mastery,
    studyDays: studyDays ?? this.studyDays,
    conceptIndex: conceptIndex ?? this.conceptIndex,
    aspect: clearAspect ? null : (aspect ?? this.aspect),
  );

  Map<String, dynamic> toJson() => {
    'app': '3Lang Polyglot Matrix',
    'version': version,
    'exportedAt': DateTime.now().toUtc().toIso8601String(),
    'languages': [for (final l in languages) l.toJson()],
    'active': active,
    'concepts': [for (final c in concepts) c.toJson()],
    'dictionary': [for (final d in dictionary) d.toJson()],
    'notes': [for (final n in notes) n.toJson()],
    'plan': plan.toJson(),
    'tasks': [for (final t in tasks) t.toJson()],
    'weekStart': weekStart,
    'resources': [for (final r in resources) r.toJson()],
    'bookmarks': bookmarks.toList(),
    'mastery': {for (final e in mastery.entries) e.key: e.value.name},
    'studyDays': studyDays.toList()..sort(),
    'conceptIndex': conceptIndex,
    'aspect': aspect?.name,
  };

  String encode({bool pretty = false}) => pretty
      ? const JsonEncoder.withIndent('  ').convert(toJson())
      : jsonEncode(toJson());

  /// Reads a saved or exported state. Throws [FormatException] when the
  /// JSON is not a Polyglot Matrix file.
  factory PolyglotState.fromJson(Map j) {
    if (j['languages'] is! List || j['concepts'] is! List) {
      throw const FormatException('Not a Polyglot Matrix file');
    }
    List<Map> list(String k) => [
      for (final e in (j[k] as List? ?? const []))
        if (e is Map) e,
    ];
    final languages = [
      for (final m in list('languages')) LanguageDef.fromJson(m),
    ];
    final codes = {for (final l in languages) l.code};
    return PolyglotState(
      languages: languages,
      active: [
        for (final a in (j['active'] as List? ?? const []))
          if (codes.contains('$a')) '$a',
      ],
      concepts: [for (final m in list('concepts')) Concept.fromJson(m)],
      dictionary: [for (final m in list('dictionary')) DictEntry.fromJson(m)],
      notes: [for (final m in list('notes')) NoteEntry.fromJson(m)],
      plan: PlanConfig.fromJson((j['plan'] as Map?) ?? const {}),
      tasks: [for (final m in list('tasks')) StudyTask.fromJson(m)],
      weekStart: '${j['weekStart'] ?? ''}',
      resources: [for (final m in list('resources')) Resource.fromJson(m)],
      bookmarks: {for (final b in (j['bookmarks'] as List? ?? const [])) '$b'},
      mastery: {
        for (final e in ((j['mastery'] as Map?) ?? const {}).entries)
          '${e.key}': Stage.parse(e.value),
      },
      studyDays: {for (final d in (j['studyDays'] as List? ?? const [])) '$d'},
      conceptIndex: ((j['conceptIndex'] as num?) ?? 0).toInt(),
      aspect: j['aspect'] == null ? null : Aspect.parse(j['aspect']),
    );
  }

  static PolyglotState decode(String s) {
    final v = jsonDecode(s);
    if (v is! Map) throw const FormatException('Not a Polyglot Matrix file');
    return PolyglotState.fromJson(v);
  }
}

/// yyyy-mm-dd of a local date.
String dayKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Monday of the week of [d].
DateTime mondayOf(DateTime d) =>
    DateTime(d.year, d.month, d.day).subtract(Duration(days: d.weekday - 1));
