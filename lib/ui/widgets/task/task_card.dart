import 'package:auto_size_text/auto_size_text.dart';
import 'package:to_do_app/ui/widgets/task/task_dialog.dart';
import 'package:to_do_app/utils/dependency_injection.dart';
import 'package:to_do_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/bloc/task_bloc.dart';
import 'package:to_do_app/bloc/task_event.dart';
import 'package:to_do_app/data/models/task.dart';
import 'package:to_do_app/data/models/task_priority.dart';
import 'package:to_do_app/ui/widgets/confirm_dialog.dart';
import 'package:to_do_app/utils/constants.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final TaskBloc bloc;
  const TaskCard({
    Key? key,
    required this.task,
    required this.bloc,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    Color priorityColor = widget.task.priority.color;
    return Container(
      height: size.height * 0.15,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Slidable(
        key: ValueKey(widget.task.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) =>
                  showTaskDialog(context, widget.bloc, task: widget.task),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Editar',
            ),
            SlidableAction(
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(30)),
              onPressed: (context) =>
                  deleteTaskConfirm(widget.task, context, widget.bloc),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Deletar',
            ),
          ],
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey[300]!),
              bottom: BorderSide(color: Colors.grey[300]!),
              right: BorderSide(color: Colors.grey[300]!),
              left: BorderSide(color: priorityColor, width: 4),
            ),
          ),
          child: CheckboxListTile(
            value: widget.task.isCompleted,
            onChanged: (value) {
              if (value != null) {
                final updatedTask = widget.task.copyWith(isCompleted: value);
                setState(() {
                  updatedTask.reminderDateTime = null;
                });
                getIt<FlutterLocalNotificationsPlugin>()
                    .cancel(widget.task.id.hashCode);
                widget.bloc.add(UpdateTask(
                    taskId: widget.task.id, updatedTask: updatedTask));
              }
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: EdgeInsets.only(left: kPadding(context) / 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(''),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            widget.task.title,
                            maxLines: 2,
                            style: widget.task.isCompleted
                                ? kTaskTitle.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey)
                                : kTaskTitle,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            widget.task.reminderDateTime != null
                                ? formatDateTime(widget.task.reminderDateTime!)
                                : '',
                            style: kHintTextStyle,
                          ),
                        ),
                        widget.task.reminderDateTime != null
                            ? SizedBox(height: size.height * 0.01)
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
