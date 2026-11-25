// Where the Polyglot Matrix state is saved: localStorage in the browser
// (key `polyglot-matrix-v1`), the app's local database on Android and in
// tests. The JSON is the same as the export file.

import 'package:flutter/foundation.dart' show kIsWeb;

import '../../data/local/local_db.dart';
import 'storage_stub.dart' if (dart.library.js_interop) 'storage_web.dart';

class PolyglotStore {
  PolyglotStore._(this._db, this.initial);

  static const key = 'polyglot-matrix-v1';

  final LocalDb? _db;

  /// JSON saved last time, or null on first run.
  final String? initial;

  /// Reads the saved JSON once, before the app starts.
  static Future<PolyglotStore> open(LocalDb? db) async {
    String? json;
    if (kIsWeb) json = webStorageRead(key);
    if (json == null && db != null) json = await db.getMeta<String>(key);
    return PolyglotStore._(db, json);
  }

  /// A store that starts empty and keeps nothing (tests, previews).
  factory PolyglotStore.memory([String? initial]) =>
      PolyglotStore._(null, initial);

  Future<void> save(String json) async {
    if (kIsWeb && webStorageWrite(key, json)) return;
    await _db?.setMeta(key, json);
  }
}
