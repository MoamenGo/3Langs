import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show PlatformAssetBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:three_lang/core/lang/lang.dart';
import 'package:three_lang/core/localization.dart';
import 'package:three_lang/core/providers.dart';
import 'package:three_lang/data/local/local_db.dart';
import 'package:three_lang/data/models/content.dart';
import 'package:three_lang/data/models/learner.dart';
import 'package:three_lang/data/repositories/content_repository.dart';
import 'package:three_lang/data/repositories/progress_repository.dart';
import 'package:three_lang/data/repositories/settings_repository.dart';
import 'package:three_lang/features/contrast/contrast_screen.dart';
import 'package:three_lang/features/course/course_screen.dart';
import 'package:three_lang/features/course/exercises.dart';
import 'package:three_lang/features/home/home_screen.dart';
import 'package:three_lang/features/progress/progress_screen.dart';
import 'package:three_lang/l10n/app_localizations.dart';

Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  Locale? locale,
  Future<void> Function(LocalDb db)? setup,
}) async {
  final db = await tester.runAsync(LocalDb.memory);
  if (setup != null) await tester.runAsync(() => setup(db!));
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
    await tester.pump(const Duration(milliseconds: 100));
  }
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(db.db.close);
    await tester.pump(const Duration(seconds: 1));
  });
}

Future<void> useLanguage(LocalDb db, Lang lang, {ExplainLang? explain}) =>
    SettingsRepository(db).save(
      UserSettings(
        updatedAt: DateTime.now().toUtc(),
        activeLanguage: lang,
        explanationLanguage: explain ?? ExplainLang.ar,
      ),
    );

/// Content loads from the asset bundle on real async time; wait for it.
Future<void> pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 50 && finder.evaluate().isEmpty; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('course screen shows the A0 to C1 path in Arabic', (
    tester,
  ) async {
    await pumpScreen(tester, const CourseScreen(), locale: const Locale('ar'));
    await pumpUntilFound(tester, find.textContaining('الأصوات والحروف'));
    expect(tester.takeException(), isNull);
    expect(find.text('طريقك من A0 لـ C1'), findsOneWidget);
    expect(find.text('A1 مبتدئ'), findsOneWidget);
    expect(find.textContaining('الأصوات والحروف'), findsOneWidget);
  });

  testWidgets('explanations can be in English', (tester) async {
    await pumpScreen(
      tester,
      const CourseScreen(),
      locale: const Locale('en'),
      setup: (db) => useLanguage(db, Lang.de, explain: ExplainLang.en),
    );
    await pumpUntilFound(tester, find.textContaining('Sounds and letters'));
    expect(tester.takeException(), isNull);
    expect(find.text('A0 First steps'), findsOneWidget);
    expect(find.textContaining('Sounds and letters'), findsOneWidget);
  });

  testWidgets('home screen starts German at A0', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpScreen(tester, const HomeScreen(), locale: const Locale('ar'));
    await pumpUntilFound(tester, find.text('أصوات اللغة'));
    expect(tester.takeException(), isNull);
    expect(find.text('أصوات اللغة'), findsOneWidget);
    expect(find.byKey(const ValueKey('lang-de')), findsOneWidget);
  });

  testWidgets('Spanish and Dutch have lessons too', (tester) async {
    for (final lang in [Lang.es, Lang.nl]) {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pumpScreen(
        tester,
        const HomeScreen(),
        locale: const Locale('ar'),
        setup: (db) => useLanguage(db, lang),
      );
      await pumpUntilFound(tester, find.text('أصوات اللغة'));
      expect(tester.takeException(), isNull);
      expect(find.text('أصوات اللغة'), findsOneWidget, reason: '$lang');
    }
  });

  testWidgets('after the last A0 lesson, home moves the track to A1', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final a0 = jsonDecode(
      File('assets/content/de/a0.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    await pumpScreen(
      tester,
      const HomeScreen(),
      locale: const Locale('ar'),
      setup: (db) async {
        final progress = ProgressRepository(db);
        for (final lesson in a0['lessons'] as List) {
          await progress.completeLesson(lesson['id'] as String, 1);
        }
      },
    );
    final next = find.byKey(const ValueKey('next-level'));
    await pumpUntilFound(tester, next);
    expect(find.text('خلصت مستوى A0!'), findsOneWidget);
    await tester.tap(next);
    await pumpUntilFound(tester, find.text('أهلًا ومع السلامة'));
    expect(find.text('أهلًا ومع السلامة'), findsOneWidget);
  });

  testWidgets('a word card shows the word in the other two languages', (
    tester,
  ) async {
    final es = jsonDecode(
      File('assets/content/es/a1.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final content = LevelContent.fromJson(es);
    await pumpScreen(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: WordCard(
            item: content.vocab['es.a1.vocab.mesa']!,
            content: content,
          ),
        ),
      ),
      locale: const Locale('ar'),
    );
    await pumpUntilFound(tester, find.text('der Tisch'));
    expect(tester.takeException(), isNull);
    expect(find.text('la mesa'), findsOneWidget);
    expect(find.text('der Tisch'), findsOneWidget);
    expect(find.text('de tafel'), findsOneWidget);
    expect(find.textContaining('الجنس مختلف'), findsOneWidget);
  });

  testWidgets('contrast dictionary lists false friends', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpScreen(
      tester,
      const ContrastScreen(),
      locale: const Locale('en'),
      setup: (db) => useLanguage(db, Lang.de, explain: ExplainLang.en),
    );
    await pumpUntilFound(tester, find.textContaining('Dutch wie = who'));
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Dutch wie = who'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('contrast-gender_mismatch')));
    await tester.pump();
    expect(find.textContaining('Dutch wie = who'), findsNothing);
  });

  testWidgets('progress screen renders with no data', (tester) async {
    await pumpScreen(tester, const ProgressScreen());
    expect(tester.takeException(), isNull);
  });
}
