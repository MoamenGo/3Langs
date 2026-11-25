// The look of the whole app: the "Polyglot Matrix" style (warm editorial
// paper surfaces, fine 1px rules, sage teal and amber accents, Space Grotesk
// headings over Manrope text and JetBrains Mono metadata).
//
// Every colour theme shares this flat paper style; the theme only changes
// the accent colour. Polyglot Matrix (sage teal + amber) is the default.
// Any theme can also be switched to the glass style (frosted translucent
// panels over soft glows in the theme's colours).

import 'dart:ui' show ImageFilter, lerpDouble;

import 'package:material_ui/material_ui.dart';

import '../services/splash/splash_memory.dart';
import 'lang/lang.dart';

/// Fonts bundled in pubspec.yaml. Arabic and IPA symbols fall back to their
/// own fonts so diacritics and phonetic marks never show as boxes.
const kUiFont = 'Manrope';
const kHeadFont = 'SpaceGrotesk';
const kMonoFont = 'JetBrainsMono';
const kFontFallback = ['NotoSansArabic', 'NotoSansIPA'];

/// The colour themes a learner can pick. [language] takes the colour of the
/// language on screen, which helps keep the languages apart.
enum AppTheme {
  matrix(Color(0xFF2A7B76), [Color(0xFF2A7B76), Color(0xFFC87D28)]),
  language(null, [Color(0xFF6D5DF6), Color(0xFF00B4D8)]),
  aurora(Color(0xFF7C4DFF), [Color(0xFF7C4DFF), Color(0xFF00BFA6)]),
  ocean(Color(0xFF0077B6), [Color(0xFF0077B6), Color(0xFF48CAE4)]),
  sunset(Color(0xFFF2545B), [Color(0xFFFF7E5F), Color(0xFFFEB47B)]),
  forest(Color(0xFF2D6A4F), [Color(0xFF2D6A4F), Color(0xFF95D5B2)]),
  rose(Color(0xFFD6336C), [Color(0xFFF72585), Color(0xFF7209B7)]),
  midnight(Color(0xFF4361EE), [Color(0xFF14213D), Color(0xFF4361EE)]);

  const AppTheme(this.seed, this.gradient);

  /// Accent colour; null means "the colour of the language".
  final Color? seed;

  /// Two colours shown on the theme's swatch in Settings.
  final List<Color> gradient;

  static AppTheme parse(Object? v) =>
      values.firstWhere((t) => t.name == v, orElse: () => AppTheme.matrix);

  static ThemeMode parseMode(Object? v) => ThemeMode.values.firstWhere(
    (m) => m.name == v,
    orElse: () => ThemeMode.system,
  );
}

/// The paper palette, read with `Theme.of(context).extension<MatrixColors>()`
/// or the shortcut `context.mx`.
@immutable
class MatrixColors extends ThemeExtension<MatrixColors> {
  const MatrixColors({
    required this.canvas,
    required this.surface,
    required this.surface2,
    required this.ink,
    required this.muted,
    required this.rule,
    required this.primary,
    required this.amber,
  });

  /// Tier 0: the page (warm alabaster).
  final Color canvas;

  /// Tier 1: cards and panels.
  final Color surface;

  /// Tier 2: blocks nested inside cards, inactive chips (cream).
  final Color surface2;

  /// Main text (deep slate charcoal).
  final Color ink;

  /// Secondary text (muted slate).
  final Color muted;

  /// 1px dividers and card borders.
  final Color rule;

  /// Sage teal: focus, active state, primary buttons.
  final Color primary;

  /// Soft amber: highlights, review-due, warnings, stress marks.
  final Color amber;

