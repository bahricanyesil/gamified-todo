import 'package:flutter/material.dart';

import '../../extensions/context/responsiveness_extensions.dart';
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

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: _all<EdgeInsets>(
            EdgeInsets.symmetric(
                horizontal: context.width * 4, vertical: context.height),
          ),
        ),
        child: BaseText(text),
      );

  MaterialStateProperty<T> _all<T>(T value) =>
      MaterialStateProperty.all<T>(value);
}
