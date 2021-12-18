import 'package:flutter/material.dart';
import '../../extensions/context/context_extensions_shelf.dart';

/// Customized divider to use across the app.
class CustomDivider extends Divider {
  /// Default constructor for [CustomDivider].
  CustomDivider(BuildContext context, {Key? key})
      : super(
          key: key,
          indent: context.width * 2,
          endIndent: context.height * 2,
          color: context.primaryDarkColor,
          thickness: 1,
        );
}
