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

  @override
  Widget build(BuildContext context) => FittedBox(
        fit: fit ?? BoxFit.scaleDown,
        child: Text(
          text,
          style: style ??
              TextStyles(context).normalStyle(color: color).merge(style),
          textAlign: textAlign,
          overflow: TextOverflow.clip,
        ),
      );
}
