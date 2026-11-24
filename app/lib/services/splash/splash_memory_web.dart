import 'dart:ui' show Color;

import 'package:web/web.dart' as web;

String? _last;

String _hex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

/// Stores "base,blobA,blobB" in localStorage under `3lang-splash`.
void rememberSplash(Color base, Color a, Color b) {
  final v = '${_hex(base)},${_hex(a)},${_hex(b)}';
  if (v == _last) return;
  _last = v;
  try {
    web.window.localStorage.setItem('3lang-splash', v);
  } catch (_) {}
}
