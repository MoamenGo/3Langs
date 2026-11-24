/// Plays an audio file from a URL. Only the web build can do this for now;
/// elsewhere [canPlay] is false and callers fall back to text-to-speech.
library;

export 'audio_player_stub.dart'
    if (dart.library.js_interop) 'audio_player_web.dart';
