import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

const bool canPlay = true;

web.HTMLAudioElement? _current;

/// Plays [url] and completes when it ends; false if it cannot be played.
Future<bool> playUrl(String url) async {
  stopAudio();
  final audio = web.HTMLAudioElement()..src = url;
  _current = audio;
  final done = Completer<bool>();
  audio.onended = ((web.Event _) {
    if (!done.isCompleted) done.complete(true);
  }).toJS;
  audio.onerror = ((web.Event _) {
    if (!done.isCompleted) done.complete(false);
  }).toJS;
  try {
    await audio.play().toDart;
  } catch (_) {
    return false;
  }
  return done.future.timeout(
    const Duration(seconds: 15),
    onTimeout: () => true,
  );
}

void stopAudio() {
  _current?.pause();
  _current = null;
}
