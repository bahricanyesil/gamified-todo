import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/view-model/base_view_model.dart';
import '../../../core/constants/constants_shelf.dart';
import '../../../core/helpers/completer_helper.dart';
import '../../../product/constants/enums/task/priorities.dart';
import '../../../product/managers/local-storage/groups/groups_local_manager.dart';
import '../../../product/managers/local-storage/tasks/tasks_local_manager.dart';
import '../../../product/models/group/group.dart';
import '../../../product/models/task/task.dart';
import '../../groups/view-model/groups_view_model.dart';
import '../../home/view-model/home_view_model.dart';

/// View model to manage the data on task screen.
class TaskViewModel extends BaseViewModel {
  ScreenType _screenType = ScreenType.create;

  late final TasksLocalManager _localManager;
  late final GroupsLocalManager _groupsLocalManager;

  late TextEditingController _contentController;

  /// Returns the text editing controller of content.
  TextEditingController get content => _contentController;

  Priorities _priority = Priorities.low;

  /// Returns the selected priority.
  Priorities get priority => _priority;

  /// Returns all possible priorities.
  List<Priorities> get priorities => Priorities.values;

  List<Group> _groups = <Group>[];

  /// Returns all possible groups.
  List<Group> groups(BuildContext context) {
    final GroupsViewModel groupModel = context.read<GroupsViewModel>();
    if (!groupModel.initCompleter.isCompleted) return _groups;
    return _groups = groupModel.groups;
  }

  late Group _selectedGroup;

  /// Returns the currently selected
  Group get group => _selectedGroup;

  late DateTime _dueDate;

  /// Due date of the task.
  DateTime get dueDate => _dueDate;

  /// Gets the screen type.
  ScreenType get screenType => _screenType;

  late Task? _editTask;

  @override
  Future<void> init() async {
    _localManager = TasksLocalManager.instance;
    _groupsLocalManager = GroupsLocalManager.instance;
    await _localManager.initStorage();
    await _groupsLocalManager.initStorage();
    _groups = _groupsLocalManager.allValues();
    _setDefaultValues();
  }

  @override
  Future<void> customDispose() async {
    if (!isCreate) _setDefaultValues();
  }

  void _setDefaultValues() {
    _contentController = TextEditingController();
    _selectedGroup = _groups[0];
    _dueDate = DateTime.now().add(const Duration(days: 1));
    _priority = Priorities.low;
  }

  /// Sets the screen type.
  // ignore: use_setters_to_change_properties
  void setScreenType(ScreenType type, String id) {
    final Task? task = _localManager.get(id);
    if (task != null) {
      _screenType = type;
      _contentController.text = task.content;
      _dueDate = task.dueDate;
      _selectedGroup =
          _groups.firstWhereOrNull((Group g) => g.id == task.groupId) ??
              _selectedGroup;
      _priority = task.priority;
      _editTask = task;
    }
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
  void action(HomeViewModel model) {
    late final Task newTask;
    if (isCreate) {
      newTask = Task(
        content: _contentController.text,
        groupId: _selectedGroup.id,
        dueDate: _dueDate,
        priority: _priority,
      );
      model.addTask(newTask);
      _setDefaultValues();
    } else {
      newTask = _editTask!.copyWith(
        content: _contentController.text,
        groupId: _selectedGroup.id,
        dueDate: _dueDate,
        newPriority: _priority,
      );
      model.updateTask(newTask.id, newTask);
    }
    completer = CompleterHelper.wrapCompleter<void>(_localAction(newTask));
    navigationManager.popRoute();
  }

  Future<void> _localAction(Task newTask) async =>
      _localManager.addOrUpdate(newTask.id, newTask);

  /// Determines whether the screen is in create status.
  bool get isCreate => screenType == ScreenType.create;
}
