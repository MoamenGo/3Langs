// State and actions of the Polyglot Matrix module (Riverpod Notifier).
// Every change is saved right away (see storage.dart).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models.dart';
import 'planner.dart';
import 'seed_concepts.dart';
import 'seed_dictionary.dart';
import 'seed_resources.dart';
import 'storage.dart';

/// Opened in main() before the app starts; an in-memory store elsewhere.
final polyglotStoreProvider = Provider<PolyglotStore>(
  (ref) => PolyglotStore.memory(),
);

final polyglotProvider = NotifierProvider<PolyglotController, PolyglotState>(
  PolyglotController.new,
);

/// The sample data every screen starts with.
PolyglotState seedState([DateTime? now]) {
  final monday = mondayOf(now ?? DateTime.now());
  const plan = PlanConfig();
  return PolyglotState(
    languages: seedLanguages,
    active: seedActive,
    concepts: seedConcepts,
    dictionary: buildSeedDictionary(),
    notes: [
      NoteEntry(
        id: 'n.seed.v2',
        title: 'Verb second (V2) in German and Dutch',
        body:
            'When a sentence starts with time or place, the verb stays in '
            'slot 2 and the subject moves after it. Spanish and French do '
            'not do this.',
        created: monday,
        conceptId: 'k.v2-market',
        perLang: const {
          'de': 'Heute gehe ich zum Markt.',
          'nl': 'Vandaag ga ik naar de markt.',
          'es': 'Hoy voy al mercado.',
          'fr': 'Aujourd’hui, je vais au marché.',
        },
        tags: const ['word order', 'grammar'],
        skill: Skill.grammar,
      ),
      NoteEntry(
        id: 'n.seed.false-friends',
        title: 'False friends to watch',
        body:
            'Brief (DE/NL) = letter, not "short". Une station (FR) = metro '
            'stop; a train station is une gare. Embarazada (ES) = pregnant.',
        created: monday,
        perLang: const {
          'de': 'der Brief – the letter',
          'nl': 'de brief – the letter',
          'fr': 'la gare – the train station',
          'es': 'embarazada – pregnant',
        },
        tags: const ['false friends', 'vocabulary'],
        skill: Skill.vocabulary,
      ),
    ],
    plan: plan,
    tasks: generateWeek(plan, seedActive),
    weekStart: dayKey(monday),
    resources: seedResources,
    bookmarks: const {'r.dw-nicos', 'r.tatoeba'},
  );
}

class PolyglotController extends Notifier<PolyglotState> {
  late PolyglotStore _store;

  /// Clock, replaceable in tests.
  DateTime Function() now = DateTime.now;

  @override
  PolyglotState build() {
    _store = ref.watch(polyglotStoreProvider);
    PolyglotState s;
    try {
      s = _store.initial == null
          ? seedState(now())
          : _upgrade(PolyglotState.decode(_store.initial!));
    } catch (_) {
      // Unreadable save: start again from the sample data.
      s = seedState(now());
    }
    return _rollWeek(s);
  }

  /// Adds built-in items a newer app version ships (new languages,
  /// concepts or resources) without touching the learner's own data.
  PolyglotState _upgrade(PolyglotState s) {
    final haveLang = {for (final l in s.languages) l.code};
    final haveConcept = {for (final c in s.concepts) c.id};
    final haveRes = {for (final r in s.resources) r.id};
    final haveDict = {for (final d in s.dictionary) d.id};
    return s.copyWith(
      languages: [
        ...s.languages,
        for (final l in seedLanguages)
          if (!haveLang.contains(l.code)) l,
      ],
      concepts: [
        ...s.concepts,
        for (final c in seedConcepts)
          if (!haveConcept.contains(c.id)) c,
      ],
      resources: [
        ...s.resources,
        for (final r in seedResources)
          if (!haveRes.contains(r.id)) r,
      ],
      dictionary: s.dictionary.isEmpty
          ? buildSeedDictionary()
          : [
              ...s.dictionary,
              for (final d in buildSeedDictionary())
                if (!haveDict.contains(d.id) &&
                    !s.dictionary.any((e) => e.group == d.group))
                  d,
            ],
      active: s.active.isEmpty ? seedActive : s.active,
    );
  }

