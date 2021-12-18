import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../product/constants/enums/task/task_enums_shelf.dart';
import '../../../product/extensions/task_extensions.dart';
import '../../../product/models/task/task.dart';
import '../view-model/home_view_model.dart';

/// A utility to listen a specific value in [HomeViewModel].
mixin ListenHomeValue {
  /// Listens a specific value.
  T listenValue<T>(
          T Function(HomeViewModel model) func, BuildContext context) =>
      context.select<HomeViewModel, T>(func);

  /// Returns whether the task section is expanded.
  bool listenExpanded(BuildContext context, TaskStatus status) =>
      context.select<HomeViewModel, bool>((HomeViewModel model) =>
          model.expandedLists[TaskStatus.values.indexOf(status)]);

  /// Returns listened tasks by status.
  List<Task> listenStatusTasks(BuildContext context, TaskStatus status) {
    context.select<HomeViewModel, int>(
        (HomeViewModel model) => model.tasks.byStatus(status).length);
    return context.read<HomeViewModel>().tasks.byStatus(status);
  }

  /// Retunrs the visibility status of the section.
  bool listenVisibleSection(BuildContext context, TaskStatus status) =>
      context.select<HomeViewModel, bool>((HomeViewModel model) =>
          model.visibleSections[TaskStatus.values.indexOf(status)]);
}