  static const light = MatrixColors(
    canvas: Color(0xFFF8F7F4),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFF1EFEA),
    ink: Color(0xFF1E242B),
    muted: Color(0xFF5A6572),
    rule: Color(0xFFE3DFD7),
    primary: Color(0xFF2A7B76),
    amber: Color(0xFFC87D28),
  );

  static const dark = MatrixColors(
    canvas: Color(0xFF14181D),
    surface: Color(0xFF1B2026),
    surface2: Color(0xFF232930),
    ink: Color(0xFFE8E5DE),
    muted: Color(0xFF9BA6B2),
    rule: Color(0xFF313840),
    primary: Color(0xFF6CC0B9),
    amber: Color(0xFFE2A55E),
  );

  @override
  MatrixColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surface2,
    Color? ink,
    Color? muted,
    Color? rule,
    Color? primary,
    Color? amber,
  }) => MatrixColors(
    canvas: canvas ?? this.canvas,
    surface: surface ?? this.surface,
    surface2: surface2 ?? this.surface2,
    ink: ink ?? this.ink,
    muted: muted ?? this.muted,
    rule: rule ?? this.rule,
    primary: primary ?? this.primary,
    amber: amber ?? this.amber,
  );

  @override
  MatrixColors lerp(MatrixColors? o, double t) => o == null
      ? this
      : MatrixColors(
          canvas: Color.lerp(canvas, o.canvas, t)!,
          surface: Color.lerp(surface, o.surface, t)!,
          surface2: Color.lerp(surface2, o.surface2, t)!,
          ink: Color.lerp(ink, o.ink, t)!,
          muted: Color.lerp(muted, o.muted, t)!,
          rule: Color.lerp(rule, o.rule, t)!,
          primary: Color.lerp(primary, o.primary, t)!,
          amber: Color.lerp(amber, o.amber, t)!,
        );
}

extension MatrixColorsX on BuildContext {
  MatrixColors get mx =>
      Theme.of(this).extension<MatrixColors>() ?? MatrixColors.light;
}

/// Kept for older widgets: colours of panels and the page.
@immutable
class GlassColors extends ThemeExtension<GlassColors> {
  const GlassColors({
    required this.tint,
    required this.border,
    required this.blobA,
    required this.blobB,
    required this.base,
    this.blur = 0,
  });

  final Color tint;
  final Color border;
  final Color blobA;
  final Color blobB;
  final Color base;

  /// Frosted-glass blur behind panels; 0 is the flat paper look.
  final double blur;

  bool get frosted => blur > 0;

  @override
  GlassColors copyWith({
    Color? tint,
    Color? border,
    Color? blobA,
    Color? blobB,
    Color? base,
    double? blur,
  }) => GlassColors(
    tint: tint ?? this.tint,
    border: border ?? this.border,
    blobA: blobA ?? this.blobA,
    blobB: blobB ?? this.blobB,
    base: base ?? this.base,
    blur: blur ?? this.blur,
  );

  @override
  GlassColors lerp(GlassColors? other, double t) => other == null
      ? this
      : GlassColors(
          tint: Color.lerp(tint, other.tint, t)!,
          border: Color.lerp(border, other.border, t)!,
          blobA: Color.lerp(blobA, other.blobA, t)!,
          blobB: Color.lerp(blobB, other.blobB, t)!,
          base: Color.lerp(base, other.base, t)!,
          blur: lerpDouble(blur, other.blur, t)!,
        );
}

/// Typography from the design: Space Grotesk headings, Manrope body with
/// generous line height (so Arabic tashkeel and IPA diacritics never clip).
TextTheme _textTheme(MatrixColors c) {
  TextStyle head(double size, double height, FontWeight w, double ls) =>
      TextStyle(
        fontFamily: kHeadFont,
        fontFamilyFallback: kFontFallback,
        fontSize: size,
        height: height / size,
        fontWeight: w,
        letterSpacing: ls * size,
        color: c.ink,
      );
  TextStyle body(
    double size,
    double height,
    FontWeight w,
    double ls, [
    Color? color,
  ]) => TextStyle(
    fontFamily: kUiFont,
    fontFamilyFallback: kFontFallback,
    fontSize: size,
    height: height / size,
    fontWeight: w,
    letterSpacing: ls * size,
    color: color ?? c.ink,
  );
  return TextTheme(
    displayLarge: head(40, 52, FontWeight.w600, -0.02),
    displayMedium: head(34, 44, FontWeight.w600, -0.02),
    displaySmall: head(30, 40, FontWeight.w600, -0.015),
    headlineLarge: head(28, 38, FontWeight.w600, -0.015),
    headlineMedium: head(24, 34, FontWeight.w500, -0.01),
    headlineSmall: head(21, 30, FontWeight.w500, -0.01),
    titleLarge: head(19, 28, FontWeight.w600, 0),
    titleMedium: body(15.5, 24, FontWeight.w700, 0.005),
    titleSmall: body(14, 21, FontWeight.w700, 0.01),
    bodyLarge: body(17, 29, FontWeight.w400, 0.01),
    bodyMedium: body(15, 25, FontWeight.w400, 0.012),
    bodySmall: body(13, 21, FontWeight.w400, 0.015, c.muted),
    labelLarge: body(14, 20, FontWeight.w600, 0.02),
    labelMedium: body(12, 17, FontWeight.w600, 0.04),
    labelSmall: body(11, 16, FontWeight.w600, 0.05, c.muted),
  );
}

