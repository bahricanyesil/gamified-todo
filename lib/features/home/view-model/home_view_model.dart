import 'package:flutter/material.dart';

import '../../../core/base/view-model/base_view_model.dart';
import '../../../core/widgets/list/animated-list/models/animated_list_model.dart';
import '../../../product/constants/enums/task/task_enums_shelf.dart';
import '../../../product/extensions/task_extensions.dart';
import '../../../product/managers/local-storage/tasks/tasks_local_manager.dart';
import '../../../product/models/task/task.dart';
import '../view/components/tasks/task_item.dart';
import '../view/ui-models/tasks_section_title.dart';

/// View model to manaage the data on home screen.
class HomeViewModel extends BaseViewModel {
  /// All created tasks.
  List<Task> tasks = <Task>[];

  /// List of tasks section titles.
  static const List<TasksSection> tasksSections = <TasksSection>[
    TasksSection(title: 'Active Tasks', status: TaskStatus.active),
    TasksSection(title: 'Open Tasks', status: TaskStatus.open),
    TasksSection(title: 'Finished Tasks', status: TaskStatus.finished),
    TasksSection(title: 'Past Due Tasks', status: TaskStatus.pastDue),
  ];

  /// Stores the expansion status of the animated lists.
  final List<bool> expandedLists =
      List<bool>.generate(TaskStatus.values.length, (_) => false);

  /// Stores the visiblity of the animated lists.
  final List<bool> visibleSections =
      List<bool>.generate(TaskStatus.values.length, (_) => true);

  /// Stores the [AnimatedListModel] configurations of the animated lists.
  late final List<AnimatedListModel<Task>> listModels;

  /// Local manager instance for tasks.
  late final TasksLocalManager tasksLocalManager;

  @override
  Future<void> init() async {
    tasksLocalManager = TasksLocalManager();
    await tasksLocalManager.initStorage();
    tasks = tasksLocalManager.allValues();

    // Mocking
    tasks = _mockList;

    tasks.sort((Task a, Task b) => a > b);
    listModels = List<AnimatedListModel<Task>>.generate(
        TaskStatus.values.length, _animatedModelBuilder);
  }

  List<Task> get _mockList => List<Task>.generate(
      30, (int index) => Task.mock(content: 'YEAAYYY YEAY YYY $index'));

  AnimatedListModel<Task> _animatedModelBuilder(int index) {
    final List<Task> statusTasks = tasks.byStatus(TaskStatus.values[index]);
    return AnimatedListModel<Task>(
      listKey: GlobalKey<AnimatedListState>(debugLabel: index.toString()),
      items: statusTasks,
      itemCallback: (Task task, {bool isRemoved = false}) =>
          TaskItem(id: task.id, isRemoved: isRemoved),
    );
  }

  /// Updates the status of a task in the list.
  void updateTaskStatus(String id, TaskStatus newStatus) {
    final Task? task = tasks.byId(id);
    if (task != null && task.status != newStatus) {
      final int removedIndex = tasks.byStatus(task.status).indexById(id);
      animatedListModel(task.status).removeAt(removedIndex);
      task.status = newStatus;
      final int insertedIndex =
          tasks.byStatus(newStatus).findInsertIndex(task.priority);
      animatedListModel(newStatus).insert(insertedIndex, task);
      if (insertedIndex > 1) expandedLists[_statusIndex(newStatus)] = true;
      notifyListeners();
    }
  }

  /// Used as the callback of confirmation on dismiss on a taks.
  Future<bool> confirmDismiss(DismissDirection direction, String id) async {
    if (direction == DismissDirection.startToEnd) {
      updateTaskStatus(id, TaskStatus.finished);
    } else if (direction == DismissDirection.endToStart) {
      updateTaskStatus(id, TaskStatus.open);
    }
    return false;
  }

  int _statusIndex(TaskStatus status) => TaskStatus.values.indexOf(status);

  /// Switches the expansion status of the tasks section.
  void setExpanded(TaskStatus status) {
    final int index = TaskStatus.values.indexOf(status);
    expandedLists[index] = !expandedLists[index];
    notifyListeners();
  }

  /// Sets the visibility of a section.
  // ignore: avoid_positional_boolean_parameters
  void setSectionVisibility(TaskStatus status, bool value) {
    final int index = TaskStatus.values.indexOf(status);
    visibleSections[index] = value;
    notifyListeners();
  }

  /// Returns the corresponding [AnimatedListModel] for the status.
  AnimatedListModel<Task> animatedListModel(TaskStatus status) =>
      listModels[TaskStatus.values.indexOf(status)];
}
