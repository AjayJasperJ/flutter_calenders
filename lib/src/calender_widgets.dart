import 'package:flutter/material.dart';

/// Font enum for text styling
///
/// Use this to specify the font weight for calendar text.
enum Font {
  /// Bold font weight (w700)
  bold(FontWeight.w700),

  /// Medium font weight (w500)
  medium(FontWeight.w500),

  /// Regular font weight (w400)
  regular(FontWeight.w400),

  /// Semi-bold font weight (w600)
  semiBold(FontWeight.w600);

  /// The [FontWeight] value for the font style.
  final FontWeight weight;
  const Font(this.weight);
}

/// Text decoration options for calendar text.
enum Decorate {
  /// Underline decoration
  underline(TextDecoration.underline),

  /// Overline decoration
  overline(TextDecoration.overline),

  /// Line-through decoration
  lineThrough(TextDecoration.lineThrough),

  /// No decoration
  none(TextDecoration.none);

  /// The [TextDecoration] value for the decoration.
  final TextDecoration value;
  const Decorate(this.value);
}

/// Utility widgets for calendar text rendering.
class CalnderWidgets {
  /// Returns a styled [Text] widget for calendar content.
  ///
  /// [content]: The text to display.
  /// [textColor]: The color of the text.
  /// [textSize]: The font size.
  /// [textStype]: The font style (see [Font]).
  /// [textDecoration]: The decoration (see [Decorate]).
  /// [maxLines]: Maximum number of lines.
  /// [textAlign]: Text alignment.
  /// [textBehaviour]: Text overflow behavior.
  /// [textSpacing]: Word spacing.
  /// [textHeight]: Line height.
  /// [fontFamily]: Font family.
  /// [directStyle]: Directly provide a [TextStyle] (overrides other style params).
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
