import 'package:flutter/material.dart';
import '../../../../core/extensions/color/color_extensions.dart';
import '../../../../core/theme/color/l_colors.dart';
import '../../../../core/widgets/icons/base_icon.dart';

/// Enum to indicate the status of a task.
/// * Open
/// * Active
/// * Past Due
/// * Finished
enum TaskStatus {
  /// Indicates that the task is craeted but not yet in progress.
  open,

  /// Indicates that the task is active and currently working on.
  active,

  /// Indicates that the task is past due and it's aimed date is passed.
  pastDue,

  /// Indicates that the task is finished on time.
  finished,
}

/// Custom extensions for [TaskStatus].
extension TaskStatusValue on TaskStatus {
  /// Gets the string value of the task status.
  String get value {
    switch (this) {
      case TaskStatus.open:
        return 'Open';
      case TaskStatus.active:
        return 'Active';
      case TaskStatus.pastDue:
        return 'Past Due';
      case TaskStatus.finished:
        return 'Finished';
    }
  }

  /// Corresponding icon for the task status.
  BaseIcon get icon {
    switch (this) {
      case TaskStatus.open:
        return BaseIcon(Icons.access_time_outlined,
            color: AppColors.medPriority.darken());
      case TaskStatus.active:
        return const BaseIcon(Icons.run_circle_outlined,
            color: AppColors.loadingColor);
      case TaskStatus.pastDue:
        return const BaseIcon(Icons.close_outlined,
            color: AppColors.highPriority);
      case TaskStatus.finished:
        return BaseIcon(Icons.check, color: AppColors.lowPriority.darken());
    }
  }
}

/// List of [TaskStatus] extensions.
extension Ordered on List<TaskStatus> {
  /// Ordered task status list.
  List<TaskStatus> get ordered => <TaskStatus>[
        TaskStatus.pastDue,
        TaskStatus.active,
        TaskStatus.open,
        TaskStatus.finished
      ];
}
