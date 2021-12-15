import 'package:flutter/material.dart';
import '../../theme/color/l_colors.dart';

/// Text style decoration extensions.
extension TextStyleDecorations on TextStyle {
  /// Underlines the text with a custom style.
  TextStyle underline({double thickness = 2, double yOffset = -4}) {
    final Color mainColor = color ?? AppColors.white;
    return copyWith(
      shadows: <Shadow>[Shadow(color: mainColor, offset: Offset(0, yOffset))],
      color: Colors.transparent,
      decoration: TextDecoration.underline,
      decorationColor: mainColor,
      decorationThickness: thickness,
    );
  }
}