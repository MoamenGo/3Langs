// Plays a YouTube playlist or video inside the app, in an embedded frame,
// with a button to open it in YouTube (to download, or for full screen).

import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/bidi.dart';
import '../polyglot/ui.dart' show TrX;
import 'embed_frame.dart';

/// Channels whose page we can play as their uploads playlist.
const _channelUploads = {'@CyberGerman': 'UUfa9eEAxgERe-FvnKnKfxEQ'};

/// The embed URL for a YouTube link, or null when it can't be embedded
/// (searches, channel pages).
Uri? youtubeEmbedUrl(Uri url) {
  final host = url.host.replaceFirst('www.', '').replaceFirst('m.', '');
  String? list;
  String? video;
  if (host == 'youtube.com' || host == 'youtube-nocookie.com') {
    list = url.queryParameters['list'];
    video = url.queryParameters['v'];
    final seg = url.pathSegments;
    if (seg.length == 1 && _channelUploads[seg.first] != null) {
      list = _channelUploads[seg.first];
    }
    if (seg.length >= 2 && (seg.first == 'embed' || seg.first == 'shorts')) {
      video = seg[1] == 'videoseries' ? null : seg[1];
    }
  } else if (host == 'youtu.be' && url.pathSegments.isNotEmpty) {
    video = url.pathSegments.first;
    list = url.queryParameters['list'];
  }
  if (video == null && list == null) return null;
  return Uri.https(
    'www.youtube-nocookie.com',
    '/embed/${video ?? 'videoseries'}',
    {'list': ?list, 'rel': '0', 'modestbranding': '1', 'playsinline': '1'},
  );
}

/// Opens [url] in the in-app player when it can be embedded; returns false
/// when it can't, so the caller can open it another way.
Future<bool> openVideo(BuildContext context, Uri url, {String? title}) async {
  final embed = youtubeEmbedUrl(url);
  if (embed == null) return false;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => VideoScreen(embed: embed, source: url, title: title),
    ),
  );
  return true;
}

class VideoScreen extends StatelessWidget {
  const VideoScreen({
    super.key,
    required this.embed,
    required this.source,
    this.title,
  });
  final Uri embed;
  final Uri source;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final wide = MediaQuery.sizeOf(context).width > 900;
    return Scaffold(
      appBar: AppBar(title: BidiText(title ?? context.tr('Video', 'فيديو'))),
      body: ListView(
        key: const Key('video-screen'),
        padding: EdgeInsets.symmetric(horizontal: wide ? 48 : 16, vertical: 16),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ColoredBox(
                    color: Colors.black,
                    child: EmbedFrame(
                      key: const Key('video-frame'),
                      src: embed,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (embed.queryParameters['list'] != null)
                    BidiText(
                      context.tr(
                        'This is a playlist: use the list button in the player to pick another video.',
                        'دي قائمة فيديوهات: استخدم زرار القائمة اللي في المشغل عشان تختار فيديو تاني.',
                      ),
                      style: t.bodyMedium?.copyWith(color: scheme.outline),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    key: const Key('open-in-youtube'),
                    icon: const Icon(Icons.open_in_new),
                    label: BidiText(
                      context.tr(
                        'Open in YouTube (full screen or download)',
                        'افتح في يوتيوب (شاشة كاملة أو تحميل)',
                      ),
                    ),
                    onPressed: () =>
                        launchUrl(source, mode: LaunchMode.externalApplication),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