  /// A new week starts with a fresh schedule; the learner's own tasks are
  /// kept and unticked.
  PolyglotState _rollWeek(PolyglotState s) {
    final monday = dayKey(mondayOf(now()));
    if (s.weekStart == monday && s.tasks.isNotEmpty) return s;
    return s.copyWith(
      weekStart: monday,
      tasks: [
        ...generateWeek(s.plan, s.active),
        for (final t in s.tasks)
          if (t.custom) t.copyWith(done: false),
      ],
    );
  }

  void _set(PolyglotState s) {
    state = s;
    _store.save(s.encode());
  }

  String _id(String prefix) =>
      '$prefix.${now().microsecondsSinceEpoch.toRadixString(36)}';

  void _studied() {
    final today = dayKey(now());
    if (!state.studyDays.contains(today)) {
      state = state.copyWith(studyDays: {...state.studyDays, today});
    }
  }

  // ------------------------------------------------------------ languages

  void toggleLanguage(String code) {
    final on = state.active.contains(code);
    if (on && state.active.length == 1) return; // keep at least one
    _set(
      state.copyWith(
        active: on
            ? [
                for (final c in state.active)
                  if (c != code) c,
              ]
            : [...state.active, code],
      ),
    );
  }

  void addLanguage(LanguageDef def) {
    final exists = state.lang(def.code) != null;
    _set(
      state.copyWith(
        languages: exists
            ? [for (final l in state.languages) l.code == def.code ? def : l]
            : [...state.languages, def],
        active: state.active.contains(def.code)
            ? state.active
            : [...state.active, def.code],
      ),
    );
  }

  void removeLanguage(String code) {
    final l = state.lang(code);
    if (l == null || !l.custom) return;
    final active = [
      for (final c in state.active)
        if (c != code) c,
    ];
    _set(
      state.copyWith(
        languages: [
          for (final x in state.languages)
            if (x.code != code) x,
        ],
        active: active.isEmpty ? [state.languages.first.code] : active,
      ),
    );
  }

  void setLevel(String code, String level) => _set(
    state.copyWith(
      languages: [
        for (final l in state.languages)
          l.code == code ? l.copyWith(level: level) : l,
      ],
    ),
  );

  // ----------------------------------------------------------------- deck

  /// Concepts of the chosen learning method (all when none is chosen).
  List<Concept> get deck => [
    for (final c in state.concepts)
      if (state.aspect == null || c.aspect == state.aspect) c,
  ];

  void setAspect(Aspect? a) => _set(
    a == null
        ? state.copyWith(clearAspect: true, conceptIndex: 0)
        : state.copyWith(aspect: a, conceptIndex: 0),
  );

  void step(int delta) {
    final n = deck.length;
    if (n == 0) return;
    _set(state.copyWith(conceptIndex: (state.conceptIndex + delta) % n));
  }

  void showConcept(String id) {
    var i = state.concepts.indexWhere((c) => c.id == id);
    if (i < 0) return;
    final c = state.concepts[i];
    final s = state.aspect != null && state.aspect != c.aspect
        ? state.copyWith(clearAspect: true)
        : state;
    final list = [
      for (final x in s.concepts)
        if (s.aspect == null || x.aspect == s.aspect) x,
    ];
    i = list.indexWhere((x) => x.id == id);
    _set(s.copyWith(conceptIndex: i < 0 ? 0 : i));
  }

  /// Writes or corrects one language's line (used for custom languages).
  void setLine(String conceptId, String lang, ConceptLine line) => _set(
    state.copyWith(
      concepts: [
        for (final c in state.concepts)
          c.id == conceptId ? c.withLine(lang, line) : c,
      ],
    ),
  );

  Stage mastery(String conceptId, String lang) =>
      state.mastery['$conceptId|$lang'] ?? Stage.fresh;