ThemeData buildTheme(
  Brightness brightness, {
  Lang lang = Lang.de,
  AppTheme appTheme = AppTheme.matrix,
  bool glass = false,
}) {
  final dark = brightness == Brightness.dark;
  final base = dark ? MatrixColors.dark : MatrixColors.light;
  // Other themes keep the paper look and only swap the accent colour.
  final seed = appTheme.seed ?? lang.color;
  final accent = appTheme == AppTheme.matrix
      ? base
      : base.copyWith(
          primary: ColorScheme.fromSeed(
            seedColor: seed,
            brightness: brightness,
          ).primary,
        );
  // Glass: every theme can be frosted. Panels turn translucent over two
  // soft colour glows taken from the theme, with a blur behind them.
  final blobs = appTheme.seed == null
      ? [lang.color, base.amber]
      : appTheme.gradient;
  final c = glass
      ? accent.copyWith(
          canvas: accent.canvas.withValues(alpha: dark ? 0.55 : 0.6),
          surface: accent.surface.withValues(alpha: dark ? 0.38 : 0.55),
          surface2: dark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.white.withValues(alpha: 0.5),
          rule: dark
              ? Colors.white.withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.75),
        )
      : accent;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: c.primary,
        brightness: brightness,
      ).copyWith(
        primary: c.primary,
        onPrimary: dark ? const Color(0xFF0E1A19) : Colors.white,
        primaryContainer: Color.alphaBlend(
          c.primary.withValues(alpha: dark ? 0.22 : 0.12),
          c.surface,
        ),
        onPrimaryContainer: dark ? c.primary : const Color(0xFF00504C),
        secondary: c.amber,
        onSecondary: dark ? const Color(0xFF2D1600) : Colors.white,
        secondaryContainer: Color.alphaBlend(
          c.amber.withValues(alpha: dark ? 0.22 : 0.14),
          c.surface,
        ),
        onSecondaryContainer: dark ? c.amber : const Color(0xFF6A3B00),
        tertiary: c.muted,
        surface: c.surface,
        onSurface: c.ink,
        onSurfaceVariant: c.muted,
        surfaceContainerLowest: c.surface,
        surfaceContainerLow: c.canvas,
        surfaceContainer: c.surface2,
        surfaceContainerHigh: c.surface2,
        surfaceContainerHighest: c.surface2,
        outline: c.muted,
        outlineVariant: c.rule,
        surfaceTint: Colors.transparent,
      );
  final glassColors = glass
      ? GlassColors(
          tint: c.surface,
          border: c.rule,
          base: Color.alphaBlend(
            blobs[0].withValues(alpha: dark ? 0.16 : 0.08),
            base.canvas,
          ),
          blobA: blobs[0].withValues(alpha: dark ? 0.45 : 0.42),
          blobB: blobs[1].withValues(alpha: dark ? 0.40 : 0.38),
          blur: 18,
        )
      : GlassColors(
          tint: c.surface,
          border: c.rule,
          blobA: c.canvas,
          blobB: c.canvas,
          base: c.canvas,
        );
  // Menus and dialogs float above the page: keep them nearly opaque.
  final floating = glass
      ? base.surface.withValues(alpha: dark ? 0.9 : 0.94)
      : c.surface;
  final text = _textTheme(c);
  final rule = BorderSide(color: c.rule);
  RoundedRectangleBorder r(double v, [BorderSide side = BorderSide.none]) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(v),
        side: side,
      );
  const buttonPad = EdgeInsets.symmetric(horizontal: 18, vertical: 14);
  return ThemeData(
    colorScheme: scheme,
    brightness: brightness,
    fontFamily: kUiFont,
    fontFamilyFallback: kFontFallback,
    textTheme: text,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    canvasColor: floating,
    extensions: [glassColors, c],
    splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
    visualDensity: VisualDensity.standard,
    appBarTheme: AppBarTheme(
      backgroundColor: c.canvas,
      foregroundColor: c.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      shape: Border(bottom: rule),
      titleTextStyle: text.titleLarge,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: c.surface,
      surfaceTintColor: Colors.transparent,
      shape: r(8, rule),
      margin: const EdgeInsets.symmetric(vertical: 6),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: c.surface,
      indicatorColor: c.primary.withValues(alpha: 0.12),
      selectedIconTheme: IconThemeData(color: c.primary),
      unselectedIconTheme: IconThemeData(color: c.muted),
      selectedLabelTextStyle: text.labelMedium!.copyWith(color: c.primary),
      unselectedLabelTextStyle: text.labelMedium!.copyWith(color: c.muted),
      indicatorShape: r(6),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: c.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      indicatorColor: c.primary.withValues(alpha: 0.12),
      indicatorShape: r(6),
      height: 68,
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(
          color: s.contains(WidgetState.selected) ? c.primary : c.muted,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => text.labelMedium!.copyWith(
          color: s.contains(WidgetState.selected) ? c.primary : c.muted,
        ),
      ),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      shape: Border(),
      collapsedShape: Border(),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: buttonPad,
        shape: r(4),
        textStyle: text.labelLarge,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: buttonPad,
        shape: r(4),
        elevation: 0,
        backgroundColor: c.surface,
        foregroundColor: c.ink,
        side: rule,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: buttonPad,
        shape: r(4),
        foregroundColor: c.ink,
        backgroundColor: c.surface,
        side: rule,
        textStyle: text.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: r(4),
        foregroundColor: c.primary,
        textStyle: text.labelLarge,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(shape: r(4)),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        shape: r(4),
        side: rule,
        selectedBackgroundColor: c.primary,
        selectedForegroundColor: scheme.onPrimary,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: c.surface2,
      selectedColor: c.primary,
      side: rule,
      shape: r(4, rule),
      labelStyle: text.labelMedium!.copyWith(color: c.ink),
      secondaryLabelStyle: text.labelMedium!.copyWith(color: scheme.onPrimary),
      checkmarkColor: scheme.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: c.primary,
      linearTrackColor: c.surface2,
      circularTrackColor: c.surface2,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: r(3),
      side: BorderSide(color: c.muted),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: c.muted,
      shape: r(6),
      titleTextStyle: text.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
      subtitleTextStyle: text.bodySmall,
    ),
    dividerTheme: DividerThemeData(color: c.rule, space: 1, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surface,
      hintStyle: text.bodyMedium!.copyWith(color: c.muted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: rule,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: rule,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: c.primary, width: 1.5),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: floating,
      surfaceTintColor: Colors.transparent,
      shape: r(12, rule),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: floating,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.ink,
      contentTextStyle: text.bodyMedium!.copyWith(color: c.canvas),
      shape: r(6),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: c.ink,
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: text.labelMedium!.copyWith(color: c.canvas),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: floating,
      surfaceTintColor: Colors.transparent,
      shape: r(8, rule),
    ),
  );
}

