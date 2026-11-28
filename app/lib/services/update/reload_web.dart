import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Fetches the newest app files past the browser cache, then reloads.
Future<void> reloadApp() async {
  for (final f in ['index.html', 'flutter_bootstrap.js', 'main.dart.js']) {
    try {
      await web.window.fetch(f.toJS, web.RequestInit(cache: 'reload')).toDart;
    } catch (_) {}
  }
  web.window.location.reload();
}
