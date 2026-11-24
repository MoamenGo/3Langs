import 'package:uuid/uuid.dart';

import '../../core/lang/lang.dart';
import '../../domain/interference/interference_detector.dart';
import '../local/local_db.dart';

/// Mix-ups between languages, saved as they happen (append only, synced).
class InterferenceRepository {
  InterferenceRepository(this.local);
  final LocalDb local;
  static const _uuid = Uuid();

  Future<InterferenceEvent> record({
    required Lang lang,
    required InterferenceMatch match,
    required String expected,
    required String given,
    DateTime? now,
  }) async {
    final e = InterferenceEvent(
      id: _uuid.v4(),
      lang: lang,
      otherLang: match.otherLang,
      conceptId: match.conceptId,
      kind: match.kind,
      expected: expected,
      given: given,
      at: (now ?? DateTime.now()).toUtc(),
    );
    await local.putLocal(LocalDb.interferenceEvents, e.id, e.toJson());
    return e;
  }

  Stream<List<InterferenceEvent>> watch() => local
      .watchAll(LocalDb.interferenceEvents)
      .map(
        (rows) =>
            rows
                .map((r) => InterferenceEvent.fromJson(Map.of(r)))
                .toList()
              ..sort((a, b) => b.at.compareTo(a.at)),
      );

  Future<List<InterferenceEvent>> all() async =>
      (await local.all(LocalDb.interferenceEvents))
          .map((r) => InterferenceEvent.fromJson(Map.of(r)))
          .toList()
        ..sort((a, b) => b.at.compareTo(a.at));
}

/// Events in the 7 days before [now].
int eventsThisWeek(List<InterferenceEvent> events, DateTime now) => events
    .where((e) => now.difference(e.at) < const Duration(days: 7))
    .length;
