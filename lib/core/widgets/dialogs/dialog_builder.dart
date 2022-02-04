import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../extensions/color/color_extensions.dart';
import '../../extensions/context/theme_extensions.dart';
import '../../theme/color/l_colors.dart';
import '../text/base_text.dart';
import 'base-dialog/base_dialog_action.dart';
import 'base-dialog/base_dialog_alert.dart';
import 'choose/choose_dialogs_shelf.dart';

/// Builds various types of dialogs.
class DialogBuilder {
  /// Default constructor with context parameter.
  const DialogBuilder(this.context);

  /// Shows dialogs with the given context.
  final BuildContext context;

  /// Shows a dialog with single selection option.
  Future<T?> singleSelectDialog<T>(
          String title, List<T> elements, T? initialValue) async =>
      showDialog<T?>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => SingleChooseDialog<T>(
            title: title, elements: elements, initialValue: initialValue),
      );

  /// Shows a dialog with multiple selection options.
  Future<List<T>> multipleSelectDialog<T>(
    String title,
    List<T> elements,
    List<T> initialValues, {
    bool enableSearch = false,
  }) async =>
      await showDialog<List<T>>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => MultipleChooseDialog<T>(
          title: title,
          elements: elements,
          enableSearch: enableSearch,
          initialSelecteds: initialValues,
        ),
      ) ??
      <T>[];

  /// Shows a platform specific dialog.
  Future<T?> platformSpecific<T>({
    WidgetBuilder? builder,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    String? title,
    String? contentText,
    List<BaseDialogAction> actions = const <BaseDialogAction>[],
  }) {
    final TargetPlatform platform = Theme.of(context).platform;
    final WidgetBuilder widgetBuilder = builder ??
        (BuildContext context) => _defaultBuilder(context,
            title: title, contentText: contentText, actions: actions);
    switch (platform) {
      case TargetPlatform.iOS:
        return showCupertinoDialog<T>(
          context: context,
          builder: widgetBuilder,
          barrierDismissible: barrierDismissible,
          useRootNavigator: useRootNavigator,
        );
      default:
        return _showAndroidDialog<T>(
            widgetBuilder, barrierDismissible, useRootNavigator);
    }
  }

  /// Delete confirmation dialog.
  Future<T?> deleteDialog<T>({required VoidCallback deleteAction}) async =>
      DialogBuilder(context).platformSpecific(
        title: 'Are you sure to delete?',
        contentText: "This action cannot be undone.",
        actions: <BaseDialogAction>[
          BaseDialogAction(
            text: _dialogActionText('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          BaseDialogAction(
            text:
                _dialogActionText('Delete', color: AppColors.error.darken(.1)),
            onPressed: () {
              deleteAction();
              Navigator.pop(context);
            },
          ),
        ],
      );

  Widget _dialogActionText(String text, {Color? color}) =>
      BaseText(text, color: color ?? AppColors.black);

  Widget _defaultBuilder(
    BuildContext context, {
    String? title,
    String? contentText,
    List<BaseDialogAction> actions = const <BaseDialogAction>[],
  }) =>
      BaseDialogAlert(
        title:
            title == null ? null : BaseText(title, color: context.primaryColor),
        content: contentText == null
            ? null
            : BaseText(contentText, color: AppColors.black),
        actions: actions,
      );

  Future<T?> _showAndroidDialog<T>(WidgetBuilder builder,
          bool androidDismissible, bool useRootNavigator) =>
      showDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: androidDismissible,
        useRootNavigator: useRootNavigator,
      );
}
