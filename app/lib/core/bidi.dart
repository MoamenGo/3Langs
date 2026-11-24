import 'package:material_ui/material_ui.dart';

final _arabic = RegExp('[؀-ۿݐ-ݿﭐ-﷿ﹰ-﻿]');
final _letter = RegExp(r'[A-Za-zÀ-ɏ]');

/// Direction a piece of text should be laid out in: Arabic text runs right
/// to left, German/Dutch/Spanish/English text left to right. Strings with no
/// letters (numbers, symbols) follow the screen.
TextDirection? autoDir(String text) {
  if (_arabic.hasMatch(text)) return TextDirection.rtl;
  if (_letter.hasMatch(text)) return TextDirection.ltr;
  return null;
}

/// Alignment that keeps text on the reading side of the screen, whatever the
/// text's own direction is.
TextAlign screenAlign(BuildContext context) =>
    Directionality.of(context) == TextDirection.rtl
    ? TextAlign.right
    : TextAlign.left;

/// A [Text] that picks its own direction from its content and lines up with
/// the screen side, so "Das Haus." keeps its full stop at the end inside the
/// Arabic layout.
class BidiText extends StatelessWidget {
  const BidiText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.maxLines,
    this.softWrap,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    final dir = textDirection ?? autoDir(data) ?? Directionality.of(context);
    // Short foreign lines sit on the screen's reading side; a long foreign
    // paragraph keeps its own start edge so it stays easy to read.
    final align =
        textAlign ??
        (dir != Directionality.of(context) && data.length > 90
            ? TextAlign.start
            : screenAlign(context));
    return Text(
      data,
      style: style,
      textDirection: dir,
      textAlign: align,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}
