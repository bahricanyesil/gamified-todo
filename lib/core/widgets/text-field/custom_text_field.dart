import 'package:flutter/material.dart';

import '../../constants/enums/view-enums/sizes.dart';
import '../../decoration/input_decoration.dart';
import '../../decoration/text_styles.dart';
import '../../extensions/color/color_extensions.dart';
import '../../extensions/context/responsiveness_extensions.dart';
import '../../extensions/context/theme_extensions.dart';
import '../../theme/color/l_colors.dart';

/// Customized text field.
class CustomTextField extends StatelessWidget {
  /// Default constructor for [CustomTextField].
  const CustomTextField({
    required this.controller,
    this.hintText,
    this.padding,
    this.maxLength,
    Key? key,
  }) : super(key: key);

  /// Text editing controller of the text field.
  final TextEditingController controller;

  /// Hint text.
  final String? hintText;

  /// Padding around the text field.
  final EdgeInsets? padding;

  /// Maximum length of the input text.
  final int? maxLength;

  @override
  Widget build(BuildContext context) => Padding(
        padding: context.horizontalPadding(Sizes.medHigh),
        child: TextField(
          controller: controller,
          decoration: InputDeco(context).normalDeco(
            fillColor: context.primaryLightColor.lighten(.15),
            hintText: hintText,
          ),
          style: TextStyles(context).bodyStyle(color: AppColors.black),
          maxLength: maxLength,
          maxLines: null,
        ),
      );
}
