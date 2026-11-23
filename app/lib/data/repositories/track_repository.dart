import '../../core/lang/lang.dart';
import '../local/local_db.dart';
import '../models/learner.dart';

/// One track per language: level, current unit, status and time share.
class TrackRepository {
  TrackRepository(this.local);
  final LocalDb local;

  Stream<Map<Lang, LanguageTrack>> watch() =>
      local.watchAll(LocalDb.languageTracks).map(_byLang);

  Future<Map<Lang, LanguageTrack>> all() async =>
      _byLang(await local.all(LocalDb.languageTracks));

  Future<void> save(LanguageTrack track) =>
      local.putLocal(LocalDb.languageTracks, track.lang.name, track.toJson());

  Map<Lang, LanguageTrack> _byLang(List<Map<String, Object?>> rows) {
    final now = DateTime.now().toUtc();
    final tracks = {
      for (final r in rows)
        if (Lang.tryParse(r['lang'] as String?) != null)
          Lang.tryParse(r['lang'] as String?)!: LanguageTrack.fromJson(
            Map<String, dynamic>.from(r),
          ),
    };
    return {
      for (final lang in Lang.values)
        lang: tracks[lang] ?? LanguageTrack.defaultFor(lang, now),
    };
  }
}