  void cycleMastery(String conceptId, String lang) {
    _studied();
    final k = '$conceptId|$lang';
    _set(
      state.copyWith(
        mastery: {...state.mastery, k: mastery(conceptId, lang).next},
      ),
    );
  }

  /// Marks that the learner practised (listening, recall, shadowing).
  void practised() {
    final before = state.studyDays.length;
    _studied();
    if (state.studyDays.length != before) _set(state);
  }

  // ----------------------------------------------------------- dictionary

  /// Saves the concept's line in [lang] as a phrase. Returns false when it
  /// is already in the dictionary.
  bool saveLine(Concept c, String lang) {
    final line = c.lines[lang];
    if (line == null || line.text.isEmpty) return false;
    final id = '${c.id}.$lang';
    if (state.dictionary.any((d) => d.id == id)) return false;
    _studied();
    _set(
      state.copyWith(
        dictionary: [
          ...state.dictionary,
          DictEntry(
            id: id,
            lang: lang,
            term: line.text,
            group: c.id,
            pos: 'phrase',
            ipa: line.ipa,
            meaningEn: c.meaningEn,
            meaningAr: c.meaningAr,
            note: line.literal.isEmpty ? '' : 'Literally: ${line.literal}',
            tags: [c.aspect.name, c.level, 'deck'],
            custom: true,
          ),
        ],
      ),
    );
    return true;
  }

  bool inDictionary(String conceptId, String lang) =>
      state.dictionary.any((d) => d.id == '$conceptId.$lang');

  /// Adds one word in several languages at once, linked as equivalents.
  void addWordGroup({
    required Map<String, String> terms,
    required String pos,
    required String meaningEn,
    String meaningAr = '',
    List<String> tags = const [],
    Map<String, String> ipa = const {},
    String note = '',
    String group = '',
  }) {
    final g = group.isEmpty ? _id('c.user') : group;
    _studied();
    _set(
      state.copyWith(
        dictionary: [
          ...state.dictionary,
          for (final e in terms.entries)
            if (e.value.trim().isNotEmpty)
              DictEntry(
                id: '$g.${e.key}.${now().microsecondsSinceEpoch}',
                lang: e.key,
                term: e.value.trim(),
                group: g,
                pos: pos,
                ipa: ipa[e.key] ?? '',
                meaningEn: meaningEn,
                meaningAr: meaningAr,
                note: note,
                tags: tags,
                custom: true,
              ),
        ],
      ),
    );
  }

  void updateEntry(DictEntry e) => _set(
    state.copyWith(
      dictionary: [for (final d in state.dictionary) d.id == e.id ? e : d],
    ),
  );

  void deleteEntry(String id) => _set(
    state.copyWith(
      dictionary: [
        for (final d in state.dictionary)
          if (d.id != id) d,
      ],
    ),
  );

  void setStage(String id, Stage stage) {
    _studied();
    _set(
      state.copyWith(
        dictionary: [
          for (final d in state.dictionary)
            d.id == id ? d.copyWith(stage: stage) : d,
        ],
      ),
    );
  }

  /// Self-test answer: knowing it moves a word up a stage, missing it sends
  /// it back to "learning".
  void quizAnswer(String id, bool knew) {
    final d = state.dictionary.firstWhere((x) => x.id == id);
    setStage(
      id,
      knew
          ? (d.stage == Stage.fresh ? Stage.learning : Stage.mastered)
          : Stage.learning,
    );
  }

  // ------------------------------------------------------------- notebook

  NoteEntry pinConcept(Concept c) {
    _studied();
    final note = NoteEntry(
      id: _id('n'),
      title: c.titleEn,
      body: c.noteEn,
      created: now(),
      conceptId: c.id,
      perLang: {
        for (final l in state.active)
          if (c.lines[l] != null) l: c.lines[l]!.text,
      },
      tags: [c.aspect.name, c.level],
      skill: _skillOf(c.aspect),
    );
    _set(state.copyWith(notes: [note, ...state.notes]));
    return note;
  }

