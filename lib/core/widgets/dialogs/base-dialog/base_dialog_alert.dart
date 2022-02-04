import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_dialog.dart';

/// Builds a platform specific dialog.
class BaseDialogAlert extends BaseDialog<AlertDialog, CupertinoAlertDialog> {
  /// Default constructor of the [BaseDialogAlert].
  const BaseDialogAlert({this.title, this.content, this.actions, Key? key})
      : super(key: key);

  /// Title of the dialog.
  final Widget? title;

  /// Content of the dialog.
  final Widget? content;

  /// All possible actions of the dialog.
  final List<Widget>? actions;

  @override
  AlertDialog buildAndroidWidget(BuildContext context) => AlertDialog(
        title: title,
        content: content,
        actions: actions,
      );

  @override
  CupertinoAlertDialog buildIOSWidget(BuildContext context) =>
      CupertinoAlertDialog(
        title: title,
        content: content,
        actions: actions ?? <Widget>[],
      );
}
