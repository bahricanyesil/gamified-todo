import 'package:flutter/material.dart';

import '../../../core/decoration/button/button_styles.dart';
import '../../../core/extensions/extensions_shelf.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../constants/constants_shelf.dart';
import '../../decoration/text_styles.dart';
import '../../theme/color/l_colors.dart';

/// Customized dropdown button to open a choose dialog.
class CustomDropdownButton<T> extends StatelessWidget {
  /// Default constructor for [DropdownButton].
  CustomDropdownButton({
    required this.title,
    required this.values,
    required this.initialValues,
    required this.callback,
    this.type = ChooseDialogTypes.single,
    this.autoSize = true,
    this.buttonWidth,
    Key? key,
  })  : assert(
            initialValues.isNotEmpty, 'Initial values list cannot be empty.'),
        super(key: key);

  /// Title to show in the dialog.
  final String title;

  /// All possible values for the dialog.
  final List<T> values;

  /// Initial selected value.
  final List<T> initialValues;

  /// Callback to call on value choose.
  final Function(List<T> val) callback;

  /// Type of the choose dialog.
  final ChooseDialogTypes type;

  /// Determines whether to autosize the text inside the button.
  final bool autoSize;

  /// Width of the button.
  final double? buttonWidth;

  @override
  Widget build(BuildContext context) {
    final String value = _getInitialValue(initialValues[0]);
    return ElevatedButton(
      style: ButtonStyles(context).roundedStyle(
        padding: context.horizontalPadding(Sizes.med),
        size: Size(
          buttonWidth ?? context.responsiveSize * 45,
          context.responsiveSize * 18,
        ),
      ),
      onPressed: () async => _onPressed(context),
      child: autoSize
          ? BaseText(value)
          : Text(
              value.hyphenate,
              overflow: TextOverflow.ellipsis,
              style: TextStyles(context).normalStyle(color: AppColors.white),
            ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    if (type == ChooseDialogTypes.single) {
      await DialogBuilder(context)
          .singleSelectDialog(title, values, initialValues[0])
          .then((T? val) => callback(<T>[if (val != null) val]));
    } else {
      await DialogBuilder(context)
          .multipleSelectDialog(title, values, initialValues)
          .then(callback);
    }
  }

  String _getInitialValue(T initialValue) {
    if (initialValue is Enum) {
      return initialValue.name.capitalize;
    } else if (initialValue is String) {
      return initialValue;
    } else {
      return initialValue.toString();
    }
  }
}
