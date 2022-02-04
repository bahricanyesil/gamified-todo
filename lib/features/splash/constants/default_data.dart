part of '../view-model/splash_view_model.dart';

/// Default initial data of the app.
mixin _DefaultData {
  static final List<Group> _defaultGroups = <Group>[
    Group(title: 'Self-Care'),
    Group(title: 'Sport'),
    Group(title: 'Self-Development'),
    Group(title: 'Emotional'),
  ];

  static final List<Task> _defaultTasks = <Task>[
    Task(
      priority: Priorities.medium,
      content: 'Read "When Nietzsche Wept"',
      groupId: _defaultGroups[2].id,
    ),
    Task(
      priority: Priorities.high,
      content: 'Walk at least 40 mins',
      groupId: _defaultGroups[1].id,
    ),
    Task(
      priority: Priorities.high,
      content: 'Brush your teeth at morning',
      groupId: _defaultGroups[0].id,
      taskStatus: TaskStatus.active,
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Task(
      priority: Priorities.high,
      content: 'Be happy',
      groupId: _defaultGroups[3].id,
      taskStatus: TaskStatus.pastDue,
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}
