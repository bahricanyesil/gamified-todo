import 'package:flutter/material.dart';

import '../view/home_screen.dart';

/// Collection of texts in the [HomeScreen].
mixin HomeTexts on StatelessWidget {
  /// Title above the list of tasks.
  static const String tasksTitle = 'Tasks';

  /// Title of the home screen.
  static const String homeScreenTitle = 'Gamified To-Do';

  /// CTA for re-opening a task.
  static const String openTask = 'Open';

  /// Represents the CTA for finishing a task.
  static const String finishTask = 'Finish';
}
