import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/env.dart';

/// One problem LanguageTool found in the learner's text.
class WritingIssue {
  const WritingIssue({
    required this.message,
    required this.offset,
    required this.length,
    required this.replacements,
    required this.rule,
  });

  final String message;
  final int offset;
  final int length;
  final List<String> replacements;
  final String rule;

  Map<String, Object?> toJson() => {
    'message': message,
    'offset': offset,
    'length': length,
    'replacements': replacements,
    'rule': rule,
  };
}

/// Grammar and spelling checks for German writing, via the free LanguageTool
/// API. Explanations come back in the learner's explanation language when
/// LanguageTool supports it (`motherTongue`).
class LanguageToolService {
  LanguageToolService({http.Client? client})
    : _client = client ?? http.Client();
  final http.Client _client;

  Future<List<WritingIssue>> check(
    String text, {
    String motherTongue = 'en',
  }) async {
    final res = await _client.post(
      Uri.parse('${Env.languageToolUrl}/check'),
      body: {
        'text': text,
        'language': 'de-DE',
        'motherTongue': motherTongue,
        'level': 'default',
      },
    );
    if (res.statusCode != 200) {
      throw Exception('LanguageTool error ${res.statusCode}');
    }
    final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    return [
      for (final m in json['matches'] as List)
        WritingIssue(
          message: m['message'] as String,
          offset: m['offset'] as int,
          length: m['length'] as int,
          replacements: [
            for (final r in (m['replacements'] as List).take(3))
              r['value'] as String,
          ],
          rule: (m['rule'] as Map)['id'] as String,
        ),
    ];
  }
}
