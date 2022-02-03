part of 'focused_menu.dart';

/// Focused menu item model.
class FocusedMenuItem {
  /// Default constructor for [FocusedMenuItem].
  FocusedMenuItem({
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.trailingIcon,
  });

  /// Title of the item.
  Widget title;

  /// Callback to call on pressed.
  VoidCallback onPressed;

  /// Background color of the item.
  Color? backgroundColor;

  /// Trailing icon.
  Icon? trailingIcon;
}
