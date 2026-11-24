import 'package:flutter_test/flutter_test.dart';
import 'package:three_lang/services/human_voice.dart';
import 'package:three_lang/services/tts_service.dart';

void main() {
  test('only words and short phrases are looked up', () {
    expect(HumanVoice.candidates('das Haus'), ['das Haus', 'Haus']);
    expect(HumanVoice.candidates('Hallo!'), ['Hallo']);
    expect(HumanVoice.candidates('Ich wohne seit drei Jahren in Berlin.'), isEmpty);
  });

  test('picks the exact Lingua Libre file for the word', () {
    const prefix = 'LL-Q188 (deu)';
    final titles = [
      'File:LL-Q188 (deu)-Speaker-Haustür.wav',
      'File:LL-Q7411 (nld)-Speaker-Haus.wav',
      'File:LL-Q188 (deu)-Sebastian Wallroth-Alfandary-Haus.wav',
      'File:LL-Q188 (deu)-Some One-Haus.wav',
    ];
    expect(HumanVoice.pickFile(titles, prefix, 'Haus'), 'LL-Q188 (deu)-Some One-Haus.wav');
    expect(HumanVoice.pickFile(titles, prefix, 'Baum'), isNull);
  });

  test('neural voices rank above old offline ones', () {
    expect(
      TtsService.voiceScore('Microsoft Katja Online (Natural) - German (Germany)'),
      greaterThan(TtsService.voiceScore('Google Deutsch')),
    );
    expect(TtsService.voiceScore('Google Deutsch'), greaterThan(TtsService.voiceScore('eSpeak German')));
  });
}
