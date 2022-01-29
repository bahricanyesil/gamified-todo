import 'package:flutter/material.dart';
import '../../extensions/color/color_extensions.dart';

import '../../extensions/context/responsiveness_extensions.dart';
import '../../extensions/context/theme_extensions.dart';
import '../icons/base_icon.dart';

/// Customized [IconButton].
class DefaultIconButton extends StatelessWidget {
  /// Default constructor for [DefaultIconButton].
  const DefaultIconButton({
    required this.onPressed,
    required this.icon,
    this.color,
    this.highlightColor,
    this.hoverColor,
    Key? key,
  }) : super(key: key);

  /// Callback to call when on pressed to the button.
  final VoidCallback onPressed;

  /// Icon to represent in the button.
  final IconData icon;

  /// Custom color for the icon.
  final Color? color;

  /// Custom highlightColor for the icon button.
  final Color? highlightColor;

  /// Custom hoverColor for the icon button.
  final Color? hoverColor;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: IconButton(
          icon: BaseIcon(icon, color: color),
          splashRadius: context.responsiveSize * 9,
          padding: EdgeInsets.zero,
          highlightColor: highlightColor ?? context.primaryLightColor.lighten(),
          constraints: const BoxConstraints(),
          iconSize: context.responsiveSize * 9,
          onPressed: onPressed,
          hoverColor: hoverColor ?? context.primaryColor.lighten(.05),
        ),
      );
}
