import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle;

import '../../core/lang/lang.dart';
import '../models/content.dart';

/// Loads course content: one pack per language and level, bundled in
/// assets/content/{lang}/{level}.json. Later levels will be downloaded from
/// Supabase Storage and cached the same way.
class ContentRepository {
  ContentRepository(this.bundle);
  final AssetBundle bundle;

  /// Packs that ship with this build. Dutch and Spanish arrive in phase 2.
  static const bundled = <Lang, List<String>>{
    Lang.de: ['A1'],
    Lang.es: [],
    Lang.nl: [],
  };

  static bool hasPack(Lang lang, String level) =>
      bundled[lang]?.contains(level) ?? false;

  /// The pack to study for a track at [level]: that level if it exists,
  /// otherwise the first bundled level at or above it, otherwise none.
  static String? packLevelFor(Lang lang, String level) {
    final from = cefrLevels.indexOf(level);
    for (final l in cefrLevels.skip(from < 0 ? 0 : from)) {
      if (hasPack(lang, l)) return l;
    }
    return null;
  }

  final _cache = <String, LevelContent>{};

  Future<LevelContent> level(Lang lang, String id) async {
    final key = '${lang.name}/${id.toLowerCase()}';
    final cached = _cache[key];
    if (cached != null) return cached;
    final raw = await bundle.loadString('assets/content/$key.json');
    final content = LevelContent.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
    return _cache[key] = content;
  }

  Future<List<OutlineLevel>> outline() async {
    final raw = await bundle.loadString('assets/content/course_outline.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['levels'] as List)
        .map((e) => OutlineLevel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Every bundled pack of every language, for review sessions.
  Future<List<LevelContent>> allAvailable() => Future.wait([
    for (final MapEntry(key: lang, value: levels) in bundled.entries)
      for (final l in levels) level(lang, l),
  ]);
}
