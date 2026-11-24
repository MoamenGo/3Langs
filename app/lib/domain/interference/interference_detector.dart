// Spots answers that come from the wrong language: typing the German word in
// a Dutch exercise (huis -> Haus), or picking the Spanish look-alike. Each one
// is saved as an interference event; three in a week add a contrast drill to
// the day's plan, and the confusables list shows your own mix-ups.

import '../../core/lang/lang.dart';
import '../../data/models/content.dart';
import '../../data/models/contrast.dart';

class InterferenceEvent {
  const InterferenceEvent({
    required this.id,
    required this.lang,
    required this.otherLang,
    required this.expected,
    required this.given,
    required this.at,
    this.conceptId,
    this.kind = 'same_concept',
  });

  final String id;

  /// The language being practised.
  final Lang lang;

  /// The language the wrong answer came from.
  final Lang otherLang;
  final String? conceptId;

  /// same_concept (the other language's word for this meaning) or
  /// confusable (a look-alike or false friend from the contrast dictionary).
  final String kind;
  final String expected;
  final String given;
  final DateTime at;

  Map<String, dynamic> toJson() => {
    'id': id,
    'lang': lang.name,
    'other_lang': otherLang.name,
    'concept_id': conceptId,
    'kind': kind,
    'expected': expected,
    'given': given,
    'occurred_at': at.toIso8601String(),
    'updated_at': at.toIso8601String(),
  };

  factory InterferenceEvent.fromJson(Map<String, dynamic> j) =>
      InterferenceEvent(
        id: j['id'] as String,
        lang: Lang.tryParse(j['lang'] as String?) ?? Lang.de,
        otherLang: Lang.tryParse(j['other_lang'] as String?) ?? Lang.nl,
        conceptId: j['concept_id'] as String?,
        kind: j['kind'] as String? ?? 'same_concept',
        expected: j['expected'] as String? ?? '',
        given: j['given'] as String? ?? '',
        at: DateTime.parse(j['occurred_at'] as String).toUtc(),
      );
}

/// What a wrong answer was, if it came from another language.
class InterferenceMatch {
  const InterferenceMatch({
    required this.otherLang,
    required this.kind,
    this.conceptId,
  });
  final Lang otherLang;
  final String kind;
  final String? conceptId;
}

class InterferenceDetector {
  InterferenceDetector({
    required Map<String, Map<Lang, VocabItem>> concepts,
    List<ContrastEntry> contrast = const [],
  }) : _concepts = concepts {
    for (final concept in concepts.values) {
      for (final MapEntry(key: lang, value: word) in concept.entries) {
        for (final form in _forms(word)) {
          _byForm.putIfAbsent(form, () => []).add((lang, word.conceptId));
        }
      }
    }
    for (final e in contrast) {
      for (final MapEntry(key: code, value: form) in e.forms.entries) {
        final lang = Lang.tryParse(code);
        if (lang == null) continue;
        _byForm
            .putIfAbsent(normalize(form), () => [])
            .add((lang, e.conceptId));
        _byForm
            .putIfAbsent(normalize(_stripArticle(form)), () => [])
            .add((lang, e.conceptId));
      }
    }
  }

  final Map<String, Map<Lang, VocabItem>> _concepts;
  final _byForm = <String, List<(Lang, String?)>>{};

  static const _articles = {
    'der', 'die', 'das', 'de', 'het', 'el', 'la', 'los', 'las', 'een', 'ein',
    'eine', 'un', 'una',
  };

  static String normalize(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[.,!?¿¡;:"()]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  static String _stripArticle(String s) {
    final parts = s.trim().split(RegExp(r'\s+'));
    if (parts.length > 1 && _articles.contains(parts.first.toLowerCase())) {
      return parts.skip(1).join(' ');
    }
    return s;
  }

  static Iterable<String> _forms(VocabItem w) => {
    normalize(w.lemma),
    normalize(w.display),
    if (w.plural != null) normalize(w.plural!),
  };

  /// Checks a wrong answer for [target]. Returns null when the answer is
  /// right, or wrong for a reason that has nothing to do with another
  /// language.
  InterferenceMatch? check(VocabItem target, String answer) {
    final lang = target.lang;
    if (lang == null) return null;
    final given = normalize(answer);
    if (given.isEmpty) return null;
    if (_forms(target).contains(given) ||
        normalize(_stripArticle(answer)) == normalize(target.lemma)) {
      return null;
    }
    // 1. The same meaning in another language.
    final concept = target.conceptId == null
        ? null
        : _concepts[target.conceptId];
    if (concept != null) {
      for (final MapEntry(key: other, value: word) in concept.entries) {
        if (other == lang) continue;
        final forms = _forms(word);
        if (forms.contains(given) ||
            forms.contains(normalize(_stripArticle(answer)))) {
          return InterferenceMatch(
            otherLang: other,
            kind: 'same_concept',
            conceptId: target.conceptId,
          );
        }
      }
    }
    // 2. Any known word of another language (a look-alike or false friend).
    final hits = _byForm[given] ?? _byForm[normalize(_stripArticle(answer))];
    if (hits != null) {
      for (final (other, cid) in hits) {
        if (other != lang) {
          return InterferenceMatch(
            otherLang: other,
            kind: 'confusable',
            conceptId: cid ?? target.conceptId,
          );
        }
      }
    }
    return null;
  }
}
