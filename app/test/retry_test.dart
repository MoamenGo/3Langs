import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:three_lang/data/models/content.dart';
import 'package:three_lang/features/course/exercises.dart';

import 'screens_test.dart' show pumpScreen;

const _ex = [
  GrammarExercise(type: 'fill', prompt: 'Ich ___ Anna.', answer: 'heiße'),
];

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _pump(WidgetTester tester, Widget runner) =>
    pumpScreen(tester, Scaffold(body: runner), locale: const Locale('en'));

void main() {
  testWidgets('a wrong answer shows a cross; the field stays editable; '
      'only the first try counts', (tester) async {
    double? score;
    await _pump(
      tester,
      FillBlankRunner(exercises: _ex, onDone: (s) => score = s),
    );
    final field = find.byKey(const Key('answer-field'));
    await tester.enterText(field, 'heisst');
    await tester.pump();
    await tester.tap(find.byKey(const Key('check-or-next')));
    await _settle(tester);
    expect(find.byKey(const Key('fb-cross')), findsOneWidget);
    expect(find.textContaining('heiße'), findsNothing);

    await tester.tap(find.byKey(const Key('fb-retry')));
    await _settle(tester);
    expect(find.byKey(const Key('fb-cross')), findsNothing);
    expect(tester.widget<TextField>(field).enabled, isNot(false));

    await tester.enterText(field, 'heiße');
    await tester.pump();
    await tester.tap(find.byKey(const Key('check-or-next')));
    await _settle(tester);
    expect(find.byKey(const Key('fb-tick')), findsOneWidget);
    expect(find.text('Correct!'), findsOneWidget);

    // Even after a right answer the learner can go back and edit.
    await tester.tap(find.byKey(const Key('fb-edit')));
    await _settle(tester);
    expect(tester.widget<TextField>(field).enabled, isNot(false));
    await tester.enterText(field, 'heißen');
    await tester.pump();
    expect(find.text('Check'), findsOneWidget);
    await tester.enterText(field, 'heiße');
    await tester.pump();
    await tester.tap(find.byKey(const Key('check-or-next')));
    await _settle(tester);
    await tester.tap(find.byKey(const Key('fb-next')));
    await _settle(tester);
    expect(score, 0);
  });

  testWidgets('a first-try right answer scores', (tester) async {
    double? score;
    await _pump(
      tester,
      FillBlankRunner(exercises: _ex, onDone: (s) => score = s),
    );
    await tester.enterText(find.byKey(const Key('answer-field')), 'Heiße ');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await _settle(tester);
    expect(find.byKey(const Key('fb-tick')), findsOneWidget);
    await tester.tap(find.byKey(const Key('fb-next')));
    await _settle(tester);
    expect(score, 1);
  });

  testWidgets('show answer reveals it on the page', (tester) async {
    await _pump(tester, FillBlankRunner(exercises: _ex, onDone: (_) {}));
    await tester.enterText(find.byKey(const Key('answer-field')), 'x');
    await tester.pump();
    await tester.tap(find.byKey(const Key('check-or-next')));
    await _settle(tester);
    await tester.tap(find.byKey(const Key('fb-reveal')));
    await _settle(tester);
    expect(find.byKey(const Key('revealed-answer')), findsOneWidget);
    expect(find.text('Not quite. Answer: heiße'), findsOneWidget);
  });

  testWidgets('exams show the answer in the popup straight away', (
    tester,
  ) async {
    await _pump(
      tester,
      FillBlankRunner(exercises: _ex, onDone: (_) {}, allowRetry: false),
    );
    await tester.enterText(find.byKey(const Key('answer-field')), 'x');
    await tester.pump();
    await tester.tap(find.byKey(const Key('check-or-next')));
    await _settle(tester);
    expect(find.byKey(const Key('fb-cross')), findsOneWidget);
    expect(find.byKey(const Key('fb-retry')), findsNothing);
    expect(find.text('Not quite. Answer: heiße'), findsWidgets);
    expect(find.byKey(const Key('fb-next')), findsOneWidget);
  });
}
