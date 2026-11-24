import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:three_lang/core/responsive.dart';
import 'package:three_lang/features/contrast/contrast_screen.dart';
import 'package:three_lang/features/course/course_screen.dart';
import 'package:three_lang/features/course/unit_screen.dart';
import 'package:three_lang/features/onboarding/welcome_screen.dart';
import 'package:three_lang/features/practice/practice_screen.dart';
import 'package:three_lang/features/progress/progress_screen.dart';
import 'package:three_lang/features/settings/settings_screen.dart';
import 'package:three_lang/features/today/today_screen.dart';

import 'screens_test.dart' show pumpScreen;

/// Every main screen must lay out without overflow from a small phone to a
/// desktop window, in Arabic (right to left) and English.
void main() {
  const sizes = {
    'small phone': Size(320, 640),
    'phone': Size(390, 844),
    'tablet': Size(820, 1180),
    'desktop': Size(1440, 900),
  };
  final screens = <String, Widget Function()>{
    'today': () => const TodayScreen(),
    'course': () => const CourseScreen(),
    'unit': () => const UnitScreen(unitId: 'de.a1.u05'),
    'practice': () => const PracticeScreen(),
    'progress': () => const ProgressScreen(),
    'contrast': () => const ContrastScreen(),
    'settings': () => const SettingsScreen(),
    'welcome': () => const WelcomeScreen(),
  };
  for (final locale in const [Locale('ar'), Locale('en')]) {
    for (final MapEntry(key: sizeName, value: size) in sizes.entries) {
      testWidgets('${locale.languageCode} $sizeName: no overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        for (final MapEntry(key: name, value: build) in screens.entries) {
          await pumpScreen(tester, ResponsiveFrame(child: build()), locale: locale);
          expect(tester.takeException(), isNull, reason: '$name at $sizeName');
        }
      });
    }
  }

  test('size classes follow the Material breakpoints', () {
    expect(SizeClass.fromWidth(390), SizeClass.compact);
    expect(SizeClass.fromWidth(820), SizeClass.medium);
    expect(SizeClass.fromWidth(1440), SizeClass.expanded);
  });
}
