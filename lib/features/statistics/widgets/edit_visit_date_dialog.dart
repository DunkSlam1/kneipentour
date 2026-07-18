import 'package:flutter/material.dart';

class EditVisitDateDialog extends StatefulWidget {
  final DateTime? initialDate;

  const EditVisitDateDialog({super.key, this.initialDate});

  @override
  State<EditVisitDateDialog> createState() => _EditVisitDateDialogState();
}

class _EditVisitDateDialogState extends State<EditVisitDateDialog> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    selectedDate = widget.initialDate ?? DateTime.now();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        selectedDate = DateTime(
          date.year,
          date.month,
          date.day,
          selectedDate.hour,
          selectedDate.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    if (time != null) {
      setState(() {
        selectedDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Erstbesuch bearbeiten'),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(
              '${selectedDate.day}.'
              '${selectedDate.month}.'
              '${selectedDate.year}',
            ),
            onTap: _pickDate,
          ),

          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(TimeOfDay.fromDateTime(selectedDate).format(context)),
            onTap: _pickTime,
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Abbrechen'),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, selectedDate);
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}
