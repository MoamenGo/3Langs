import 'package:material_ui/material_ui.dart';

import '../../data/models/content.dart';
import '../../l10n/app_localizations.dart';

extension LessonTypeUi on LessonType {
  IconData get icon => switch (this) {
    LessonType.vocab => Icons.translate,
    LessonType.grammar => Icons.rule,
    LessonType.listening => Icons.headphones,
    LessonType.reading => Icons.menu_book,
    LessonType.review => Icons.replay,
    LessonType.exam => Icons.assignment,
  };

  String label(AppLocalizations l) => switch (this) {
    LessonType.vocab => l.lessonVocab,
    LessonType.grammar => l.lessonGrammar,
    LessonType.listening => l.lessonListening,
    LessonType.reading => l.lessonReading,
    LessonType.review => l.lessonReview,
    LessonType.exam => l.lessonExam,
  };
}
