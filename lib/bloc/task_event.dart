import '../data/models/task.dart';

abstract class TaskEvent {}

class GetTasksByPriority extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;

  AddTask({
    required this.task,
  });
}

class UpdateTask extends TaskEvent {
  final String taskId;
  final Task updatedTask;

  UpdateTask({
    required this.taskId,
    required this.updatedTask,
  });
}

class DeleteTask extends TaskEvent {
  final String taskId;

  DeleteTask(this.taskId);
}
