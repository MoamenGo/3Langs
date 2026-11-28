import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:three_lang/core/theme.dart';

void main() {
  test('every theme can be glassy, in light and dark', () {
    for (final t in AppTheme.values) {
      for (final b in Brightness.values) {
        final flat = buildTheme(b, appTheme: t, glass: false);
        // Glass is the default now.
        final glass = buildTheme(b, appTheme: t);
        expect(flat.extension<GlassColors>()!.frosted, isFalse, reason: '$t');
        final g = glass.extension<GlassColors>()!;
        expect(g.frosted, isTrue, reason: '$t $b');
        expect(g.blobA, isNot(g.blobB), reason: '$t $b');
        final mx = glass.extension<MatrixColors>()!;
        expect(mx.surface.a, lessThan(1), reason: '$t $b');
        // The accent colour stays the theme's own.
        expect(mx.primary, flat.extension<MatrixColors>()!.primary);
      }
    }
  });

  test('old saved theme names still load', () {
    expect(AppTheme.parse('matrix'), AppTheme.lagoon);
    expect(AppTheme.parse('rose'), AppTheme.blossom);
    expect(AppTheme.parse('midnight'), AppTheme.ocean);
    expect(AppTheme.parse('nonsense'), AppTheme.lagoon);
  });

  testWidgets('glass panels blur what is behind them', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(Brightness.light, glass: true),
        home: const GlassBackground(
          child: Glass(radius: 12, child: SizedBox(width: 100, height: 60)),
        ),
      ),
    );
    expect(find.byType(BackdropFilter), findsOneWidget);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(Brightness.light, glass: false),
        home: const GlassBackground(
          child: Glass(radius: 12, child: SizedBox(width: 100, height: 60)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsNothing);
  });
}
