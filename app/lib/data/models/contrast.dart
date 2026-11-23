// The contrast dictionary (assets/content/contrast.json): false friends, near
// cognates and gender mismatches between German, Dutch and Spanish. Mirrors
// content/schema/contrast.schema.json.

import '../../core/lang/lang.dart';
import 'content.dart';

enum ContrastKind {
  falseFriend('false_friend'),
  nearCognate('near_cognate'),
  genderMismatch('gender_mismatch');

  const ContrastKind(this.json);
  final String json;

  static ContrastKind parse(String s) =>
      values.firstWhere((k) => k.json == s, orElse: () => falseFriend);
}

class ContrastEntry {
  const ContrastEntry({
    required this.id,
    required this.kind,
    required this.forms,
    required this.note,
    this.conceptId,
    this.level,
  });
  final String id;
  final ContrastKind kind;

  /// The words involved, by language code: de, nl, es and sometimes en.
  final Map<String, String> forms;
  final L10nText note;
  final String? conceptId;
  final String? level;

  /// Whether this entry is about [word]: same concept, or the word itself
  /// appears among the forms of its language.
  bool concerns(VocabItem word) {
    if (conceptId != null && conceptId == word.conceptId) return true;
    final form = forms[word.lang?.name];
    if (form == null) return false;
    return form == word.display ||
        form == word.lemma ||
        form.split(' / ').contains(word.display);
  }

  factory ContrastEntry.fromJson(Map<String, dynamic> j) => ContrastEntry(
    id: j['id'] as String,
    kind: ContrastKind.parse(j['kind'] as String),
    forms: Map<String, String>.from(j['forms'] as Map),
    note: L10nText.fromJson(j['note']),
    conceptId: j['conceptId'] as String?,
    level: j['level'] as String?,
  );
}

/// The language codes of [ContrastEntry.forms] in display order.
const contrastLangOrder = ['de', 'nl', 'es', 'en'];

/// The [Lang] for a form's code, or null for English.
Lang? langOfCode(String code) => Lang.tryParse(code);
