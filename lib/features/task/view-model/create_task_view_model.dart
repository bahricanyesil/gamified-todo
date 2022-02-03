import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamified_todo/core/managers/navigation/navigation_manager.dart';
import 'package:gamified_todo/features/home/view-model/home_view_model.dart';
import 'package:provider/src/provider.dart';

import '../../../core/base/view-model/base_view_model.dart';
import '../../../core/helpers/completer_helper.dart';
import '../../../product/constants/enums/task/priorities.dart';
import '../../../product/managers/local-storage/groups/groups_local_manager.dart';
import '../../../product/managers/local-storage/tasks/tasks_local_manager.dart';
import '../../../product/models/group/group.dart';
import '../../../product/models/task/task.dart';

/// View model to manage the data on create task screen.
class CreateTaskViewModel extends BaseViewModel {
  late final TasksLocalManager _localManager;
  late final GroupsLocalManager _groupsLocalManager;
  late final NavigationManager _navigationManager;

  late final TextEditingController _contentController;

  /// Returns the text editing controller of content.
  TextEditingController get content => _contentController;

  Priorities _priority = Priorities.low;

  /// Returns the selected priority.
  Priorities get priority => _priority;

  /// Returns all possible priorities.
  List<Priorities> get priorities => Priorities.values;

  List<Group> _groups = <Group>[];

  /// Returns all possible groups.
  List<Group> get groups => _groups;

  late Group _selectedGroup;

  /// Returns the currently selected
  Group get group => _selectedGroup;

  late DateTime _dueDate;

  /// Due date of the task.
  DateTime get dueDate => _dueDate;

  late Completer<void> _completer;

  @override
  Future<void> init() async {
    _navigationManager = NavigationManager.instance;
    _localManager = TasksLocalManager.instance;
    _groupsLocalManager = GroupsLocalManager.instance;
    await _localManager.initStorage();
    await _groupsLocalManager.initStorage();
    _completer = Completer<void>();
    _contentController = TextEditingController();
    _dueDate = DateTime.now().add(const Duration(days: 1));
    _groups = _groupsLocalManager.allValues();
    _selectedGroup = _groups[0];
  }

  @override
  Future<void> customDispose() async {
    if (!_completer.isCompleted) await _completer.future;
  }

  /// Callback to call on priority choose.
  void onPriorityChoose(List<Priorities> newPriority) {
    if (newPriority.isEmpty || newPriority[0] == _priority) return;
    _priority = newPriority[0];
    notifyListeners();
  }

  /// Callback to call on due date choose.
  void onDueDateChoose(DateTime? pickedDate) {
    if (pickedDate == null) return;
    _dueDate = pickedDate;
    notifyListeners();
  }

  /// Callback to call on group choose.
  void onGroupChoose(List<Group> newGroup) {
    if (newGroup.isEmpty || newGroup[0] == _selectedGroup) return;
    _selectedGroup = newGroup[0];
    notifyListeners();
  }

  /// Creates a task.
  void createTask(BuildContext context) {
    final Task newTask = Task(
      content: _contentController.text,
      groupId: _selectedGroup.id,
      dueDate: _dueDate,
      priority: _priority,
    );
    context.read<HomeViewModel>().addTask(newTask);
    _completer = CompleterHelper.wrapCompleter<void>(_addLocal(newTask));
    _navigationManager.popRoute();
  }

  Future<void> _addLocal(Task newTask) async =>
      _localManager.addOrUpdate(newTask.id, newTask);
}
