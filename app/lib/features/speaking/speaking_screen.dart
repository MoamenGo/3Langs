import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../data/models/learner.dart';

/// Shadowing: hear a sentence, say it aloud, rate yourself.
///
/// Next step: add the `speech_to_text` package (free, uses the device's own
/// recogniser) to compare what was said with the sentence automatically.
class SpeakingScreen extends ConsumerStatefulWidget {
  const SpeakingScreen({super.key});

  @override
  ConsumerState<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends ConsumerState<SpeakingScreen> {
  List<Sentence>? _sentences;
  int _index = 0;
  bool _showTranslation = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = ref.watch(explainLangProvider);
    return StudyTimer(
      activity: Activity.speaking,
      child: Scaffold(
        appBar: AppBar(title: Text(l.lessonSpeaking)),
        body: AsyncView(
          value: ref.watch(activeContentProvider),
          builder: (c) {
            if (c == null) return const NoContentYet();
            _sentences ??= c.sentences.values.toList()..shuffle();
            final s = _sentences![_index % _sentences!.length];
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.speakingIntro, textAlign: TextAlign.center),
                  const Spacer(),
                  Text(
                    s.text,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () =>
                        setState(() => _showTranslation = !_showTranslation),
                    child: Text(
                      _showTranslation
                          ? s.translations.get(lang)
                          : l.showTranslation,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpeakButton(s.text),
                      SpeakButton(s.text, slow: true),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      for (final label in [l.rateHard, l.rateGood, l.rateEasy])
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: OutlinedButton(
                              onPressed: () => setState(() {
                                _index++;
                                _showTranslation = false;
                              }),
                              child: Text(label),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
