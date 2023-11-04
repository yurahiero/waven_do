// ignore_for_file: use_build_context_synchronously

import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/utils/helpers.dart';
import 'package:flutter/material.dart';

class ReminderInput extends StatefulWidget {
  final DateTime? selectedReminderDateTime;
  final Function(DateTime) onReminderDateTimeChanged;

  const ReminderInput({
    super.key,
    required this.selectedReminderDateTime,
    required this.onReminderDateTimeChanged,
  });

  @override
  State<ReminderInput> createState() => _ReminderInputState();
}

class _ReminderInputState extends State<ReminderInput> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.selectedReminderDateTime != null
            ? formatDateTime(widget.selectedReminderDateTime!)
            : 'Nenhum lembrete definido',
        style: GoogleFonts.roboto(
          color: widget.selectedReminderDateTime != null
              ? getTextTheme(context).bodyMedium!.color
              : Colors.grey,
        ),
      ),
      trailing: const Icon(Icons.edit),
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: widget.selectedReminderDateTime != null &&
                  widget.selectedReminderDateTime!.isBefore(DateTime.now())
              ? DateTime.now()
              : widget.selectedReminderDateTime ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (selectedDate != null) {
          final now = DateTime.now();
          selectedDate.day == now.day &&
                  selectedDate.month == now.month &&
                  selectedDate.year == now.year
              ? TimeOfDay.fromDateTime(now)
              : const TimeOfDay(hour: 0, minute: 0);
          final selectedTime = await showTimePicker(
            context: context,
            initialTime:
                TimeOfDay.fromDateTime(widget.selectedReminderDateTime ?? now),
          );
          if (selectedTime != null) {
            widget.onReminderDateTimeChanged(DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            ));
          }
        }
      },
    );
  }
}
