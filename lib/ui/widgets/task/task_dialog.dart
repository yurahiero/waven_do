// ignore_for_file: use_build_context_synchronously

import 'package:to_do_app/data/models/task.dart';
import 'package:to_do_app/data/models/task_priority.dart';
import 'package:to_do_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/bloc/task_bloc.dart';
import 'package:to_do_app/bloc/task_event.dart';
import 'package:uuid/uuid.dart';
import 'package:validatorless/validatorless.dart';
import 'priority_selector.dart';
import 'reminder_input.dart';
import 'package:permission_handler/permission_handler.dart';

void showTaskDialog(BuildContext context, TaskBloc bloc, {Task? task}) async {
  final TextEditingController titleController =
      TextEditingController(text: task?.title ?? '');
  TaskPriority selectedPriority = task?.priority ?? TaskPriority.Baixa;
  DateTime? selectedReminderDateTime = task?.reminderDateTime;
  final Size size = MediaQuery.sizeOf(context);
  final formKey = GlobalKey<FormState>();

  PermissionStatus status = await Permission.notification.request();

  if (status.isGranted) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              alignment: Alignment.bottomCenter,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.020),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            style: kTaskTitle,
                            validator:
                                Validatorless.required('O campo é obrigatório'),
                            controller: titleController,
                            maxLength: 100,
                            decoration: const InputDecoration(
                                labelText: 'Título da tarefa'),
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
                          ),
                          PrioritySelector(
                            selectedPriority: selectedPriority,
                            onChanged: (value) {
                              setState(() {
                                selectedPriority = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ReminderInput(
                    selectedReminderDateTime: selectedReminderDateTime,
                    onReminderDateTimeChanged: (dateTime) {
                      setState(() {
                        selectedReminderDateTime = dateTime;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar', style: kTextButtonSyle),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      const uuid = Uuid();
                      Task newTask = Task(
                        id: task?.id ?? uuid.v4(),
                        title: titleController.text,
                        priority: selectedPriority,
                        reminderDateTime: selectedReminderDateTime,
                      );
                      if (task == null) {
                        bloc.add(
                          AddTask(
                            task: Task(
                              id: newTask.id,
                              title: newTask.title,
                              priority: newTask.priority,
                              reminderDateTime: newTask.reminderDateTime,
                            ),
                          ),
                        );
                      } else {
                        bloc.add(UpdateTask(
                            taskId: newTask.id, updatedTask: newTask));
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(task == null ? 'Adicionar' : 'Salvar',
                      style: kTextButtonSyle),
                ),
              ],
            );
          },
        );
      },
    );
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão de alarme não concedida')));
  }
}
