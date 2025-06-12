import 'package:flutter/material.dart';
import 'package:my_project/models/sleep_entry.dart';

class EditSleepEntryDialog extends StatefulWidget {
  final SleepEntry entry;
  const EditSleepEntryDialog({required this.entry, super.key});

  @override
  State<EditSleepEntryDialog> createState() => _EditSleepEntryDialogState();
}

class _EditSleepEntryDialogState extends State<EditSleepEntryDialog> {
  late DateTime _sleepTime;
  late DateTime _wakeTime;

  @override
  void initState() {
    super.initState();
    _sleepTime = widget.entry.sleepTime;
    _wakeTime = widget.entry.wakeTime;
  }

  Future<void> _pickSleepTime() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _sleepTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (!mounted) return;

      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_sleepTime),
      );
      if (time != null) {
        setState(() {
          _sleepTime = DateTime(
            picked.year, picked.month, picked.day,
            time.hour, time.minute,
          );
        });
      }
    }
  }

  Future<void> _pickWakeTime() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _wakeTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (!mounted) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_wakeTime),
      );
      if (time != null) {
        setState(() {
          _wakeTime = DateTime(
            picked.year, picked.month, picked.day,
            time.hour, time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редагувати запис сну'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: _pickSleepTime,
            child: Text('Час засинання: $_sleepTime'),
          ),
          TextButton(
            onPressed: _pickWakeTime,
            child: Text('Час пробудження: $_wakeTime'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Скасувати'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context,
            SleepEntry(sleepTime: _sleepTime, wakeTime: _wakeTime),
          ),
          child: const Text('Зберегти'),
        ),
      ],
    );
  }
}
