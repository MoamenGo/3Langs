import 'package:material_ui/material_ui.dart';

import 'lang/lang.dart';

/// The whole app takes the colour of the language on screen, so each
/// language has its own visual context (it helps keep them apart).
ThemeData buildTheme(Brightness brightness, {Lang lang = Lang.de}) {
  final scheme = ColorScheme.fromSeed(
    seedColor: lang.color,
    brightness: brightness,
  );
  return ThemeData(
    colorScheme: scheme,
    fontFamilyFallback: const ['NotoSansArabic'],
    useMaterial3: true,
    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 6),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
