// "Check for updates": compares this build with the newest Android build
// published on GitHub (release `android-latest`) and installs it over the
// app, keeping all data. On the web it reloads the newest version.

import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'reload_stub.dart' if (dart.library.js_interop) 'reload_web.dart';

/// Build number baked in by CI (`--dart-define=BUILD_NUMBER=...`); 0 for
/// local builds.
const currentBuild = int.fromEnvironment('BUILD_NUMBER');

const _release =
    'https://api.github.com/repos/MoamenGo/3Langs/releases/tags/android-latest';

class LatestBuild {
  const LatestBuild({required this.build, required this.apkUrl, this.date});
  final int build;
  final Uri apkUrl;
  final DateTime? date;

  bool get isNewer => build > currentBuild;
}

/// Reads "(build N)" and the APK link from the release notes.
LatestBuild? parseRelease(Map<String, dynamic> json) {
  final body = '${json['body'] ?? ''}';
  final m = RegExp(r'build (\d+)').firstMatch(body);
  final assets = (json['assets'] as List? ?? const [])
      .cast<Map<String, dynamic>>();
  final apk = assets.where((a) => '${a['name']}'.endsWith('.apk')).firstOrNull;
  if (m == null || apk == null) return null;
  return LatestBuild(
    build: int.parse(m.group(1)!),
    apkUrl: Uri.parse('${apk['browser_download_url']}'),
    date: DateTime.tryParse('${apk['updated_at'] ?? ''}'),
  );
}

Future<LatestBuild?> fetchLatestBuild({http.Client? client}) async {
  final c = client ?? http.Client();
  try {
    final r = await c
        .get(
          Uri.parse(_release),
          headers: {'Accept': 'application/vnd.github+json'},
        )
        .timeout(const Duration(seconds: 15));
    if (r.statusCode != 200) return null;
    return parseRelease(jsonDecode(r.body) as Map<String, dynamic>);
  } catch (_) {
    return null;
  } finally {
    if (client == null) c.close();
  }
}

/// Android: downloads the new APK; opening it installs it over this app.
/// Web: loads the newest version of the site.
Future<void> installUpdate(LatestBuild? latest) async {
  if (kIsWeb) return reloadApp();
  if (latest == null) return;
  await launchUrl(latest.apkUrl, mode: LaunchMode.externalApplication);
}
