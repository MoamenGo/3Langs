import 'package:flutter_tts/flutter_tts.dart';

/// German speech using the device's own text-to-speech engine (free, offline
/// on most Android phones; uses the browser's voices on the web).
class TtsService {
  TtsService() {
    _ready = _init();
  }

  final _tts = FlutterTts();
  late final Future<void> _ready;

  Future<void> _init() async {
    await _tts.setLanguage('de-DE');
    await _tts.setSpeechRate(0.45);
    await _tts.awaitSpeakCompletion(true);
  }

  Future<void> speak(String text, {bool slow = false}) async {
    await _ready;
    await _tts.setSpeechRate(slow ? 0.3 : 0.45);
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();
}
