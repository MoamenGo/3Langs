import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/widgets.dart';

/// Free practice by skill, outside the lesson path.
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final tiles = [
      (Icons.style, l.flashcards, '/review'),
      (Icons.headphones, l.lessonListening, '/practice/listening'),
      (Icons.menu_book, l.lessonReading, '/practice/reading'),
      (Icons.edit_note, l.lessonWriting, '/practice/writing'),
      (Icons.record_voice_over, l.lessonSpeaking, '/practice/speaking'),
      (Icons.compare_arrows, l.contrastDictionary, '/practice/contrast'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l.navPractice),
        actions: const [LangSwitcher()],
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 220,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          for (final (icon, label, path) in tiles)
            Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.push(path),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(label, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
