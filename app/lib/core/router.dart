import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/auth/sign_in_screen.dart';
import '../features/contrast/contrast_screen.dart';
import '../features/course/course_screen.dart';
import '../features/course/lesson_screen.dart';
import '../features/course/unit_screen.dart';
import '../features/flashcards/review_screen.dart';
import '../features/contrast/contrast_drill_screen.dart';
import '../features/listening/listening_screen.dart';
import '../features/onboarding/first_run_screen.dart';
import '../features/onboarding/placement_screen.dart';
import '../features/onboarding/welcome_screen.dart';
import '../features/polyglot/dictionary_screen.dart';
import '../features/polyglot/hub_screen.dart';
import '../features/polyglot/notebook_screen.dart';
import '../features/polyglot/resources_screen.dart';
import '../features/today/today_screen.dart';
import 'lang/lang.dart';
import '../features/practice/practice_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/reading/reading_screen.dart';
import '../features/settings/about_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/speaking/speaking_screen.dart';
import '../features/writing/writing_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  // A new install starts by choosing its languages.
  redirect: (_, s) =>
      FirstRun.done ||
          s.matchedLocation == '/start' ||
          s.matchedLocation == '/welcome' ||
          s.matchedLocation.startsWith('/placement')
      ? null
      : '/start',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        // Polyglot Matrix hub: the default landing view.
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (_, _) => const MatrixHubScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/today', builder: (_, _) => const TodayScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/course',
              builder: (_, _) => const CourseScreen(),
              routes: [
                GoRoute(
                  path: 'unit/:unitId',
                  builder: (_, s) =>
                      UnitScreen(unitId: s.pathParameters['unitId']!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/practice',
              builder: (_, _) => const PracticeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              builder: (_, _) => const ProgressScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notebook',
              builder: (_, _) => const NotebookScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dictionary',
              builder: (_, s) => DictionaryScreen(
                query: s.uri.queryParameters['q'],
                group: s.uri.queryParameters['group'],
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/resources',
              builder: (_, _) => const ResourcesScreen(),
            ),
          ],
        ),
      ],
    ),
    // Full-screen study routes (no bottom bar, to keep focus).
    GoRoute(
      path: '/lesson/:lessonId',
      builder: (_, s) => LessonScreen(lessonId: s.pathParameters['lessonId']!),
    ),
    GoRoute(
      path: '/review',
      builder: (_, s) =>
          ReviewScreen(lang: Lang.tryParse(s.uri.queryParameters['lang'])),
      routes: [
        GoRoute(
          path: 'contrast',
          builder: (_, _) => const ContrastDrillScreen(),
        ),
      ],
    ),
    GoRoute(path: '/start', builder: (_, _) => const FirstRunScreen()),
    GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
    GoRoute(
      path: '/placement/:lang',
      builder: (_, s) => PlacementScreen(
        lang: Lang.tryParse(s.pathParameters['lang']) ?? Lang.de,
      ),
    ),
    GoRoute(
      path: '/practice/listening',
      builder: (_, _) => const ListeningScreen(),
    ),
    GoRoute(
      path: '/practice/reading',
      builder: (_, _) => const ReadingListScreen(),
      routes: [
        GoRoute(
          path: ':textId',
          builder: (_, s) => ReadingScreen(textId: s.pathParameters['textId']!),
        ),
      ],
    ),
    GoRoute(
      path: '/practice/writing',
      builder: (_, _) => const WritingScreen(),
    ),
    GoRoute(
      path: '/practice/speaking',
      builder: (_, _) => const SpeakingScreen(),
    ),
    GoRoute(
      path: '/practice/contrast',
      builder: (_, _) => const ContrastScreen(),
    ),
    GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
    GoRoute(path: '/settings/about', builder: (_, _) => const AboutScreen()),
    GoRoute(path: '/sign-in', builder: (_, _) => const SignInScreen()),
  ],
  errorBuilder: (_, s) => Scaffold(body: Center(child: Text('${s.error}'))),
);
