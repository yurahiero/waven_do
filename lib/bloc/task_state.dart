import 'package:to_do_app/data/models/task.dart';
import 'package:to_do_app/utils/errors/app_error.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded(this.tasks);
}

class TaskError extends TaskState {
  final AppError appError;

  TaskError(this.appError);
}
