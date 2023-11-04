import 'package:to_do_app/bloc/item_bloc.dart';
import 'package:to_do_app/bloc/item_event.dart';
import 'package:to_do_app/bloc/task_bloc.dart';
import 'package:to_do_app/bloc/task_event.dart';
import 'package:to_do_app/data/models/item.dart';
import 'package:to_do_app/data/models/task.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text('Excluir'),
        ),
      ],
    );
  }
}

void deleteItemConfirm(Item item, BuildContext context, ItemBloc bloc) {
  showDialog(
    context: context,
    builder: (context) => ConfirmDialog(
      title: 'Excluir ${item.name}',
      content: 'Você tem certeza que deseja excluir "${item.name}"',
      onConfirm: () => bloc.add(DeleteItemEvent(item)),
    ),
  );
}

void deleteTaskConfirm(
  Task task,
  BuildContext context,
  TaskBloc bloc,
) {
  showDialog(
    context: context,
    builder: (context) => ConfirmDialog(
      title: 'Excluir ${task.title}',
      content: 'Você tem certeza que deseja excluir "${task.title}"?',
      onConfirm: () => bloc.add(DeleteTask(task.id)),
    ),
  );
}
