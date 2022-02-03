import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gamified_todo/core/constants/border/border_radii.dart';
import 'package:gamified_todo/core/extensions/context/responsiveness_extensions.dart';
import 'package:gamified_todo/core/theme/color/l_colors.dart';
import '../../../constants/durations/durations.dart';

part 'focused_menu_item_model.dart';
part 'focused_menu_details.dart';

/// Customized focused menu.
/// Implemented according to the implementation of:
/// https://pub.dev/packages/focused_menu
class FocusedMenu extends StatefulWidget {
  /// Default constructor of [FocusedMenu].
  const FocusedMenu({
    required this.child,
    required this.onPressed,
    required this.menuItems,
    this.duration,
    this.menuBoxDecoration,
    this.menuItemExtent,
    this.animateMenuItems,
    this.blurSize,
    this.blurBackgroundColor,
    this.menuWidth,
    this.bottomOffsetHeight,
    this.menuOffset,
    this.openWithTap = false,
    Key? key,
  }) : super(key: key);

  /// Child to show that will be tappable.
  final Widget child;
  final double? menuItemExtent;
  final double? menuWidth;
  final List<FocusedMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final VoidCallback onPressed;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final bool openWithTap;

  @override
  _FocusedMenuState createState() => _FocusedMenuState();
}

class _FocusedMenuState extends State<FocusedMenu> {
  final GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset.zero;
  late Size childSize = Size.fromHeight(context.height * 5);

  @override
  Widget build(BuildContext context) => GestureDetector(
        key: containerKey,
        onTap: () async {
          widget.onPressed();
          if (widget.openWithTap) await openMenu(context);
        },
        onLongPress: () async {
          if (!widget.openWithTap) await openMenu(context);
        },
        child: widget.child,
      );

  /// Opens the menu.
  Future<void> openMenu(BuildContext context) async {
    _setOffset();
    await Navigator.push(
      context,
      PageRouteBuilder<FadeTransition>(
        transitionDuration: widget.duration ?? Durations.tooFast,
        pageBuilder: _pageBuilder,
        fullscreenDialog: true,
        opaque: false,
      ),
    );
  }

  Widget _pageBuilder(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(animation),
        child: _FocusedMenuDetails(
          itemExtent: widget.menuItemExtent,
          menuBoxDecoration: widget.menuBoxDecoration,
          childOffset: childOffset,
          childSize: childSize,
          menuItems: widget.menuItems,
          blurSize: widget.blurSize,
          menuWidth: widget.menuWidth,
          blurBackgroundColor: widget.blurBackgroundColor,
          animateMenu: widget.animateMenuItems ?? true,
          bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
          menuOffset: widget.menuOffset ?? 0,
          child: widget.child,
        ),
      );

  void _setOffset() {
    final RenderBox? renderBox =
        containerKey.currentContext?.findRenderObject() as RenderBox?;
    final Offset? offset = renderBox?.localToGlobal(Offset.zero);
    if (offset == null && renderBox == null) return;
    setState(() {
      if (offset != null) childOffset = Offset(offset.dx, offset.dy);
      if (renderBox != null) childSize = renderBox.size;
    });
  }
}
