// The contrast drill: "Which is the Dutch word for house?" with the German,
// Dutch and Spanish words (and a wrong-article version) as options. Built
// from your own mix-ups first, then from the contrast dictionary, so it
// trains exactly the pairs that trip you up.

import 'dart:math';

import '../../core/lang/lang.dart';
import '../../data/models/content.dart';
import '../../data/models/contrast.dart';
import 'interference_detector.dart';

class DrillOption {
  const DrillOption(this.text, this.lang, {this.correct = false});
  final String text;

  /// The language the option really belongs to (null for a made-up form,
  /// such as a noun with the wrong article).
  final Lang? lang;
  final bool correct;
}

class DrillQuestion {
  const DrillQuestion({required this.target, required this.options, this.note});

  /// The word to find.
  final VocabItem target;
  final List<DrillOption> options;

  /// Why these get mixed up (from the contrast dictionary).
  final L10nText? note;
}

/// Wrong-article versions of a noun: de huis for het huis, la problema for
/// el problema, die Haus for das Haus.
List<String> wrongArticles(VocabItem w) {
  final a = w.article;
  if (a == null) return const [];
  const sets = {
    'der': ['die', 'das'],
    'die': ['der', 'das'],
    'das': ['der', 'die'],
    'de': ['het'],
    'het': ['de'],
    'el': ['la'],
    'la': ['el'],
  };
  return [for (final x in sets[a] ?? const <String>[]) '$x ${w.lemma}'];
}

List<DrillQuestion> buildContrastDrill({
  required Map<String, Map<Lang, VocabItem>> concepts,
  required List<ContrastEntry> contrast,
  required List<InterferenceEvent> events,
  required Set<Lang> langs,
  int count = 12,
  Random? random,
}) {
  final rnd = random ?? Random();
  final notes = <String, L10nText>{
    for (final e in contrast)
      if (e.conceptId != null) e.conceptId!: e.note,
  };
  // Concepts in order of priority: your mix-ups (most recent first), then
  // dictionary entries, then nothing else.
  final order = <String>[];
  for (final e in events) {
    if (e.conceptId != null && !order.contains(e.conceptId)) {
      order.add(e.conceptId!);
    }
  }
  final dictionary = [
    for (final e in contrast)
      if (e.conceptId != null && !order.contains(e.conceptId)) e.conceptId!,
  ]..shuffle(rnd);
  order.addAll(dictionary.toSet());

  final out = <DrillQuestion>[];
  for (final cid in order) {
    if (out.length >= count) break;
    final words = concepts[cid];
    if (words == null) continue;
    final present = {
      for (final e in words.entries)
        if (langs.contains(e.key)) e.key: e.value,
    };
    if (present.length < 2) continue;
    final targets = present.keys.toList()..shuffle(rnd);
    final lang = targets.first;
    final target = present[lang]!;
    final options = <DrillOption>[
      DrillOption(target.display, lang, correct: true),
      for (final e in present.entries)
        if (e.key != lang && e.value.display != target.display)
          DrillOption(e.value.display, e.key),
    ];
    final fakes = wrongArticles(target)..shuffle(rnd);
    if (fakes.isNotEmpty) options.add(DrillOption(fakes.first, null));
    if (options.length < 2) continue;
    options.shuffle(rnd);
    out.add(DrillQuestion(target: target, options: options, note: notes[cid]));
  }
  return out;
}
