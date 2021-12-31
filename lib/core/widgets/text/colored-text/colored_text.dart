import 'package:flutter/material.dart';
import '../../../constants/enums/view-enums/text_color.dart';
import '../../../decoration/text_styles.dart';
import '../../../extensions/context/theme_extensions.dart';

/// Partially colored text widget.
class ColoredText extends StatelessWidget {
  /// Default constructor for [ColoredText].
  const ColoredText({
    required this.text,
    this.coloredTexts = const <String>[],
    Key? key,
  }) : super(key: key);

  /// Text itself to display.
  final String text;

  /// List of strings will be colored.
  final List<String> coloredTexts;

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          style: _textStyle(context),
          children: List<TextSpan>.generate(
              _markedTexts.keys.length, (int i) => _textSpan(i, context)),
        ),
      );

  TextSpan _textSpan(int i, BuildContext context) {
    final String el = _markedTexts.keys.elementAt(i);
    return TextSpan(
      text: el,
      style: _markedTexts.values.elementAt(i) == TextColor.black
          ? _textStyle(context)
          : _textStyle(context, color: context.primaryColor),
    );
  }

  Map<String, TextColor> get _markedTexts {
    final List<String> localColored = coloredTexts;
    String tempText = text;
    int coloredIndex =
        localColored.indexWhere((String el) => tempText.contains(el));
    final Map<String, TextColor> mappedText = <String, TextColor>{};
    while (coloredIndex != -1) {
      final int insertIndex = tempText.indexOf(localColored[coloredIndex]);
      final String coloredText = coloredTexts[coloredIndex];
      if (insertIndex != 0) {
        mappedText[tempText.substring(0, insertIndex)] = TextColor.black;
      }
      mappedText[coloredText] = TextColor.primary;
      if (insertIndex + coloredText.length < tempText.length) {
        tempText = tempText.substring(insertIndex + coloredText.length);
      } else {
        return mappedText;
      }
      coloredIndex =
          localColored.indexWhere((String el) => tempText.contains(el));
    }
    mappedText[tempText] = TextColor.black;
    return mappedText;
  }

  TextStyle _textStyle(BuildContext context, {Color? color}) =>
      TextStyles(context).subtitleTextStyle(height: 2, color: color);
}
