import '../../../core/base/view-model/base_view_model.dart';
import '../../../product/constants/enums/task/task_status.dart';

/// View model to manaage the data on settings screen.
class SettingsViewModel extends BaseViewModel {
  /// Stores the visiblity of the animated lists.
  final List<bool> visibleSections =
      List<bool>.generate(TaskStatus.values.length, (_) => true);

  @override
  Future<void> init() async {}

  /// Sets the visibility of a section.
  // ignore: avoid_positional_boolean_parameters
  void setSectionVisibility(TaskStatus status, bool value) {
    final int index = TaskStatus.values.indexOf(status);
    visibleSections[index] = value;
    notifyListeners();
  }
}
