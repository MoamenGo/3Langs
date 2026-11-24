import 'dart:ui' show ImageFilter;

import 'package:material_ui/material_ui.dart';

import '../services/splash/splash_memory.dart';
import 'lang/lang.dart';

/// The colour themes a learner can pick. [language] keeps the original
/// behaviour: the app takes the colour of the language on screen, which
/// helps keep the three languages apart.
enum AppTheme {
  language(null, [Color(0xFF6D5DF6), Color(0xFF00B4D8)]),
  aurora(Color(0xFF7C4DFF), [Color(0xFF7C4DFF), Color(0xFF00BFA6)]),
  ocean(Color(0xFF0077B6), [Color(0xFF0077B6), Color(0xFF48CAE4)]),
  sunset(Color(0xFFF2545B), [Color(0xFFFF7E5F), Color(0xFFFEB47B)]),
  forest(Color(0xFF2D6A4F), [Color(0xFF2D6A4F), Color(0xFF95D5B2)]),
  rose(Color(0xFFD6336C), [Color(0xFFF72585), Color(0xFF7209B7)]),
  midnight(Color(0xFF4361EE), [Color(0xFF14213D), Color(0xFF4361EE)]);

  const AppTheme(this.seed, this.gradient);

  /// Seed colour of the scheme; null means "the colour of the language".
  final Color? seed;

  /// The two colours of the glowing background shapes.
  final List<Color> gradient;

  static AppTheme parse(Object? v) =>
      values.firstWhere((t) => t.name == v, orElse: () => AppTheme.aurora);

  static ThemeMode parseMode(Object? v) => ThemeMode.values.firstWhere(
    (m) => m.name == v,
    orElse: () => ThemeMode.system,
  );
}

/// Extra colours for the glass look, read with `Theme.of(context).extension`.
@immutable
class GlassColors extends ThemeExtension<GlassColors> {
  const GlassColors({
    required this.tint,
    required this.border,
    required this.blobA,
    required this.blobB,
    required this.base,
  });

  /// Fill of a glass panel (mostly transparent).
  final Color tint;
  final Color border;
  final Color blobA;
  final Color blobB;

  /// Colour under everything.
  final Color base;

  @override
  GlassColors copyWith({
    Color? tint,
    Color? border,
    Color? blobA,
    Color? blobB,
    Color? base,
  }) => GlassColors(
    tint: tint ?? this.tint,
    border: border ?? this.border,
    blobA: blobA ?? this.blobA,
    blobB: blobB ?? this.blobB,
    base: base ?? this.base,
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
        );
}

ThemeData buildTheme(
  Brightness brightness, {
  Lang lang = Lang.de,
  AppTheme appTheme = AppTheme.aurora,
}) {
  final seed = appTheme.seed ?? lang.color;
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  final blobs = appTheme == AppTheme.language
      ? [lang.color, Color.lerp(lang.color, Colors.white, 0.45)!]
      : appTheme.gradient;
  final glass = GlassColors(
    tint: dark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.white.withValues(alpha: 0.55),
    border: dark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.white.withValues(alpha: 0.75),
    blobA: blobs[0].withValues(alpha: dark ? 0.55 : 0.45),
    blobB: blobs[1].withValues(alpha: dark ? 0.45 : 0.40),
    base: dark
        ? Color.alphaBlend(
            seed.withValues(alpha: 0.10),
            const Color(0xFF0B0D17),
          )
        : Color.alphaBlend(
            seed.withValues(alpha: 0.06),
            const Color(0xFFF7F7FB),
          ),
  );
  final panelShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide(color: glass.border),
  );
  return ThemeData(
    colorScheme: scheme,
    fontFamilyFallback: const ['NotoSansArabic'],
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    canvasColor: dark ? const Color(0xFF151827) : Colors.white,
    extensions: [glass],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: glass.tint,
      surfaceTintColor: Colors.transparent,
      shape: panelShape,
      margin: const EdgeInsets.symmetric(vertical: 6),
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: glass.tint,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      shape: Border(),
      collapsedShape: Border(),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    dividerTheme: DividerThemeData(color: glass.border),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: glass.tint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
  );
}

/// The background of the whole app: a soft base with two glowing shapes
/// that the glass panels blur.
class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final g = Theme.of(context).extension<GlassColors>()!;
    rememberSplash(g.base, g.blobA, g.blobB);
    return ColoredBox(
      color: g.base,
      child: Stack(
        children: [
          Positioned(
            top: -160,
            left: -120,
            child: _Blob(color: g.blobA, size: 520),
          ),
          Positioned(
            bottom: -200,
            right: -140,
            child: _Blob(color: g.blobB, size: 600),
          ),
          Positioned(
            top: 260,
            right: 120,
            child: _Blob(color: g.blobA.withValues(alpha: 0.18), size: 260),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    ),
  );
}

/// A frosted panel: blurs what is behind it.
class Glass extends StatelessWidget {
  const Glass({
    super.key,
    required this.child,
    this.radius = 20,
    this.padding = EdgeInsets.zero,
    this.blur = 18,
    this.color,
  });
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double blur;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final g = Theme.of(context).extension<GlassColors>()!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color ?? g.tint,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: g.border),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
