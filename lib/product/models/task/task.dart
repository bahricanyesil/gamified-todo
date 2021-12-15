import 'dart:math';

import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/enums/tasks/priorities.dart';
import '../../../core/extensions/date/date_time_extensions.dart';
import '../../../core/extensions/enum/enum_extensions.dart';
import '../../../core/helpers/hasher.dart';
import '../../constants/enums/task_award_status.dart';
import '../../constants/enums/task_status.dart';
import '../../managers/local-storage/hive_configs.dart';

part 'task.g.dart';

@HiveType(typeId: HiveConfigs.tasks)

/// [Task] model is to store the information about a task.
class Task with HiveObjectMixin {
  /// Default constructor for [Task].
  /// Overrides [toString], [hashCode] methods and [==] operator.
  Task({
    required this.priority,
    required this.content,
    required this.groupId,
  })  : id = const Uuid().v4(),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        dueDate = DateTime.now(),
        status = TaskStatus.open,
        awardIds = <String>[],
        awardOfIds = <String>[];

  /// Mock object, dummy data for [Task].
  Task.mock({
    Priorities? priority,
    TaskStatus? status,
    String? groupId,
    String? content,
    List<String>? awardIds,
    List<String>? awardOfIds,
  })  : id = const Uuid().v4(),
        content = content ?? 'This is a great task.',
        groupId = groupId ?? '1',
        priority = priority ?? Priorities.values[Random().nextInt(3)],
        status = status ?? TaskStatus.values[Random().nextInt(4)],
        createdAt =
            DateTime.now().subtract(Duration(days: Random().nextInt(20))),
        updatedAt = DateTime.now(),
        dueDate = DateTime.now().add(Duration(days: Random().nextInt(20))),
        awardIds = awardIds ?? <String>[],
        awardOfIds = awardOfIds ?? <String>[];

  /// Priority of the task.
  @HiveField(0)
  final Priorities priority;

  /// Content of the task.
  @HiveField(1)
  final String content;

  /// Unique id of the task.
  @HiveField(2)
  final String id;

  /// The date when the task is created.
  @HiveField(3)
  final DateTime createdAt;

  /// The date when the task is lastly updated.
  @HiveField(4)
  final DateTime updatedAt;

  /// Status of the task. Refer to [TaskStatus] enum.
  @HiveField(5)
  final TaskStatus status;

  /// Planned due date of the task.
  @HiveField(6)
  final DateTime dueDate;

  /// Group id of the task.
  @HiveField(7)
  final String groupId;

  /// Refers to the tasks those this task is award of.
  @HiveField(8)
  final List<String> awardOfIds;

  /// Refers to the tasks that are award of this task.
  @HiveField(9)
  final List<String> awardIds;

  @override
  String toString() => """
      $content\nPriority: ${priority.value}
      \nCreated on: ${createdAt.dm}
      \nDue Date: ${dueDate.dm}
      \nStatus: ${status.value}""";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Task &&
        other.priority.value == priority.value &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.dueDate == dueDate &&
        other.status.value == status.value &&
        other.groupId == groupId &&
        _areListsEqual(awardIds, other.awardIds) &&
        _areListsEqual(awardOfIds, other.awardOfIds) &&
        other.id == id;
  }

  /// Compares two [Task] item.
  int operator >(Task other) {
    if (identical(this, other)) return 0;
    final List<TaskStatus> taskStatus = TaskStatus.values.ordered;
    if (taskStatus.indexOf(other.status) > taskStatus.indexOf(status)) {
      return -1;
    }
    return 1;
  }

  /// This hashCode part is inspired from Quiver package.
  /// Quiver package link: https://pub.dev/packages/quiver
  @override
  int get hashCode => Hasher.getHashCode(<String>[
        priority.value,
        content,
        createdAt.toIso8601String(),
        updatedAt.toIso8601String(),
        dueDate.toIso8601String(),
        status.value,
        groupId,
        awardIds.toString(),
        awardOfIds.toString(),
        id,
      ]);

  bool _areListsEqual(List<dynamic> list1, List<dynamic> list2) =>
      const DeepCollectionEquality.unordered().equals(list1, list2);

  /// Gets the award status of the task to determine whether it is an award.
  TaskAwardStatus get awardStatus {
    final bool award = awardOfIds.isNotEmpty;
    final bool todo = awardIds.isNotEmpty;
    if (award && todo) return TaskAwardStatus.both;
    if (award && !todo) return TaskAwardStatus.award;
    return TaskAwardStatus.toDo;
  }
}
