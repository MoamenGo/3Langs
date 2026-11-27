import 'package:material_ui/material_ui.dart';
import 'package:web/web.dart' as web;

/// Plays [src] (a YouTube embed URL) in an iframe inside the page.
class EmbedFrame extends StatelessWidget {
  const EmbedFrame({super.key, required this.src});
  final Uri src;

  @override
  Widget build(BuildContext context) => HtmlElementView.fromTagName(
    key: ValueKey(src),
    tagName: 'iframe',
    onElementCreated: (Object e) {
      final f = e as web.HTMLIFrameElement;
      f.src = src.toString();
      f.style.border = 'none';
      f.style.width = '100%';
      f.style.height = '100%';
      f.allow =
          'accelerometer; autoplay; encrypted-media; gyroscope; '
          'picture-in-picture; fullscreen';
      f.allowFullscreen = true;
      f.referrerPolicy = 'strict-origin-when-cross-origin';
    },
  );
}
