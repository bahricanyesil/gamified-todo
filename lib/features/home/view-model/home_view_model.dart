import '../../../core/base/view-model/base_view_model.dart';
import '../../../product/managers/local-storage/tasks/tasks_local_manager.dart';
import '../../../product/models/task/task.dart';

/// View model to manaage the data on home screen.
class HomeViewModel extends BaseViewModel {
  /// All created tasks.
  List<Task> tasks = <Task>[];

  /// Local manager instance for tasks.
  final TasksLocalManager tasksLocalManager = TasksLocalManager();

  int a = 0;
  int b = 0;

  @override
  Future<void> init() async {
    await tasksLocalManager.initStorage();
    tasks = tasksLocalManager.allValues();
    tasks = List<Task>.generate(
      12,
      (int index) => Task.mock(content: 'YEAAYYY YEAY YEAAYYY $index'),
    );
    tasks.sort((Task a, Task b) => a > b);

    Future.delayed(Duration(seconds: 3), () => updateB());
  }

  void updateB() {
    print('IPDATE');
    b = 1234;
    notifyListeners();
  }
}
