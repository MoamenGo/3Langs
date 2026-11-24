import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:three_lang/data/models/content.dart';
import 'package:three_lang/features/course/exercises.dart';

import 'screens_test.dart' show pumpScreen;

const _ex = [
  GrammarExercise(type: 'fill', prompt: 'Ich ___ Anna.', answer: 'heiße'),
];

void main() {
  testWidgets('a wrong answer can be tried again; only the first try counts',
      (tester) async {
    double? score;
    await pumpScreen(
      tester,
      Scaffold(
        body: FillBlankRunner(exercises: _ex, onDone: (s) => score = s),
      ),
      locale: const Locale('en'),
    );
    await tester.enterText(find.byType(TextField), 'heisst');
    await tester.tap(find.text('Check'));
    await tester.pump();
    expect(find.text('Not quite. Try again, or see the answer.'), findsOneWidget);
    expect(find.textContaining('heiße'), findsNothing);

    await tester.tap(find.byKey(const Key('try-again')));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'heiße');
    await tester.tap(find.text('Check'));
    await tester.pump();
    expect(find.text('Correct!'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(score, 0);
  });

  testWidgets('show answer reveals it; exams skip the retry step',
      (tester) async {
    await pumpScreen(
      tester,
      Scaffold(
        body: Column(
          children: [
            Expanded(child: FillBlankRunner(exercises: _ex, onDone: (_) {})),
            Expanded(
              child: FillBlankRunner(
                exercises: _ex,
                onDone: (_) {},
                allowRetry: false,
              ),
            ),
          ],
        ),
      ),
      locale: const Locale('en'),
    );
    for (final f in find.byType(TextField).evaluate().toList()) {
      await tester.enterText(find.byWidget(f.widget), 'x');
    }
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.text('Check').first);
      await tester.pump();
    }
    // The practice one offers a retry, the exam one shows the answer.
    expect(find.byKey(const Key('try-again')), findsOneWidget);
    expect(find.text('Not quite. Answer: heiße'), findsOneWidget);
    await tester.tap(find.byKey(const Key('show-answer')));
    await tester.pump();
    expect(find.text('Not quite. Answer: heiße'), findsNWidgets(2));
  });
}
