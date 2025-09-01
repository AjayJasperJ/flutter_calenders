import 'package:flutter/material.dart';

/// Font enum for text styling
enum Font {
  bold(FontWeight.w700),
  medium(FontWeight.w500),
  regular(FontWeight.w400),
  semiBold(FontWeight.w600);

  final FontWeight weight;
  const Font(this.weight);
}

enum Decorate {
  underline(TextDecoration.underline),
  overline(TextDecoration.overline),
  lineThrough(TextDecoration.lineThrough),
  none(TextDecoration.none);

  final TextDecoration value;
  const Decorate(this.value);
}

class CalnderWidgets {
  static Widget calnderText(
    String content, {
    Color? textColor,
    double? textSize,
    Font? textStype,
    Decorate? textDecoration,
    int? maxLines,
    TextAlign? textAlign,
    TextOverflow? textBehaviour,
    double? textSpacing,
    double? textHeight,
    String? fontFamily,
    TextStyle? directStyle,
  }) {
    return Text(
      content,
      style:
          directStyle ??
          TextStyle(
            fontFamily: fontFamily,
            fontSize: textSize,
            height: textHeight,
            decoration: textDecoration?.value,
            color: textColor,
            fontWeight: textStype?.weight,
            wordSpacing: textSpacing,
          ),
      maxLines: maxLines,
      overflow: textBehaviour,
      textAlign: textAlign,
    );
  }
}
