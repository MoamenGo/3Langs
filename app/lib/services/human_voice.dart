import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/lang/lang.dart';

/// Real recordings of native speakers from Lingua Libre, stored on Wikimedia
/// Commons under a free licence. Files are named
/// `LL-Q188 (deu)-<speaker>-<word>.wav`; we search Commons for the word and
/// play the first exact match.
class HumanVoice {
  HumanVoice({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  /// Wikidata item and ISO 639-3 code of each language, as Lingua Libre
  /// writes them in file names.
  static const _prefix = {
    Lang.de: 'LL-Q188 (deu)',
    Lang.nl: 'LL-Q7411 (nld)',
    Lang.es: 'LL-Q1321 (spa)',
  };

  static const _articles = {
    'der',
    'die',
    'das',
    'de',
    'het',
    'el',
    'la',
    'los',
    'las',
    'un',
    'una',
    'een',
    'ein',
    'eine',
  };

  final _cache = <String, String?>{};

  /// Words worth looking up for [text]: the text itself and, for a noun
  /// with its article, the noun alone. Sentences have no recordings.
  static List<String> candidates(String text) {
    final t = text.trim().replaceAll(RegExp(r'[.!?¡¿,]'), '');
    final words = t.split(RegExp(r'\s+'));
    if (t.isEmpty || words.length > 3) return const [];
    return [
      t,
      if (words.length == 2 && _articles.contains(words.first.toLowerCase()))
        words.last,
    ];
  }

  /// URL of a native-speaker recording of [text] in [lang], or null.
  Future<String?> find(String text, Lang lang) async {
    for (final word in candidates(text)) {
      final key = '${lang.name}:$word';
      if (_cache.containsKey(key)) {
        if (_cache[key] != null) return _cache[key];
        continue;
      }
      final url = await _search(word, lang);
      _cache[key] = url;
      if (url != null) return url;
    }
    return null;
  }

  Future<String?> _search(String word, Lang lang) async {
    final prefix = _prefix[lang]!;
    final uri = Uri.https('commons.wikimedia.org', '/w/api.php', {
      'action': 'query',
      'format': 'json',
      'origin': '*',
      'list': 'search',
      'srnamespace': '6',
      'srlimit': '20',
      'srsearch': 'intitle:"$prefix" intitle:"$word"',
    });
    try {
      final res = await _client.get(uri).timeout(const Duration(seconds: 5));
      if (res.statusCode != 200) return null;
      final hits =
          (jsonDecode(res.body)['query']?['search'] as List?) ?? const [];
      final file = pickFile(
        hits.map((h) => h['title'] as String),
        prefix,
        word,
      );
      if (file == null) return null;
      return 'https://commons.wikimedia.org/wiki/Special:FilePath/${Uri.encodeComponent(file)}';
    } catch (_) {
      return null;
    }
  }

  /// The first title that records exactly [word] (any speaker), without the
  /// `File:` prefix.
  static String? pickFile(Iterable<String> titles, String prefix, String word) {
    for (final title in titles) {
      final name = title.startsWith('File:') ? title.substring(5) : title;
      if (name.startsWith('$prefix-') && name.endsWith('-$word.wav')) {
        return name;
      }
    }
    return null;
  }
}
