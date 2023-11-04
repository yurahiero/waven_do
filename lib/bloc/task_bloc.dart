import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:to_do_app/bloc/task_event.dart';
import 'package:to_do_app/bloc/task_state.dart';
import 'package:to_do_app/data/models/task.dart';
import 'package:to_do_app/data/repositories/task_repository.dart';
import 'package:to_do_app/utils/errors/app_error.dart';
import 'package:to_do_app/utils/notification_helper.dart';
import 'package:uuid/uuid.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;
  final NotificationHelper _notificationHelper;

  TaskBloc(this._taskRepository, this._notificationHelper)
      : super(TaskInitial()) {
    on<GetTasksByPriority>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await _taskRepository.getTasksSortedByPriority();
        emit(TaskLoaded(tasks));
      } catch (e, stackTrace) {
        emit(TaskError(AppError('Erro ao obter as Tarefas por prioridade',
            stackTrace: stackTrace)));
      }
    });

    on<AddTask>((event, emit) async {
      emit(TaskLoading());
      try {
        const uuid = Uuid();
        final newTask = Task(
          id: uuid.v4(),
          title: event.task.title,
          priority: event.task.priority,
          isCompleted: event.task.isCompleted,
          reminderDateTime: event.task.reminderDateTime,
        );
        await _taskRepository.addTask(newTask);
        if (newTask.reminderDateTime != null) {
          _notificationHelper.scheduledNotification(
            taskTitle: newTask.title,
            taskPriority: newTask.priority,
            hour: newTask.reminderDateTime!.hour,
            minutes: newTask.reminderDateTime!.minute,
            id: newTask.id.hashCode,
          );
          debugPrint('Notificação agendada para ${newTask.reminderDateTime}');
        }
        emit(TaskLoading());
        final tasks = await _taskRepository.getTasksSortedByPriority();
        emit(TaskLoaded(tasks));
      } catch (error, stackTrace) {
        emit(
          TaskError(AppError('Erro ao adicionar tarefa$error',
              stackTrace: stackTrace)),
        );
      }
    });

    on<UpdateTask>((event, emit) async {
      emit(TaskLoading());
      try {
        await _taskRepository.updateTask(event.taskId, event.updatedTask);
        if (event.updatedTask.reminderDateTime != null) {
          _notificationHelper.scheduledNotification(
            taskTitle: event.updatedTask.title,
            taskPriority: event.updatedTask.priority,
            hour: event.updatedTask.reminderDateTime!.hour,
            minutes: event.updatedTask.reminderDateTime!.minute,
            id: event.updatedTask.id.hashCode,
          );
          debugPrint(
              'Notificação de tarefa atualizada para ${event.updatedTask.reminderDateTime}');
        }
        final tasks = await _taskRepository.getTasksSortedByPriority();
        emit(TaskLoaded(tasks));
      } catch (e, stackTrace) {
        emit(TaskError(
            AppError('Erro ao atualizar tarefa $e', stackTrace: stackTrace)));
      }
    });

    on<DeleteTask>((event, emit) async {
      emit(TaskLoading());
      try {
        await _taskRepository.deleteTask(event.taskId);
        final tasks = await _taskRepository.getTasksSortedByPriority();
        emit(TaskLoaded(tasks));
      } catch (e, stackTrace) {
        emit(TaskError(
            AppError('Erro ao excluir tarefa $e', stackTrace: stackTrace)));
      }
    });
  }
}
