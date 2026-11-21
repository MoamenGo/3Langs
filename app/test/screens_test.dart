import 'package:flutter/services.dart' show PlatformAssetBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:three_lang/core/localization.dart';
import 'package:three_lang/core/providers.dart';
import 'package:three_lang/data/local/local_db.dart';
import 'package:three_lang/data/repositories/content_repository.dart';
import 'package:three_lang/features/course/course_screen.dart';
import 'package:three_lang/features/home/home_screen.dart';
import 'package:three_lang/features/progress/progress_screen.dart';
import 'package:three_lang/l10n/app_localizations.dart';

Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  Locale? locale,
}) async {
  final db = await tester.runAsync(LocalDb.memory);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        localDbProvider.overrideWithValue(db!),
        // A fresh bundle per test: rootBundle caches futures across tests.
        contentRepositoryProvider.overrideWithValue(
          ContentRepository(PlatformAssetBundle()),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: screen,
      ),
    ),
  );
  for (var i = 0; i < 20; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(db.db.close);
    await tester.pump(const Duration(seconds: 1));
  });
}

void main() {
  testWidgets('course screen shows the 2-year path', (tester) async {
    await pumpScreen(tester, const CourseScreen());
    expect(tester.takeException(), isNull);
    expect(find.text('A1 Beginner'), findsOneWidget);
    expect(find.textContaining('Greetings and introductions'), findsOneWidget);
  });

  testWidgets('course screen works in Dutch', (tester) async {
    await pumpScreen(tester, const CourseScreen(), locale: const Locale('nl'));
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Maanden'), findsWidgets);
  });

  testWidgets('home screen shows the next lesson', (tester) async {
    await pumpScreen(tester, const HomeScreen());
    expect(tester.takeException(), isNull);
    expect(find.text('Hello and goodbye'), findsOneWidget);
  });

  testWidgets('progress screen renders with no data', (tester) async {
    await pumpScreen(tester, const ProgressScreen());
    expect(tester.takeException(), isNull);
  });
}
