import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:three_lang/core/responsive.dart';
import 'package:three_lang/features/german_roadmap/german_roadmap.dart';

import 'screens_test.dart' show pumpScreen;

void main() {
  test('the outline matches the site addresses', () {
    final all = [for (final l in pogLevels) ...l.items];
    expect(all.length, 13 + 12 + 3 + 2 + 2);
    expect(all.first.url.toString(), 'https://www.pieceofgerman.com/a1/week-1');
    expect(all.firstWhere((w) => w.number == 0).url.path, '/a1/exam-week');
    expect(all.last.url.path, '/c1/lesson-2');
    expect({for (final w in all) w.id}.length, all.length);
  });

  test('up next starts at the learner level and skips ticked weeks', () {
    expect(nextPogWeek('A0', {})!.id, 'a1.1');
    expect(nextPogWeek('A1', {'a1.1', 'a1.2'})!.id, 'a1.3');
    expect(nextPogWeek('A2', {})!.id, 'a2.1');
    final a1 = {for (final w in pogLevels.first.items) w.id};
    expect(nextPogWeek('A1', a1)!.id, 'a2.1');
    final everything = {
      for (final l in pogLevels)
        for (final w in l.items) w.id,
    };
    expect(nextPogWeek('A1', everything), isNull);
  });

  for (final locale in const [Locale('ar'), Locale('en')]) {
    for (final size in const [Size(320, 640), Size(1440, 900)]) {
      testWidgets('${locale.languageCode} ${size.width}: no overflow', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await pumpScreen(
          tester,
          const ResponsiveFrame(child: GermanRoadmapScreen()),
          locale: locale,
        );
        expect(tester.takeException(), isNull);
        expect(find.byKey(const Key('pog-this-week')), findsOneWidget);
      });
    }
  }

  testWidgets('marking a week done moves up next', (tester) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpScreen(
      tester,
      const GermanRoadmapScreen(),
      locale: const Locale('en'),
    );
    expect(find.text('A1 · Week 1'), findsOneWidget);
    await tester.tap(find.byKey(const Key('pog-mark-next')));
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.text('A1 · Week 2'), findsOneWidget);
  });
}
