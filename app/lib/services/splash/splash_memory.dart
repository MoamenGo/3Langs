/// Remembers the current theme colours so the web page can paint them
/// before the app has loaded (see `web/index.html`).
library;

export 'splash_memory_stub.dart'
    if (dart.library.js_interop) 'splash_memory_web.dart';
