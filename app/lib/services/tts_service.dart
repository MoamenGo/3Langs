import 'package:flutter_tts/flutter_tts.dart';

import '../core/lang/lang.dart';

/// Speech in German, Dutch or Spanish using the device's own text-to-speech engine (free, offline
/// on most Android phones; uses the browser's voices on the web).
class TtsService {
  TtsService() {
    _ready = _init();
  }

  final _tts = FlutterTts();
  late final Future<void> _ready;

  Lang? _voice;

  Future<void> _init() async {
    await _tts.setSpeechRate(0.45);
    await _tts.awaitSpeakCompletion(true);
  }

  Future<void> speak(
    String text, {
    Lang lang = Lang.de,
    bool slow = false,
  }) async {
    await _ready;
    if (_voice != lang) {
      // Each language has its own voice, one more cue that keeps them apart.
      await _tts.setLanguage(lang.tts);
      _voice = lang;
    }
    await _tts.setSpeechRate(slow ? 0.3 : 0.45);
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();
}
