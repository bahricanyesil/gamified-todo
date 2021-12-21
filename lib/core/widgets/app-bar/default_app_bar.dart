import 'package:flutter/material.dart';

/// Default App Bar extends [AppBar]
/// with its required functions.
class DefaultAppBar extends AppBar implements PreferredSizeWidget {
  /// Default app bar constructor.
  DefaultAppBar({
    this.size,
    this.color,
    this.titleW,
    this.leadingW,
    this.titlePadding,
    Key? key,
  }) : super(
          backgroundColor: color,
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: titlePadding,
          title: titleW,
          leading: leadingW,
          key: key,
        );

  /// Size of the app bar.
  final double? size;

  /// Background color of the app bar.
  final Color? color;

  /// Title of the app bar.
  final Widget? titleW;

  /// Leading widget of the app bar.
  final Widget? leadingW;

  /// Horizontal padding for title.
  final double? titlePadding;

  /// Overrides the [preferredSize] field with a given height value [size].
  @override
  Size get preferredSize => Size.fromHeight(size ?? 100);

  /// Copies the given [DefaultAppBar] with the one we have.
  DefaultAppBar copyWithSize(double size) => DefaultAppBar(
        color: color,
        titleW: titleW,
        leadingW: leadingW,
        titlePadding: titleSpacing,
        size: size,
      );
}
