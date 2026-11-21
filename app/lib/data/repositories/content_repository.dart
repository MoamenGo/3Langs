import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle;

import '../models/content.dart';

/// Loads course content. Level files are bundled in assets/content/ today;
/// later levels can be downloaded from Supabase Storage and cached the same way.
class ContentRepository {
  ContentRepository(this.bundle);
  final AssetBundle bundle;

  /// Levels whose content file ships with this build.
  static const bundledLevels = ['A1'];

  final _cache = <String, LevelContent>{};

  Future<LevelContent> level(String id) async {
    final cached = _cache[id];
    if (cached != null) return cached;
    final raw = await bundle.loadString(
      'assets/content/${id.toLowerCase()}.json',
    );
    final content = LevelContent.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
    return _cache[id] = content;
  }

  Future<List<OutlineLevel>> outline() async {
    final raw = await bundle.loadString('assets/content/course_outline.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['levels'] as List)
        .map((e) => OutlineLevel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// All content from every bundled level, for review sessions that mix levels.
  Future<List<LevelContent>> allAvailable() =>
      Future.wait(bundledLevels.map(level));
}
