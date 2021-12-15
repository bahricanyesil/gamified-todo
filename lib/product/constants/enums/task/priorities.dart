import 'package:flutter/material.dart';

import '../../../../../core/theme/color/l_colors.dart';
import '../../../../core/widgets/widgets_shelf.dart';

/// Determines the priorities of the tasks.
enum Priorities {
  /// Indicates a low prioritized task.
  low,

  /// Indicates a medium prioritized task.
  medium,

  /// Indicates a high prioritized task.
  high,
}

/// Extensions on [Priorities] enum.
extension PriorityExtensions on Priorities {
  /// Gets the corresponding color for the priority.
  Color get color {
    switch (this) {
      case Priorities.low:
        return AppColors.lowPriority;
      case Priorities.medium:
        return AppColors.medPriority;
      case Priorities.high:
        return AppColors.highPriority;
    }
  }

  /// Gets the corresponding text widget for the priority.
  BaseText get numberText {
    switch (this) {
      case Priorities.low:
        return const BaseText('3',
            fontSizeFactor: 6.2, fontWeight: FontWeight.w400);
      case Priorities.medium:
        return const BaseText('2',
            fontSizeFactor: 6.6, fontWeight: FontWeight.w500);
      case Priorities.high:
        return const BaseText('1',
            fontSizeFactor: 7, fontWeight: FontWeight.w600);
    }
  }
}
