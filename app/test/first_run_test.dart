import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:three_lang/core/lang/lang.dart';
import 'package:three_lang/core/providers.dart';
import 'package:three_lang/core/responsive.dart';
import 'package:three_lang/data/models/learner.dart';
import 'package:three_lang/features/onboarding/first_run_screen.dart';
import 'package:three_lang/features/polyglot/controller.dart';
import 'package:three_lang/features/polyglot/models.dart';

import 'screens_test.dart' show pumpScreen;

void main() {
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
          const ResponsiveFrame(child: FirstRunScreen()),
          locale: locale,
        );
        expect(tester.takeException(), isNull);
        expect(find.byType(FirstRunScreen), findsOneWidget);
      });
    }
  }

  testWidgets('the choice builds the roadmap and switches the course', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    FirstRun.done = false;
    addTearDown(() => FirstRun.done = true);
    await pumpScreen(
      tester,
      const FirstRunScreen(),
      locale: const Locale('en'),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(FirstRunScreen)),
    );
    // A new install starts with nothing picked.
    final finish = find.byKey(const Key('finish-first-run'));
    expect(tester.widget<ButtonStyleButton>(finish).enabled, isFalse);
    for (final code in ['de', 'fr', 'es']) {
      await tester.tap(find.byKey(Key('pick-$code')));
      await tester.pump();
    }
    await tester.tap(find.byKey(const Key('level-de-A2')));
    await tester.tap(find.byKey(const Key('strategy-equal')));
    await tester.pump();
    await tester.tap(finish);
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }

    final s = container.read(polyglotProvider);
    expect(s.active, ['de', 'fr', 'es']);
    expect(s.lang('de')!.level, 'A2');
    expect(s.plan.strategy, PlanStrategy.equal);
    expect({for (final t in s.tasks) t.lang}, containsAll(['de', 'fr', 'es']));
    expect(s.tasks.where((t) => t.lang == 'nl'), isEmpty);

    final tracks = await tester.runAsync(
      () => container.read(trackRepositoryProvider).all(),
    );
    expect(tracks![Lang.de]!.status, TrackStatus.active);
    expect(tracks[Lang.de]!.currentLevel, 'A2');
    expect(tracks[Lang.es]!.status, TrackStatus.active);
    expect(tracks[Lang.nl]!.status, TrackStatus.paused);
    expect(FirstRun.done, isTrue);
    final onboarded = await tester.runAsync(
      () => container.read(localDbProvider).getMeta<bool>('onboarded'),
    );
    expect(onboarded, isTrue);
  });
}
