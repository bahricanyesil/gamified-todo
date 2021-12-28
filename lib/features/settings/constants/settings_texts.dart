import 'package:flutter/widgets.dart';

/// Collection of texts in the settings screen.
mixin SettingsTexts on StatelessWidget {
  /// Screen title for settings screen.
  static const String settingsScreenTitle = 'Settings';

  /// Screen title for settings screen.
  static const List<String> infoSentences = <String>[
    'Numbers from 1 to 3 represents the priorities of the tasks.',
    """There are three priorities:
    1- Urgent
    2- Normal
    3-Nonurgent""",
    'Colors (red-yellow-green) represents the status of the tasks.',
    """There are four task status:
    1- Active Tasks: Represented with blue color and a person who runs.
    These are the tasks that you've started but not yet finished.
    2- Open Tasks: Respresented with yellow color and a clock.
    These are the tasks that you've created but not yet started.
    3- Finished Tasks: Respresented with green color and a check sign.
    These are the tasks that you've finished.
    4- Past Due Tasks: Respresented with red color and a cross sign.
    These are the tasks that you couldn't finished before the deadline""",
  ];
}