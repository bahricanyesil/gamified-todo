import 'package:flutter/material.dart';
import '../../decoration/text_styles.dart';

/// Base text with custom parameters but not wrapped with [FittedBox].
class NotFittedText extends StatelessWidget {
  /// This is the difference from the "BaseText", it also allows multline texts.
  /// Implements some further customizations.
  const NotFittedText(
    this.text, {
    this.style,
    this.textAlign = TextAlign.center,
    this.maxLines,
    Key? key,
  }) : super(key: key);

  /// Text content.
  final String text;

  /// Custom style for the text.
  final TextStyle? style;

  /// Alignment of the task.
  final TextAlign textAlign;

  /// Maximum liens for the text.
  final int? maxLines;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyles(context).subBodyStyle().merge(style),
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
      );
}
