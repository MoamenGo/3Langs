// Blueprint sketch, not wired into the app.

/// The three languages being learned.
enum Lang { de, nl, es }

/// Languages used for explanations and the interface.
enum ExplainLang { ar, en }

/// How close two target languages are. Drives scheduling and contrast drills.
enum Similarity { low, high }

class LangConfig {
  const LangConfig({
    required this.lang,
    required this.colorHex,
    required this.ttsLocale,
    required this.startWeek,
    required this.defaultShare,
  });
  final Lang lang;
  final String colorHex;
  final String ttsLocale;
  final int startWeek;
  final double defaultShare;
}
