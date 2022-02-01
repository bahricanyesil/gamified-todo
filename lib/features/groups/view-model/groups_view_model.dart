import '../../../core/base/view-model/base_view_model.dart';
import '../../../product/managers/local-storage/groups/groups_local_manager.dart';
import '../../../product/models/group/group.dart';

/// View model to manage the data on create group screen.
class GroupsViewModel extends BaseViewModel {
  List<Group> _groups = <Group>[];

  /// Returns all possible groups.
  List<Group> get groups => _groups;

  @override
  Future<void> init() async {
    _groups = GroupsLocalManager.instance.allValues();
  }

  void updateGroup() {
    _groups[0] = _groups[0].copyWith(title: '123123');
    notifyListeners();
  }

  void addGroup() {
    _groups.add(Group(title: 'ASDA'));
    notifyListeners();
  }
}
