import 'package:uuid/uuid.dart';

import '../local/local_db.dart';

class WritingRepository {
  WritingRepository(this.local);
  final LocalDb local;
  static const _uuid = Uuid();

  Future<void> save({
    required String? promptId,
    required String body,
    required List<Map<String, Object?>> issues,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final id = _uuid.v4();
    await local.putLocal(LocalDb.writingSubmissions, id, {
      'id': id,
      'prompt_id': promptId,
      'body': body,
      'issues': issues,
      'created_at': now,
      'deleted': false,
      'updated_at': now,
    });
  }

  Future<int> count() async =>
      (await local.all(LocalDb.writingSubmissions)).length;
}
