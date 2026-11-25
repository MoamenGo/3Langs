import 'package:material_ui/material_ui.dart';

/// Screen-size classes, from Material 3's window size classes.
enum SizeClass {
  compact, // phones
  medium, // tablets, folded foldables, small windows
  expanded; // laptops and desktops

  static SizeClass of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  static SizeClass fromWidth(double w) => w < 600
      ? SizeClass.compact
      : w < 1000
      ? SizeClass.medium
      : SizeClass.expanded;
}

/// Wraps the whole app: keeps lines readable on very wide screens, caps
/// extreme text sizes so layouts hold, and tightens the app bar on phones.
class ResponsiveFrame extends StatelessWidget {
  const ResponsiveFrame({super.key, required this.child});
  final Widget child;

  /// Widest the app gets; the background still fills the window.
  static const maxWidth = 1440.0;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final compact = mq.size.width < 600;
    final theme = Theme.of(context);
    Widget body = MediaQuery(
      data: mq.copyWith(
        textScaler: mq.textScaler.clamp(
          minScaleFactor: 0.85,
          maxScaleFactor: 1.4,
        ),
      ),
      child: child,
    );
    if (compact) {
      body = Theme(
        data: theme.copyWith(
          appBarTheme: theme.appBarTheme.copyWith(
            titleSpacing: 12,
            titleTextStyle: theme.appBarTheme.titleTextStyle?.copyWith(
              fontSize: 18,
            ),
          ),
        ),
        child: body,
      );
    }
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: body,
      ),
    );
  }
}

/// Lays [children] out in equal columns: as many as fit at [minItemWidth],
/// at most [maxColumns].
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 160,
    this.maxColumns = 4,
    this.spacing = 12,
  });
  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;
  final double spacing;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final cols = ((c.maxWidth + spacing) / (minItemWidth + spacing))
          .floor()
          .clamp(1, maxColumns);
      final w = (c.maxWidth - spacing * (cols - 1)) / cols;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final child in children) SizedBox(width: w, child: child),
        ],
      );
    },
  );
}
