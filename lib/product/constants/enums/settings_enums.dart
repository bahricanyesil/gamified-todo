import 'package:flutter/material.dart';

/// Represents the settings options.
enum SettingsOptions {
  /// Indicates the key value for storing and retrieving visible task sections.
  visibleTaskSections,

  /// Indicates the section that will give information about the app.
  info,
}

/// Extensions on [SettingsOptions].
extension StringSettingsValues on SettingsOptions {
  /// Returns the title of the settings option.
  String get title {
    switch (this) {
      case SettingsOptions.visibleTaskSections:
        return 'Task Statuses';
      case SettingsOptions.info:
        return 'Info';
    }
  }

  /// Returns the subtitle of the settings option.
  String get subtitle {
    switch (this) {
      case SettingsOptions.visibleTaskSections:
        return 'They will be visible on home screen.';
      case SettingsOptions.info:
        return 'Confused about how to use app?';
    }
  }

  /// Returns the corresponding icon for the settings option.
  IconData get icon {
    switch (this) {
      case SettingsOptions.visibleTaskSections:
        return Icons.grid_view_outlined;
      case SettingsOptions.info:
        return Icons.info_outline;
    }
  }
}
