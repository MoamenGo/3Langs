import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:three_lang/core/responsive.dart';
import 'package:three_lang/data/local/local_db.dart';
import 'package:three_lang/features/polyglot/controller.dart';
import 'package:three_lang/features/polyglot/dictionary_screen.dart';
import 'package:three_lang/features/polyglot/hub_screen.dart';
import 'package:three_lang/features/polyglot/models.dart';
import 'package:three_lang/features/polyglot/notebook_screen.dart';
import 'package:three_lang/features/polyglot/planner.dart';
import 'package:three_lang/features/polyglot/resources_screen.dart';
import 'package:three_lang/features/polyglot/storage.dart';

import 'screens_test.dart' show pumpScreen;

ProviderContainer _container([PolyglotStore? store]) {
  final c = ProviderContainer(
    overrides: [
      polyglotStoreProvider.overrideWithValue(store ?? PolyglotStore.memory()),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('sample data', () {
    test('five languages are active and every concept has all six', () {
      final s = seedState(DateTime(2026, 11, 25));
      expect(s.active.length, greaterThanOrEqualTo(4));
      expect(s.active, containsAll(['de', 'en', 'nl', 'es', 'fr']));
      expect(s.concepts.length, greaterThanOrEqualTo(14));
      for (final c in s.concepts) {
        for (final l in ['de', 'en', 'nl', 'es', 'fr', 'ar']) {
          expect(c.lines[l]?.text, isNotEmpty, reason: '${c.id} $l');
          expect(c.lines[l]?.ipa, startsWith('['), reason: '${c.id} $l');
        }
      }
      // Every learning method has at least one concept.
      for (final a in Aspect.values) {
        expect(
          s.concepts.where((c) => c.aspect == a),
          isNotEmpty,
          reason: '$a',
        );
      }
    });

    test('dictionary words link across languages', () {
      final s = seedState();
      final house = s.dictionary.where((d) => d.group == 'c.house');
      expect({
        for (final d in house) d.lang,
      }, containsAll(['de', 'nl', 'es', 'fr', 'en', 'ar']));
    });

    test('resources cover every active language and every format', () {
      final s = seedState();
      for (final l in s.active) {
        expect(
          s.resources.where((r) => r.covers(l) && !r.langs.contains('*')),
          isNotEmpty,
          reason: l,
        );
      }
      for (final f in ResourceFormat.values) {
        expect(
          s.resources.where((r) => r.format == f),
          isNotEmpty,
          reason: '$f',
        );
      }
      for (final r in s.resources) {
        expect(Uri.parse(r.url).isScheme('https'), isTrue, reason: r.url);
      }
    });
  });

  group('planner', () {
    final langs = ['de', 'en', 'nl', 'es', 'fr'];

    test('weights sum to 1 for every strategy', () {
      for (final st in PlanStrategy.values) {
        final w = planWeights(PlanConfig(strategy: st), langs);
        expect(
          w.values.fold<double>(0, (a, b) => a + b),
          closeTo(1, 1e-9),
          reason: '$st',
        );
      }
      final core = planWeights(
        const PlanConfig(strategy: PlanStrategy.coreLight, core: ['de', 'nl']),
        langs,
      );
      expect(core['de']!, greaterThan(core['fr']!));
      final sprint = planWeights(
        const PlanConfig(strategy: PlanStrategy.focusSprint, focus: 'es'),
        langs,
      );
      expect(sprint['es'], 0.5);
    });

    test('a week covers the skills and a daily review', () {
      final tasks = generateWeek(
        const PlanConfig(strategy: PlanStrategy.equal),
        langs,
      );
      for (final l in langs) {
        final skills = {
          for (final t in tasks)
            if (t.lang == l) t.skill,
        };
        expect(skills.length, greaterThanOrEqualTo(5), reason: l);
      }
      final reviews = tasks.where((t) => t.skill == Skill.review);
      expect(reviews.length, 6); // six study days
      // German and Dutch never share a block on the same day.
      for (var d = 0; d < 7; d++) {
        final de = tasks.where((t) => t.day == d && t.lang == 'de');
        final nl = tasks.where((t) => t.day == d && t.lang == 'nl');
        if (de.isNotEmpty && nl.isNotEmpty) {
          expect(de.first.slot, isNot(nl.first.slot), reason: 'day $d');
        }
      }
    });
  });

  group('controller', () {
    test('keeps at least one language and adds custom ones', () {
      final c = _container();
      final ctl = c.read(polyglotProvider.notifier);
      for (final l in [...c.read(polyglotProvider).active]) {
        ctl.toggleLanguage(l);
      }
      expect(c.read(polyglotProvider).active.length, 1);
      ctl.addLanguage(
        const LanguageDef(
          code: 'it',
          name: 'Italian',
          nameAr: 'الإيطالية',
          nativeName: 'Italiano',
          flag: '🇮🇹',
          tts: 'it-IT',
          custom: true,
        ),
      );
      expect(c.read(polyglotProvider).active, contains('it'));
      final concept = c.read(polyglotProvider).concepts.first;
      ctl.setLine(
        concept.id,
        'it',
        const ConceptLine(text: 'La casa è grande.'),
      );
      expect(
        c.read(polyglotProvider).concepts.first.lines['it']!.text,
        'La casa è grande.',
      );
      ctl.removeLanguage('it');
      expect(c.read(polyglotProvider).lang('it'), isNull);
    });

    test('dictionary: save a line once, add linked words, quiz stages', () {
      final c = _container();
      final ctl = c.read(polyglotProvider.notifier);
      final concept = c.read(polyglotProvider).concepts.first;
      expect(ctl.saveLine(concept, 'de'), isTrue);
      expect(ctl.saveLine(concept, 'de'), isFalse);
      ctl.addWordGroup(
        terms: {'de': 'Apfel', 'nl': 'appel', 'es': ''},
        pos: 'noun',
        meaningEn: 'apple',
      );
      final apple = c
          .read(polyglotProvider)
          .dictionary
          .where((d) => d.meaningEn == 'apple')
          .toList();
      expect(apple.length, 2);
      expect(apple[0].group, apple[1].group);
      ctl.quizAnswer(apple[0].id, true);
      ctl.quizAnswer(apple[0].id, true);
      expect(
        c
            .read(polyglotProvider)
            .dictionary
            .firstWhere((d) => d.id == apple[0].id)
            .stage,
        Stage.mastered,
      );
      ctl.quizAnswer(apple[0].id, false);
      expect(
        c
            .read(polyglotProvider)
            .dictionary
            .firstWhere((d) => d.id == apple[0].id)
            .stage,
        Stage.learning,
      );
    });

    test('ticking a task counts toward the goal and the streak', () {
      final c = _container();
      final ctl = c.read(polyglotProvider.notifier);
      final today = ctl.todayIndex;
      final task = c
          .read(polyglotProvider)
          .tasks
          .firstWhere((t) => t.day == today, orElse: () => ctl.newTask(today));
      if (!c.read(polyglotProvider).tasks.contains(task)) ctl.saveTask(task);
      expect(ctl.streak, 0);
      ctl.toggleTask(task.id);
      expect(ctl.todayGoal.$1, task.minutes);
      expect(ctl.streak, 1);
    });

    test('notebook: pin a concept with every active language', () {
      final c = _container();
      final ctl = c.read(polyglotProvider.notifier);
      final concept = c.read(polyglotProvider).concepts[3];
      final n = ctl.pinConcept(concept);
      expect(n.perLang.keys, containsAll(c.read(polyglotProvider).active));
      ctl.deleteNote(n.id);
      expect(c.read(polyglotProvider).notes.any((x) => x.id == n.id), isFalse);
    });

    test('export and import round-trip; bad files are refused', () {
      final c = _container();
      final ctl = c.read(polyglotProvider.notifier);
      ctl.toggleBookmark('r.rfi');
      final json = c.read(polyglotProvider).encode();
      ctl.resetToSample();
      expect(c.read(polyglotProvider).bookmarks.contains('r.rfi'), isFalse);
      ctl.importJson(json);
      expect(c.read(polyglotProvider).bookmarks.contains('r.rfi'), isTrue);
      expect(() => ctl.importJson('{"hello": 1}'), throwsFormatException);
      expect(() => ctl.importJson('not json'), throwsFormatException);
    });

    test('changes are saved and read back on the next start', () async {
      final db = await LocalDb.memory();
      addTearDown(db.db.close);
      final c1 = _container(await PolyglotStore.open(db));
      c1.read(polyglotProvider.notifier).toggleBookmark('r.voa');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final c2 = _container(await PolyglotStore.open(db));
      expect(c2.read(polyglotProvider).bookmarks, contains('r.voa'));
    });
  });

  group('screens', () {
    const sizes = {
      'small phone': Size(320, 640),
      'tablet': Size(820, 1180),
      'desktop': Size(1440, 900),
    };
    final screens = <String, Widget Function()>{
      'hub': () => const MatrixHubScreen(),
      'dictionary': () => const DictionaryScreen(),
      'notebook': () => const NotebookScreen(),
      'resources': () => const ResourcesScreen(),
    };
    for (final locale in const [Locale('ar'), Locale('en')]) {
      for (final MapEntry(key: sizeName, value: size) in sizes.entries) {
        testWidgets('${locale.languageCode} $sizeName: no overflow', (
          tester,
        ) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          for (final MapEntry(key: name, value: build) in screens.entries) {
            await pumpScreen(
              tester,
              ResponsiveFrame(child: build()),
              locale: locale,
            );
            expect(
              tester.takeException(),
              isNull,
              reason: '$name at $sizeName',
            );
          }
        });
      }
    }

    testWidgets('hub: writing mode checks recall, cards save to dictionary', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await pumpScreen(
        tester,
        const MatrixHubScreen(),
        locale: const Locale('en'),
      );
      // Five language cards side by side.
      for (final l in ['de', 'en', 'nl', 'es', 'fr']) {
        expect(find.byKey(Key('line-$l')), findsOneWidget, reason: l);
      }
      await tester.tap(find.byKey(const Key('mode-writing')));
      await tester.pump();
      expect(find.byKey(const Key('line-de')), findsNothing);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(MatrixHubScreen)),
      );
      final s = container.read(polyglotProvider);
      final concept = container
          .read(polyglotProvider.notifier)
          .deck[s.conceptIndex];
      await tester.enterText(
        find.byKey(const Key('recall-de')),
        concept.lines['de']!.text.toLowerCase(),
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.byKey(const Key('line-de')), findsOneWidget);

      await tester.tap(find.byKey(const Key('save-nl')));
      await tester.pump();
      expect(
        container
            .read(polyglotProvider.notifier)
            .inDictionary(concept.id, 'nl'),
        isTrue,
      );

      await tester.tap(find.byKey(const Key('mastery-es')));
      await tester.pump();
      expect(
        container.read(polyglotProvider.notifier).mastery(concept.id, 'es'),
        Stage.learning,
      );
    });

    testWidgets('dictionary search filters across languages', (tester) async {
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await pumpScreen(
        tester,
        const DictionaryScreen(),
        locale: const Locale('en'),
      );
      await tester.enterText(find.byKey(const Key('dict-search')), 'tijd');
      await tester.pump();
      expect(find.byKey(const ValueKey('group-c.time')), findsOneWidget);
      expect(find.byKey(const ValueKey('group-c.house')), findsNothing);
    });
  });
}
