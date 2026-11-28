import 'package:flutter_test/flutter_test.dart';
import 'package:three_lang/features/german_roadmap/german_channels.dart';
import 'package:three_lang/features/video/video_screen.dart';

void main() {
  test('playlists, videos and CyberGerman play embedded', () {
    final list = youtubeEmbedUrl(playlistUrl(superEasyGermanList))!;
    expect(list.host, 'www.youtube-nocookie.com');
    expect(list.path, '/embed/videoseries');
    expect(list.queryParameters['list'], superEasyGermanList);

    final video = youtubeEmbedUrl(
      Uri.parse('https://www.youtube.com/watch?v=abc123XYZ_0'),
    )!;
    expect(video.path, '/embed/abc123XYZ_0');

    final short = youtubeEmbedUrl(Uri.parse('https://youtu.be/abc123XYZ_0'))!;
    expect(short.path, '/embed/abc123XYZ_0');

    final cg = youtubeEmbedUrl(cyberGermanChannel)!;
    expect(cg.queryParameters['list'], 'UUfa9eEAxgERe-FvnKnKfxEQ');
  });

  test('searches and other pages are not embedded', () {
    expect(youtubeEmbedUrl(channelSearchUrl('@EasyGerman', 'Perfekt')), isNull);
    expect(youtubeEmbedUrl(easyGermanChannel), isNull);
    expect(
      youtubeEmbedUrl(Uri.parse('https://www.pieceofgerman.com/a1/week-1')),
      isNull,
    );
  });
}
