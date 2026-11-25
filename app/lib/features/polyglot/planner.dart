// Builds the weekly 4+ language study schedule.
//
// The plan shares each day's minutes between the active languages according
// to the strategy (equal, core + light touch, focus sprint), rotates the
// skills so every language gets listening, speaking, reading, writing,
// grammar, vocabulary, pronunciation and real-world input during the week,
// and ends every study day with a spaced-repetition review across all
// languages. Close pairs (German/Dutch, Spanish/French) are put in different
// blocks of the day to limit interference.

import 'models.dart';

/// Minutes of the daily all-language review block.
const reviewMinutes = 15;

const _cycle = [
  Skill.listening,
  Skill.speaking,
  Skill.reading,
  Skill.writing,
  Skill.grammar,
  Skill.vocabulary,
  Skill.pronunciation,
  Skill.culture,
];

/// Receptive skills go in the morning, productive ones in the afternoon.
const _receptive = {
  Skill.listening,
  Skill.reading,
  Skill.culture,
  Skill.pronunciation,
};

/// Languages that are easy to mix up.
const _closePairs = [
  {'de', 'nl'},
  {'es', 'fr'},
];

bool areClose(String a, String b) =>
    _closePairs.any((p) => p.contains(a) && p.contains(b));

/// Share of the daily time each language gets (sums to 1).
Map<String, double> planWeights(PlanConfig cfg, List<String> langs) {
  if (langs.isEmpty) return const {};
  final n = langs.length;
  switch (cfg.strategy) {
    case PlanStrategy.equal:
      return {for (final l in langs) l: 1 / n};
    case PlanStrategy.coreLight:
      final core = [
        for (final c in cfg.core)
          if (langs.contains(c)) c,
      ];
      final coreSet = core.isEmpty ? {langs.first} : core.toSet();
      final light = n - coreSet.length;
      if (light == 0) return {for (final l in langs) l: 1 / n};
      return {
        for (final l in langs)
          l: coreSet.contains(l) ? 0.75 / coreSet.length : 0.25 / light,
      };
    case PlanStrategy.focusSprint:
      final focus = langs.contains(cfg.focus) ? cfg.focus : langs.first;
      if (n == 1) return {focus: 1};
      return {for (final l in langs) l: l == focus ? 0.5 : 0.5 / (n - 1)};
  }
}

int _round5(double m) => ((m / 5).round() * 5).clamp(5, 600);

/// The generated week. Generated tasks have an empty title: the screen
/// writes it in the interface language with [taskTitle].
List<StudyTask> generateWeek(PlanConfig cfg, List<String> langs) {
  final weights = planWeights(cfg, langs);
  final langMinutes = (cfg.minutesPerDay - reviewMinutes)
      .clamp(10, 600)
      .toDouble();
  final tasks = <StudyTask>[];
  for (var day = 0; day < 7; day++) {
    if (day >= cfg.studyDays) continue;
    final slots = <int, List<String>>{0: [], 1: []};
    for (var i = 0; i < langs.length; i++) {
      final lang = langs[i];
      final minutes = _round5(langMinutes * (weights[lang] ?? 0));
      final light = minutes < 20;
      // Light-touch languages alternate listening and vocabulary.
      final skill = light
          ? (day.isEven ? Skill.listening : Skill.vocabulary)
          : _cycle[(day * 3 + i * 5) % _cycle.length];
      var slot = _receptive.contains(skill) ? 0 : 1;
      // Keep close languages in different blocks of the day.
      if (slots[slot]!.any((o) => areClose(o, lang))) slot = 1 - slot;
      slots[slot]!.add(lang);
      tasks.add(
        StudyTask(
          id: 'g.$day.$lang',
          day: day,
          lang: lang,
          skill: skill,
          minutes: minutes,
          title: '',
          slot: slot,
        ),
      );
    }
    tasks.add(
      StudyTask(
        id: 'g.$day.review',
        day: day,
        lang: '*',
        skill: Skill.review,
        minutes: reviewMinutes,
        title: '',
        slot: 2,
      ),
    );
  }
  return tasks;
}

/// What to do in a generated block, by skill.
String taskTitle(StudyTask t, String langName, String ui) {
  if (t.title.isNotEmpty) return t.title;
  final ar = ui == 'ar';
  switch (t.skill) {
    case Skill.listening:
      return ar
          ? 'استمع إلى حلقة قصيرة بـ$langName ودوّن 5 كلمات جديدة'
          : 'Listen to a short $langName episode and note 5 new words';
    case Skill.speaking:
      return ar
          ? 'محاكاة (Shadowing): كرر 10 جمل بـ$langName بصوت عالٍ'
          : 'Shadowing: repeat 10 $langName sentences aloud';
    case Skill.reading:
      return ar
          ? 'اقرأ نصًا قصيرًا بـ$langName ولخصه في 3 جمل'
          : 'Read a short $langName text and sum it up in 3 sentences';
    case Skill.writing:
      return ar
          ? 'اكتب 5 جمل بـ$langName من الذاكرة ثم صححها'
          : 'Write 5 $langName sentences from memory, then correct them';
    case Skill.grammar:
      return ar
          ? 'قاعدة واحدة بـ$langName: اقرأها وقارنها بلغة أخرى'
          : 'One $langName grammar point: study it and compare it with another language';
    case Skill.vocabulary:
      return ar
          ? 'أضف 8 كلمات بـ$langName إلى القاموس وراجعها'
          : 'Add 8 $langName words to the dictionary and review them';
    case Skill.pronunciation:
      return ar
          ? 'تدريب نطق بـ$langName: الأصوات الصعبة والنبر'
          : '$langName pronunciation drill: hard sounds and stress';
    case Skill.culture:
      return ar
          ? 'محتوى حقيقي بـ$langName: أخبار أو فيديو أو بودكاست'
          : 'Real-world $langName input: news, video or podcast';
    case Skill.review:
      return ar
          ? 'مراجعة متباعدة لكل اللغات (البطاقات والقاموس)'
          : 'Spaced-repetition review across all languages (cards and dictionary)';
  }
}
