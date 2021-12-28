import 'package:flutter/material.dart';

import '../../decoration/text_styles.dart';
import '../../extensions/color/color_extensions.dart';
import '../../extensions/context/responsiveness_extensions.dart';
import '../../extensions/context/theme_extensions.dart';
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

class _CustomCheckboxTileState extends State<CustomCheckboxTile> {
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
        child: Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            if (newValue != null) _changeValue(newValue);
          },
        ),
      );

  Widget get _expanded => Expanded(
        child: BaseText(
          widget.text,
          style: TextStyles(context).subBodyStyle(
              color: value ? context.primaryColor.darken() : null),
        ),
      );

  void _changeValue(bool newValue) {
    widget.onTap(newValue);
    setState(() => value = newValue);
  }
}
