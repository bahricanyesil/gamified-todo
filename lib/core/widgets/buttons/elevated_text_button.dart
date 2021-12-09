import 'package:flutter/material.dart';
import '../text/base_text.dart';

/// Custom elevated button specific to text widgets.
class ElevatedTextButton extends StatelessWidget {
  /// Default constructor for [ElevatedTextButton].
  const ElevatedTextButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  /// Callback that will be executed on a button press.
  final VoidCallback onPressed;

  /// Text that will be displayed on the button.
  final String text;

  //TODO: Add more customization
  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        child: BaseText(text),
      );
}
