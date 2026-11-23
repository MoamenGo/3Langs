// The three languages being learned at the same time, and how the app keeps
// them apart: each has its own colour, speech voice and start week.

import 'package:material_ui/material_ui.dart' show Color;

/// A language being learned (target language).
enum Lang {
  de(
    nameAr: 'الألماني',
    nameEn: 'German',
    color: Color(0xFFC9A100),
    tts: 'de-DE',
    startWeek: 1,
  ),
  es(
    nameAr: 'الإسباني',
    nameEn: 'Spanish',
    color: Color(0xFFC8102E),
    tts: 'es-ES',
    startWeek: 3,
  ),
  nl(
    nameAr: 'الهولندي',
    nameEn: 'Dutch',
    color: Color(0xFFE8650A),
    tts: 'nl-NL',
    startWeek: 9,
  );

  const Lang({
    required this.nameAr,
    required this.nameEn,
    required this.color,
    required this.tts,
    required this.startWeek,
  });

  final String nameAr;
  final String nameEn;

  /// Accent colour used everywhere this language is on screen.
  final Color color;

  /// Text-to-speech locale.
  final String tts;

  /// Week of the plan in which this language starts. German and Dutch are
  /// close, so Dutch starts once German A1 has settled.
  final int startWeek;

  /// Short label shown on chips: DE, ES, NL.
  String get code => name.toUpperCase();

  String displayName(String uiLanguage) => uiLanguage == 'ar' ? nameAr : nameEn;

  /// Pairs that must not get new lessons back to back in one session.
  static const similarPairs = {
    {Lang.de, Lang.nl},
  };

  static bool areSimilar(Lang a, Lang b) =>
      similarPairs.any((p) => p.contains(a) && p.contains(b));

  static Lang? tryParse(String? s) {
    for (final l in values) {
      if (l.name == s) return l;
    }
    return null;
  }
}

/// CEFR levels used by the app, A0 (first contact) to C1.
const cefrLevels = ['A0', 'A1', 'A2', 'B1', 'B2', 'C1'];

/// Content ids carry their language and level: `de.a1.vocab.haus`,
/// `es.a1.u03.l02`. This reads them back.
class ContentId {
  ContentId._(this.lang, this.level);
  final Lang lang;

  /// Upper case, for example 'A1'.
  final String level;

  static final _pattern = RegExp(r'^(de|nl|es)\.(a0|a1|a2|b1|b2|c1)\.');
  static final _legacy = RegExp(r'^(a0|a1|a2|b1|b2|c1)\.');

  static ContentId? parse(String id) {
    final m = _pattern.firstMatch(id);
    if (m == null) return null;
    return ContentId._(Lang.tryParse(m.group(1))!, m.group(2)!.toUpperCase());
  }

  /// Ids saved before 3Lang taught three languages were German only and had
  /// no language prefix (`a1.vocab.haus`). Returns the new id, or the same id
  /// when it is already in the new form.
  static String migrateLegacy(String id) =>
      _legacy.hasMatch(id) ? 'de.$id' : id;
}
