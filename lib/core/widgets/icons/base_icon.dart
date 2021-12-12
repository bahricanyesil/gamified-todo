import 'package:flutter/material.dart';
import '../../extensions/context/responsiveness_extensions.dart';

/// Base icon with custom parameters
/// Wraps [Icon] with [FittedBox], and gives some paddings.
class BaseIcon extends StatelessWidget {
  /// Default constructor for [BaseIcon].
  const BaseIcon(
    this.iconData, {
    this.sizeFactor,
    this.color,
    this.padding,
    Key? key,
  }) : super(key: key);

  /// Icon itself.
  final IconData iconData;

  /// Custom size factor for icon.
  final double? sizeFactor;

  /// Color of the icon.
  final Color? color;

  /// Padding for the icon widget.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: _getPadding(context),
          child: Icon(
            iconData,
            size: sizeFactor != null
                ? (context.responsiveSize * sizeFactor!)
                : null,
            color: color,
          ),
        ),
      );

  EdgeInsets _getPadding(BuildContext context) =>
      padding ?? EdgeInsets.symmetric(horizontal: context.width * .8);
}