  void saveNote(NoteEntry n) {
    final exists = state.notes.any((x) => x.id == n.id);
    _set(
      state.copyWith(
        notes: exists
            ? [for (final x in state.notes) x.id == n.id ? n : x]
            : [n, ...state.notes],
      ),
    );
  }

  NoteEntry newNote({String title = '', String link = '', Skill? skill}) =>
      NoteEntry(
        id: _id('n'),
        title: title,
        created: now(),
        link: link,
        skill: skill ?? Skill.grammar,
      );

  void deleteNote(String id) => _set(
    state.copyWith(
      notes: [
        for (final n in state.notes)
          if (n.id != id) n,
      ],
    ),
  );

  static Skill _skillOf(Aspect a) => switch (a) {
    Aspect.vocabulary => Skill.vocabulary,
    Aspect.grammar => Skill.grammar,
    Aspect.listening => Skill.listening,
    Aspect.speaking => Skill.speaking,
    Aspect.reading => Skill.reading,
    Aspect.writing => Skill.writing,
    Aspect.pragmatics => Skill.culture,
  };

  // -------------------------------------------------------------- planner

  void setPlan(PlanConfig cfg) => _set(
    state.copyWith(
      plan: cfg,
      tasks: [
        ...generateWeek(cfg, state.active),
        for (final t in state.tasks)
          if (t.custom) t,
      ],
    ),
  );

  /// Rebuilds the generated part of the week (after changing languages).
  void regenerate() => setPlan(state.plan);

  void toggleTask(String id) {
    final t = state.tasks.firstWhere((x) => x.id == id);
    if (!t.done) _studied();
    _set(
      state.copyWith(
        tasks: [
          for (final x in state.tasks)
            x.id == id ? x.copyWith(done: !x.done) : x,
        ],
      ),
    );
  }

  void saveTask(StudyTask t) {
    final exists = state.tasks.any((x) => x.id == t.id);
    _set(
      state.copyWith(
        tasks: exists
            ? [for (final x in state.tasks) x.id == t.id ? t : x]
            : [...state.tasks, t],
      ),
    );
  }

  StudyTask newTask(int day) => StudyTask(
    id: _id('t'),
    day: day,
    lang: state.active.first,
    skill: Skill.reading,
    minutes: 20,
    title: '',
    custom: true,
    slot: 1,
  );

  void deleteTask(String id) => _set(
    state.copyWith(
      tasks: [
        for (final t in state.tasks)
          if (t.id != id) t,
      ],
    ),
  );

  // ------------------------------------------------------------ resources

  void toggleBookmark(String id) {
    final b = {...state.bookmarks};
    if (!b.remove(id)) b.add(id);
    _set(state.copyWith(bookmarks: b));
  }

  void addResource(Resource r) =>
      _set(state.copyWith(resources: [r, ...state.resources]));

  void deleteResource(String id) => _set(
    state.copyWith(
      resources: [
        for (final r in state.resources)
          if (r.id != id) r,
      ],
      bookmarks: {...state.bookmarks}..remove(id),
    ),
  );

  String newResourceId() => _id('r.user');

  // ----------------------------------------------------------- import etc

  /// Replaces everything with an imported file. Throws [FormatException].
  void importJson(String json) {
    final s = _rollWeek(_upgrade(PolyglotState.decode(json)));
    _set(s);
  }

  void resetToSample() => _set(seedState(now()));

  // ---------------------------------------------------------------- stats

  /// Days in a row with study, ending today (or yesterday).
  int get streak {
    var d = DateTime(now().year, now().month, now().day);
    if (!state.studyDays.contains(dayKey(d))) {
      d = d.subtract(const Duration(days: 1));
    }
    var n = 0;
    while (state.studyDays.contains(dayKey(d))) {
      n++;
      d = d.subtract(const Duration(days: 1));
    }
    return n;
  }

  int get todayIndex => now().weekday - 1;

  /// Minutes planned and done today.
  (int done, int planned) get todayGoal {
    var done = 0, planned = 0;
    for (final t in state.tasks) {
      if (t.day != todayIndex) continue;
      planned += t.minutes;
      if (t.done) done += t.minutes;
    }
    return (done, planned);
  }
}
