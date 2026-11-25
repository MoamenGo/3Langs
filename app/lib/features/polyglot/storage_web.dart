// Browser localStorage access for the Polyglot Matrix data.

import 'package:web/web.dart' as web;

String? webStorageRead(String key) {
  try {
    return web.window.localStorage.getItem(key);
  } catch (_) {
    return null;
  }
}

bool webStorageWrite(String key, String value) {
  try {
    web.window.localStorage.setItem(key, value);
    return true;
  } catch (_) {
    // Private mode or quota: the caller falls back to the local database.
    return false;
  }
}
