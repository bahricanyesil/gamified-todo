import 'package:flutter/material.dart';

import '../../../extensions/context/responsiveness_extensions.dart';
import '../../../helpers/material_state_helpers.dart';
import '../../widgets_shelf.dart';

/// Returns an elevated button with both text and icon.
class ElevatedIconTextButton extends StatelessWidget with MaterialStateHelpers {
  /// Default constructor for [ElevatedIconTextButton].
  const ElevatedIconTextButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  /// Callback that will be executed on a button press.
  final VoidCallback onPressed;

  /// Text that will be displayed on the button.
  final String text;

  /// Icon that will be shown at the beginning of the button.
  final IconData icon;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(padding: _padding(context)),
        child: _rowChild(context),
      );

  Widget _rowChild(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BaseIcon(icon),
          context.sizedW(1.6),
          BaseText(text),
        ],
      );

  MaterialStateProperty<EdgeInsets> _padding(BuildContext context) =>
      all<EdgeInsets>(
        EdgeInsets.symmetric(
          horizontal: context.width * 3,
          vertical: context.responsiveSize * 5,
        ),
      );
}
