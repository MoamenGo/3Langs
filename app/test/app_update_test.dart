import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:three_lang/features/settings/update_tile.dart';
import 'package:three_lang/services/update/app_update.dart';

void main() {
  test('reads the build number and APK link from the release', () {
    final latest = parseRelease({
      'body': 'Built from abc123 (build 12).\n',
      'assets': [
        {
          'name': '3Lang.apk',
          'browser_download_url': 'https://github.com/MoamenGo/3Langs/releases/download/android-latest/3Lang.apk',
          'updated_at': '2026-11-25T06:00:00Z',
        },
      ],
    })!;
    expect(latest.build, 12);
    expect(latest.apkUrl.path, endsWith('/3Lang.apk'));
    // Local and test builds are build 0, so any published build is newer.
    expect(latest.isNewer, isTrue);
    expect(parseRelease({'body': 'no number', 'assets': []}), isNull);
  });

  testWidgets('the update dialog offers to install over the app', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (c) => TextButton(
            onPressed: () => showUpdateDialog(
              c,
              LatestBuild(build: 9, apkUrl: Uri.parse('https://x/3Lang.apk')),
            ),
            child: const Text('go'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('install-update')), findsOneWidget);
    expect(find.textContaining('Build 9'), findsOneWidget);
  });
}
