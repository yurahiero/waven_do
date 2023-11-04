// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 3)
enum TaskPriority {
  Baixa,
  Media,
  Alta,
}

extension TaskPriorityExtension on TaskPriority {
  Color get color {
    switch (this) {
      case TaskPriority.Baixa:
        return Colors.green;
      case TaskPriority.Media:
        return Colors.yellow;
      case TaskPriority.Alta:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}

class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final typeId = 3;

  @override
  TaskPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskPriority.Baixa;
      case 1:
        return TaskPriority.Media;
      case 2:
        return TaskPriority.Alta;
      default:
        return TaskPriority.Baixa;
    }
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    switch (obj) {
      case TaskPriority.Baixa:
        writer.writeByte(0);
        break;
      case TaskPriority.Media:
        writer.writeByte(1);
        break;
      case TaskPriority.Alta:
        writer.writeByte(2);
        break;
    }
  }
}
