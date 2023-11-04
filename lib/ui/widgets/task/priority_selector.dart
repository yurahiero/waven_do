import 'package:to_do_app/data/models/task_priority.dart';
import 'package:to_do_app/utils/constants.dart';
import 'package:flutter/material.dart';

class PrioritySelector extends StatelessWidget {
  final TaskPriority selectedPriority;
  final ValueChanged<TaskPriority> onChanged;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: TaskPriority.values.reversed.map((priority) {
        return RadioListTile<TaskPriority>(
          contentPadding: EdgeInsets.zero,
          activeColor: priority.color,
          value: priority,
          groupValue: selectedPriority,
          onChanged: (value) {
            onChanged(value!);
          },
          title: Text(
            priority.toString().split('.')[1],
            style: kTaskTitle,
          ),
        );
      }).toList(),
    );
  }
}
