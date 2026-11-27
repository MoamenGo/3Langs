import 'package:material_ui/material_ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Plays [src] (a YouTube embed URL) in a WebView. The page is loaded with a
/// youtube.com base URL so the player accepts being embedded.
class EmbedFrame extends StatefulWidget {
  const EmbedFrame({super.key, required this.src});
  final Uri src;

  @override
  State<EmbedFrame> createState() => _EmbedFrameState();
}

class _EmbedFrameState extends State<EmbedFrame> {
  late final WebViewController _c = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0xFF000000))
    ..loadHtmlString(_page(widget.src), baseUrl: 'https://www.youtube.com');

  static String _page(Uri src) =>
      '''<!DOCTYPE html><html><head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>html,body{margin:0;height:100%;background:#000}
iframe{border:0;width:100%;height:100%}</style></head><body>
<iframe src="$src" allow="autoplay; encrypted-media; picture-in-picture; fullscreen"
 allowfullscreen referrerpolicy="strict-origin-when-cross-origin"></iframe>
</body></html>''';

  @override
  Widget build(BuildContext context) => WebViewWidget(controller: _c);
}
