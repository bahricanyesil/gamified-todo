import 'package:gamified_todo/product/constants/enums/task/task_enums_shelf.dart';

import '../../../core/base/view-model/base_view_model.dart';
import '../../../product/managers/local-storage/tasks/tasks_local_manager.dart';
import '../../../product/models/task/task.dart';

/// View model to manaage the data on home screen.
class HomeViewModel extends BaseViewModel {
  /// All created tasks.
  List<Task> tasks = <Task>[];

  /// Local manager instance for tasks.
  final TasksLocalManager tasksLocalManager = TasksLocalManager();

  @override
  Future<void> init() async {
    await tasksLocalManager.initStorage();
    tasks = tasksLocalManager.allValues();
    tasks = List<Task>.generate(
      12,
      (int index) => Task.mock(
          content:
              'YEAAYYY YEAY YYY $index DAHASHDAHSDUIAHSDIUADHSıuahdsıuahsdu'),
    );
    tasks.sort((Task a, Task b) => a > b);
    Future<void>.delayed(const Duration(seconds: 2), _updateEl);
  }

  /// Updates the status of a task in the list.
  void updateTaskStatus(int index, TaskStatus newStatus) {
    tasks[index].status = newStatus;
    notifyListeners();
  }

  void _updateEl() {
    tasks[4].content = 'apokdapsd';
    notifyListeners();
  }
}
