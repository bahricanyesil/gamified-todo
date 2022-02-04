import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../decoration/text_styles.dart';
import '../../extensions/color/color_extensions.dart';
import '../../extensions/context/responsiveness_extensions.dart';
import '../../extensions/context/theme_extensions.dart';
import '../../helpers/material_state_helpers.dart';
import '../../providers/theme/theme_provider.dart';
import '../../theme/color/l_colors.dart';
import '../text/base_text.dart';

/// Callback of the checkbox.
typedef CheckboxCallback = void Function(bool);

/// Customized [Checkbox] with a leading text.
class CustomCheckboxTile extends StatefulWidget {
  /// Default constructor for [CheckboxListTile].
  const CustomCheckboxTile({
    required this.onTap,
    required this.text,
    this.initialValue = false,
    Key? key,
  }) : super(key: key);

  /// Initial value of the checkbox.
  final bool initialValue;

  /// Callback to call on checkbox click.
  final CheckboxCallback onTap;

  /// Text will be shown beside of the checkbox.
  final String text;

  @override
  State<CustomCheckboxTile> createState() => _CustomCheckboxTileState();
}

class _CustomCheckboxTileState extends State<CustomCheckboxTile>
    with MaterialStateHelpers {
  late bool value = widget.initialValue;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _changeValue(!value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[_checkbox, _expanded],
        ),
      );

  Widget get _checkbox => ConstrainedBox(
        constraints:
            BoxConstraints.loose(Size.fromHeight(context.height * 4.5)),
        child: Theme(
          data: context.read<ThemeProvider>().currentTheme.copyWith(
                unselectedWidgetColor: AppColors.white.darken(.1),
              ),
          child: Checkbox(
            value: value,
            onChanged: (bool? newValue) {
              if (newValue != null) _changeValue(newValue);
            },
          ),
        ),
      );

  Widget get _expanded => BaseText(
        widget.text,
        textAlign: TextAlign.left,
        style: TextStyles(context)
            .subBodyStyle(color: value ? context.primaryColor : null),
      );

  void _changeValue(bool newValue) {
    widget.onTap(newValue);
    setState(() => value = newValue);
  }
}