/// The background of the whole app: flat warm paper, or soft colour glows
/// under the glass style.
class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final g = Theme.of(context).extension<GlassColors>()!;
    rememberSplash(g.base, g.blobA, g.blobB);
    if (!g.frosted) return ColoredBox(color: g.base, child: child);
    Widget glow(Alignment at, Color color, double radius) => DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: at,
          radius: radius,
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
    return ColoredBox(
      color: g.base,
      child: Stack(
        fit: StackFit.expand,
        children: [
          glow(const Alignment(-0.9, -0.85), g.blobA, 1.1),
          glow(const Alignment(0.95, 0.9), g.blobB, 1.2),
          child,
        ],
      ),
    );
  }
}

/// A Tier 1 panel: white card with a crisp 1px rule (no blur, no shadow).
/// The name is kept from the earlier glass look.
class Glass extends StatelessWidget {
  const Glass({
    super.key,
    required this.child,
    this.radius = 8,
    this.padding = EdgeInsets.zero,
    this.blur = 0,
    this.color,
  });
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;

  /// Ignored; kept so older call sites still compile.
  final double blur;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final g = Theme.of(context).extension<GlassColors>()!;
    final rr = radius == 0 ? 0.0 : radius.clamp(0, 12).toDouble();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? g.tint,
        borderRadius: BorderRadius.circular(rr),
        border: radius == 0
            ? Border(top: BorderSide(color: g.border))
            : Border.all(color: g.border),
      ),
      child: Frosted(
        radius: rr,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Blurs what is behind [child] when the glass style is on; otherwise it
/// only clips to the rounded corners.
class Frosted extends StatelessWidget {
  const Frosted({super.key, required this.child, this.radius = 8});
  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final g = Theme.of(context).extension<GlassColors>();
    final clip = BorderRadius.circular(radius);
    if (g == null || !g.frosted) {
      return ClipRRect(borderRadius: clip, child: child);
    }
    return ClipRRect(
      borderRadius: clip,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: g.blur, sigmaY: g.blur),
        child: child,
      ),
    );
  }
}
