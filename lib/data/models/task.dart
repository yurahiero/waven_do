// ignore_for_file: constant_identifier_names

import 'package:to_do_app/data/models/task_priority.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 2)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final TaskPriority priority;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime? reminderDateTime;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.isCompleted = false,
    this.reminderDateTime,
  });

  Task copyWith({
    String? id,
    String? title,
    TaskPriority? priority,
    bool? isCompleted,
    DateTime? remiderDateTime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderDateTime: reminderDateTime ?? reminderDateTime,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, priority: $priority, isCompleted $isCompleted, reminderDateTime $reminderDateTime)';
  }
}
