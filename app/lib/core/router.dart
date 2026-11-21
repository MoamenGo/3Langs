import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/auth/sign_in_screen.dart';
import '../features/course/course_screen.dart';
import '../features/course/lesson_screen.dart';
import '../features/course/unit_screen.dart';
import '../features/flashcards/review_screen.dart';
import '../features/home/home_screen.dart';
import '../features/listening/listening_screen.dart';
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
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/', builder: (_, _) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/course',
              builder: (_, _) => const CourseScreen(),
              routes: [
                GoRoute(
                  path: 'unit/:unitId',
                  builder: (_, s) => UnitScreen(
                    levelId: s.uri.queryParameters['level'] ?? 'A1',
                    unitId: s.pathParameters['unitId']!,
                  ),
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
      ],
    ),
    // Full-screen study routes (no bottom bar, to keep focus).
    GoRoute(
      path: '/lesson/:lessonId',
      builder: (_, s) => LessonScreen(
        levelId: s.uri.queryParameters['level'] ?? 'A1',
        lessonId: s.pathParameters['lessonId']!,
      ),
    ),
    GoRoute(path: '/review', builder: (_, _) => const ReviewScreen()),
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
    GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
    GoRoute(path: '/settings/about', builder: (_, _) => const AboutScreen()),
    GoRoute(path: '/sign-in', builder: (_, _) => const SignInScreen()),
  ],
  errorBuilder: (_, s) => Scaffold(body: Center(child: Text('${s.error}'))),
);
