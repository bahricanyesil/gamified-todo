import 'package:flutter/material.dart';
import '../../decoration/text_styles.dart';

/// Base text with custom parameters
/// Wraps [Text] with [FittedBox], and implements some stylings.
class BaseText extends StatelessWidget {
  /// Default constructor for [BaseText].
  const BaseText(
    this.text, {
    this.style,
    this.textAlign = TextAlign.center,
    this.color,
    this.fit,
    this.fontSizeFactor,
    this.fontWeight,
    this.maxLength = 90000000,
    Key? key,
  }) : super(key: key);

  /// Text that will be displayed.
  final String text;

  /// Custom optional style for text.
  final TextStyle? style;

  /// Alignment of the text. It is [TextAlign.center] as default.
  final TextAlign textAlign;

  /// Custom color for the text.
  final Color? color;

  /// Custom box fit option for [FittedBox], default is [BoxFit.scaleDown].
  final BoxFit? fit;

  /// Custom font size factor.
  final double? fontSizeFactor;

  /// Custom font weight.
  final FontWeight? fontWeight;

  /// Maximum length for the task.
  final int maxLength;

  @override
  Widget build(BuildContext context) => FittedBox(
        fit: fit ?? BoxFit.scaleDown,
        child: Text(
          _text,
          style: _style(context),
          textAlign: textAlign,
          overflow: TextOverflow.clip,
        ),
      );

  String get _text =>
      text.length > maxLength ? text.substring(0, maxLength) : text;

  TextStyle _style(BuildContext context) =>
      style ??
      TextStyles(context)
          .normalStyle(
            color: color,
            fontSizeFactor: fontSizeFactor,
            fontWeight: fontWeight,
          )
          .merge(style);
}
