import 'package:flutter/material.dart';

import '../../../core/base/view-model/base_view_model.dart';
import '../../../product/constants/enums/task/priorities.dart';
import '../../../product/managers/local-storage/groups/groups_local_manager.dart';
import '../../../product/models/group/group.dart';

/// View model to manage the data on create task screen.
class CreateTaskViewModel extends BaseViewModel {
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

  @override
  Future<void> init() async {
    _contentController = TextEditingController();
    _dueDate = DateTime.now().add(const Duration(days: 1));
    _groups = GroupsLocalManager.instance.allValues();
    _selectedGroup = _groups[0];
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
}
