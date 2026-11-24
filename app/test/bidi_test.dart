import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:three_lang/core/bidi.dart';

void main() {
  test('autoDir picks direction from content', () {
    expect(autoDir('Das Haus.'), TextDirection.ltr);
    expect(autoDir('el niño'), TextDirection.ltr);
    expect(autoDir('البيت'), TextDirection.rtl);
    expect(autoDir('Woche 3 - الأسبوع'), TextDirection.rtl);
    expect(autoDir('12 / 40'), isNull);
  });

  testWidgets('foreign text is LTR and sits on the right in Arabic layout',
      (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.rtl,
        child: BidiText('Das ist ein Haus.'),
      ),
    );
    final text = tester.widget<Text>(find.text('Das ist ein Haus.'));
    expect(text.textDirection, TextDirection.ltr);
    expect(text.textAlign, TextAlign.right);
  });
}
