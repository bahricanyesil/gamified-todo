import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/base/view-model/base_view_model.dart';
import '../../../core/helpers/color_helpers.dart';
import '../../../core/helpers/completer_helper.dart';
import '../../../product/managers/local-storage/groups/groups_local_manager.dart';
import '../../../product/models/group/group.dart';

/// View model to manage the data on create group screen.
class GroupsViewModel extends BaseViewModel {
  late final GroupsLocalManager _localManager;

  /// Returns the corresponding title controller for the given index.
  TextEditingController? titleController(String id) {
    final int index =
        _groups.indexWhere((_GroupComplexModel g) => g.group.id == id);
    if (index == -1) return null;
    return _groups[index].controller;
  }

  List<_GroupComplexModel> _groups = <_GroupComplexModel>[];

  /// Returns the corresponding group for given index.
  Group group(int i) => _groups[i].group;

  /// Returns all groups.
  List<Group> get groups {
    final List<Group> allGroups = <Group>[];
    for (final _GroupComplexModel model in _groups) {
      allGroups.add(model.group);
    }
    return allGroups;
  }

  @override
  Future<void> init() async {
    _localManager = GroupsLocalManager.instance;
    await _localManager.initStorage();
    final List<Group> storedGroups = _localManager.allValues();
    _groups = List<_GroupComplexModel>.generate(storedGroups.length, (int i) {
      final Group group = storedGroups[i];
      return _GroupComplexModel(group,
          controller: TextEditingController(text: group.title));
    });
  }

  @override
  Future<void> customDispose() async {
    for (int i = 0; i < _groups.length; i++) {
      _groups[i].isExpanded = false;
    }
  }

  /// Adds a new group with the given properties.
  void addGroup(String title) {
    final Group newGroup = Group(title: title);
    _groups.add(_GroupComplexModel(newGroup,
        controller: TextEditingController(text: 'New Group')));
    completer = CompleterHelper.wrapCompleter<void>(_addLocal(newGroup));
    notifyListeners();
  }

  /// Deletes the group whose id is given.
  void deleteGroup(String id) {
    final int index =
        _groups.indexWhere((_GroupComplexModel g) => g.group.id == id);
    if (index != -1) {
      _groups.removeAt(index);
      completer = CompleterHelper.wrapCompleter<void>(_removeLocal(id));
      notifyListeners();
    }
  }

  /// Notify listeners on title change.
  void onTitleChanged(String id, String? val) {
    final int i =
        _groups.indexWhere((_GroupComplexModel g) => g.group.id == id);
    if (i == -1) return;
    _groups[i].group =
        _groups[i].group.copyWith(title: _groups[i].controller.text);
    completer = CompleterHelper.wrapCompleter<void>(_updateLocal(i));
    notifyListeners();
  }

  Future<void> _updateLocal(int i) async =>
      _localManager.update(_groups[i].group.id, _groups[i].group);

  Future<void> _removeLocal(String id) async => _localManager.removeItem(id);

  Future<void> _addLocal(Group newGroup) async =>
      _localManager.addOrUpdate(newGroup.id, newGroup);

  /// Returns whether the group item is expanded.
  bool isExpanded(String id) {
    final int i =
        _groups.indexWhere((_GroupComplexModel g) => g.group.id == id);
    if (i == -1) return false;
    return _groups[i].isExpanded;
  }

  /// Sets the expansion status of the group item.
  void setExpansion(String id, {required bool isExpanded}) {
    final int i =
        _groups.indexWhere((_GroupComplexModel g) => g.group.id == id);
    if (i == -1) return;
    _groups[i].isExpanded = isExpanded;
    notifyListeners();
  }

  /// Returns the corresponding color for the given group id.
  Color color(String id) {
    final int i =
        _groups.indexWhere((_GroupComplexModel g) => g.group.id == id);
    if (i == -1) return Colors.transparent;
    return _groups[i].backgroundColor;
  }
}

class _GroupComplexModel with ColorHelpers {
  _GroupComplexModel(
    this.group, {
    required this.controller,
    this.isExpanded = false,
    Color? bgColor,
  }) {
    backgroundColor = bgColor ?? lightRandomColor;
  }
  final TextEditingController controller;
  late final Color backgroundColor;
  Group group;
  bool isExpanded;
}
