import 'package:flutter/material.dart';

import '../../../core/constants/enums/settings-enums/login_status.dart';
import '../../../core/constants/enums/settings-enums/settings_storage_keys.dart';
import '../../../core/constants/enums/view-enums/sizes.dart';
import '../../../core/extensions/context/responsiveness_extensions.dart';
import '../../../core/extensions/string/type_conversion_extensions.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../../product/constants/enums/task/task_enums_shelf.dart';
import '../../../product/managers/local-storage/groups/groups_local_manager.dart';
import '../../../product/managers/local-storage/settings/settings_local_manager.dart';
import '../../../product/managers/local-storage/tasks/tasks_local_manager.dart';
import '../../../product/models/group/group.dart';
import '../../../product/models/task/task.dart';
import '../../home/view/home_screen.dart';
import '../constants/splash_texts.dart';

part './error_splash_screen.dart';

/// Splash screen of the app.
class SplashScreen extends StatefulWidget {
  /// Default constructor for splash screen.
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SplashTexts {
  late Future<bool> _initialize;
  bool _retrying = false;

  @override
  void initState() {
    super.initState();
    _initialize = _initializeApp();
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<bool>(future: _initialize, builder: _builder);

  Widget _builder(BuildContext context, AsyncSnapshot<bool> snapshot) {
    if (snapshot.hasData && !_retrying) {
      return const HomeScreen();
    } else if (snapshot.hasError && !_retrying) {
      return _ErrorScreen(error: snapshot.error, onPressed: _onRetry);
    }
    return const LoadingIndicator();
  }

  void _onRetry() {
    _initialize = _retryInitialization();
    setState(() => _retrying = true);
  }

  Future<bool> _initializeApp() async {
    await _initializeStorage();
    return false;
  }

  Future<bool> _retryInitialization() async {
    final bool res = await _initializeApp();
    setState(() => _retrying = false);
    return res;
  }

  Future<void> _initializeStorage() async {
    final GroupsLocalManager groupsStorage = GroupsLocalManager.instance;
    final TasksLocalManager tasksStorage = TasksLocalManager.instance;
    final SettingsLocalManager settingsStorage = SettingsLocalManager.instance;
    await groupsStorage.initStorage();
    await tasksStorage.initStorage();
    const SettingsStorageKeys loginKey = SettingsStorageKeys.loginStatus;
    final LoginStatus? loginStatus =
        settingsStorage.get(loginKey).toEnum<LoginStatus>(LoginStatus.values);
    if ((loginStatus ?? LoginStatus.first) == LoginStatus.first) {
      final List<Group> defaultGroups = <Group>[
        Group(title: 'Self-Care'),
        Group(title: 'Sport'),
        Group(title: 'Self-Development'),
        Group(title: 'Emotional'),
      ];
      await groupsStorage.putItems(
          defaultGroups.map((Group g) => g.id).toList(), defaultGroups);
      final List<Task> defaultTasks = <Task>[
        Task(
          priority: Priorities.medium,
          content: 'Read "When Nietzsche Wept"',
          groupId: defaultGroups[2].id,
        ),
        Task(
          priority: Priorities.high,
          content: 'Walk at least 40 mins',
          groupId: defaultGroups[1].id,
        ),
        Task(
          priority: Priorities.high,
          content: 'Brush your teeth at morning',
          groupId: defaultGroups[0].id,
          taskStatus: TaskStatus.active,
        ),
        Task(
          priority: Priorities.high,
          content: 'Be happy',
          groupId: defaultGroups[3].id,
          taskStatus: TaskStatus.pastDue,
          dueDate: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
      await tasksStorage.putItems(
          defaultTasks.map((Task t) => t.id).toList(), defaultTasks);
      await settingsStorage.addOrUpdate(loginKey, LoginStatus.normal.name);
    }
  }
}
