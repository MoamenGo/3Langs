import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/learner.dart';
import 'dictation.dart';

/// Free listening practice: dictation with 10 random sentences from the
/// learner's current level.
class ListeningScreen extends ConsumerWidget {
  const ListeningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(settingsProvider).value?.currentLevel ?? 'A1';
    return StudyTimer(
      activity: Activity.listening,
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.lessonListening)),
        body: AsyncView(
          value: ref.watch(levelContentProvider(level)),
          builder: (c) {
            final sentences = (c.sentences.values.toList()..shuffle())
                .take(10)
                .toList();
            return Padding(
              padding: const EdgeInsets.all(16),
              child: DictationRunner(
                sentences: sentences,
                onDone: (score) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.l10n.scoreLabel((score * 100).round()),
                      ),
                    ),
                  );
                  context.pop();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
