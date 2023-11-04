import 'package:to_do_app/data/models/task.dart';
import 'package:to_do_app/utils/errors/app_error.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class TaskRepository {
  final String _boxName = 'task_box';
  late Box<Task> _box;

  set box(Box<Task> value) => _box = value;

  bool _isBoxOpen() {
    return Hive.isBoxOpen(_boxName);
  }

  Future<void> _openBox() async {
    if (!_isBoxOpen()) {
      _box = await Hive.openBox<Task>(_boxName);
      debugPrint('Box $_boxName aberto com sucesso.');
    } else {
      debugPrint('Box $_boxName já está aberto.');
    }
  }

  Future<List<Task>> getTasksSortedByPriority() async {
    try {
      await _openBox();
      final tasks = _box.values.toList();
      tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
      return tasks;
    } catch (e, stacktrace) {
      throw AppError('Erro ao recuperar e classificar as tarefas',
          stackTrace: stacktrace);
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _openBox();
      await _box.add(task);
    } catch (e, stackTrace) {
      throw AppError('Erro ao adicionar task: $e', stackTrace: stackTrace);
    }
  }

  Future<void> updateTask(String taskId, Task updatedTask) async {
    try {
      await _openBox();
      final taskIndex =
          _box.values.toList().indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        await _box.putAt(taskIndex, updatedTask);
      } else {
        throw AppError('Erro: Tarefa não encontrada');
      }
    } catch (e, stackTrace) {
      throw AppError('Erro ao atualizar task: $e', stackTrace: stackTrace);
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _openBox();
      final taskIndex =
          _box.values.toList().indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        await _box.deleteAt(taskIndex);
      } else {
        throw AppError('Erro: Tarefa não encontrada');
      }
    } catch (e, stackTrace) {
      throw AppError('Erro ao excluir task: $e', stackTrace: stackTrace);
    }
  }

  void closeBox() {
    if (_isBoxOpen()) {
      _box.close();
      debugPrint('Box $_boxName fechado com sucesso.');
    }
  }
}
