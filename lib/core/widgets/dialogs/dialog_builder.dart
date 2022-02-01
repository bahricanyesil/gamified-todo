import 'package:flutter/material.dart';

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
}
