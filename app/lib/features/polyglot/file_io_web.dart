// Browser download of the JSON export and file picker for the import.

import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

const canUseFiles = true;

bool downloadText(String fileName, String text) {
  try {
    final blob = web.Blob(
      [text.toJS].toJS,
      web.BlobPropertyBag(type: 'application/json'),
    );
    final url = web.URL.createObjectURL(blob);
    final a = web.HTMLAnchorElement()
      ..href = url
      ..download = fileName
      ..style.display = 'none';
    web.document.body?.append(a);
    a.click();
    a.remove();
    Timer(const Duration(seconds: 2), () => web.URL.revokeObjectURL(url));
    return true;
  } catch (_) {
    return false;
  }
}

Future<String?> pickTextFile() {
  final done = Completer<String?>();
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = '.json,application/json';
  input.addEventListener(
    'change',
    ((web.Event _) {
      final file = input.files?.item(0);
      if (file == null) {
        done.complete(null);
        return;
      }
      file.text().toDart.then(
        (t) => done.complete(t.toDart),
        onError: (_) => done.complete(null),
      );
    }).toJS,
  );
  input.click();
  return done.future;
}
