import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamified_todo/core/helpers/completer_helper.dart';

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
  late final TasksLocalManager _localManager;

  /// All created tasks.
  List<Task> _tasks = <Task>[];

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

  /// Stores the [AnimatedListModel] configurations of the animated lists.
  late final List<AnimatedListModel<Task>> listModels;

  /// Returns all tasks.
  List<Task> get tasks => _tasks;

  late Completer<void> _completer;

  @override
  Future<void> init() async {
    _localManager = TasksLocalManager.instance;
    _completer = Completer<void>();
    _tasks = _localManager.allValues();
    _tasks.sort((Task a, Task b) => a > b);
    listModels = List<AnimatedListModel<Task>>.generate(
        TaskStatus.values.length, _animatedModelBuilder);
  }

  @override
  Future<void> customDispose() async {
    if (!_completer.isCompleted) await _completer.future;
  }

  AnimatedListModel<Task> _animatedModelBuilder(int index) {
    final List<Task> statusTasks = _tasks.byStatus(TaskStatus.values[index]);
    return AnimatedListModel<Task>(
      listKey: GlobalKey<AnimatedListState>(debugLabel: index.toString()),
      items: statusTasks,
      itemCallback: (Task task, {bool isRemoved = false}) =>
          TaskItem(id: task.id, isRemoved: isRemoved),
    );
  }

  /// Updates the status of a task in the list.
  void updateTaskStatus(String id, TaskStatus newStatus) {
    final int index = _tasks.indexWhere((Task t) => t.id == id);
    if (index == -1) return;
    final Task task = _tasks[index];
    if (task.status != newStatus) {
      final int removedIndex = _tasks.byStatus(task.status).indexById(id);
      animatedListModel(task.status).removeAt(removedIndex);
      task.setStatus(newStatus);
      final int insertedIndex =
          _tasks.byStatus(newStatus).findInsertIndex(task.priority);
      animatedListModel(newStatus).insert(insertedIndex, task);
      if (insertedIndex > 1) expandedLists[_statusIndex(newStatus)] = true;
      _tasks[index] = task.copyWith(taskStatus: newStatus);
      _completer =
          CompleterHelper.wrapCompleter<void>(_updateLocal(_tasks[index]));
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

  /// Returns the corresponding [AnimatedListModel] for the status.
  AnimatedListModel<Task> animatedListModel(TaskStatus status) =>
      listModels[TaskStatus.values.indexOf(status)];

  /// Returns all of the tasks with the given id.
  List<Task> getByGroupId(String id) =>
      _tasks.where((Task t) => t.groupId == id).toList();

  /// Adds a new task to the list.
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> _updateLocal(Task newTask) async =>
      _localManager.addOrUpdate(newTask.id, newTask);
}
