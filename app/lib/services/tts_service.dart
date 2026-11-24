import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

import '../core/lang/lang.dart';
import 'audio/audio_player.dart' as audio;
import 'human_voice.dart';

/// Speech in German, Dutch or Spanish.
///
/// Words play a real recording by a native speaker when one exists (see
/// [HumanVoice]); everything else uses the most natural text-to-speech voice
/// the device has (neural/online voices first).
class TtsService {
  TtsService({HumanVoice? human}) : _human = human ?? HumanVoice() {
    _ready = _init();
  }

  final _tts = FlutterTts();
  final HumanVoice _human;
  late final Future<void> _ready;

  /// Learner's choice: try native-speaker recordings first.
  bool humanVoice = true;

  Lang? _voice;

  Future<void> _init() async {
    await _tts.awaitSpeakCompletion(true);
    await _tts.setPitch(1.0);
  }

  /// Plays a native-speaker recording of [text] if there is one.
  Future<bool> playHuman(String text, Lang lang) async {
    if (!humanVoice || !audio.canPlay) return false;
    final url = await _human.find(text, lang);
    if (url == null) return false;
    return audio.playUrl(url);
  }

  Future<void> speak(
    String text, {
    Lang lang = Lang.de,
    bool slow = false,
  }) async {
    await _ready;
    await stop();
    if (!slow && await playHuman(text, lang)) return;
    if (_voice != lang) {
      await _tts.setLanguage(lang.tts);
      await _pickNaturalVoice(lang);
      _voice = lang;
    }
    // The web engine's normal rate is 1.0; mobile engines use 0.5.
    await _tts.setSpeechRate(
      kIsWeb ? (slow ? 0.65 : 0.92) : (slow ? 0.3 : 0.45),
    );
    await _tts.speak(text);
  }

  Future<void> _pickNaturalVoice(Lang lang) async {
    try {
      final voices = (await _tts.getVoices as List?) ?? const [];
      final code = lang.tts.toLowerCase();
      final base = code.split('-').first;
      Map? best;
      var bestScore = -1;
      for (final v in voices.whereType<Map>()) {
        final locale = '${v['locale'] ?? ''}'.toLowerCase().replaceAll(
          '_',
          '-',
        );
        if (!locale.startsWith(base)) continue;
        final score =
            voiceScore('${v['name'] ?? ''}') + (locale == code ? 1 : 0);
        if (score > bestScore) {
          best = v;
          bestScore = score;
        }
      }
      if (best != null) {
        await _tts.setVoice({
          'name': '${best['name']}',
          'locale': '${best['locale']}',
        });
      }
    } catch (_) {
      // Keep the engine's default voice.
    }
  }

  /// How human a voice sounds, judged by its name: neural and online voices
  /// (Edge "Natural", Google, Apple premium) beat the old offline ones.
  static int voiceScore(String name) {
    final n = name.toLowerCase();
    var s = 0;
    if (n.contains('natural') || n.contains('neural')) s += 8;
    if (n.contains('premium') || n.contains('enhanced')) s += 6;
    if (n.contains('online')) s += 4;
    if (n.contains('google')) s += 3;
    if (n.contains('siri')) s += 3;
    if (n.contains('compact') || n.contains('espeak')) s -= 5;
    return s;
  }

  Future<void> stop() async {
    audio.stopAudio();
    await _tts.stop();
  }
}
