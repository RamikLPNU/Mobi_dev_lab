import 'package:flutter/material.dart';
import 'package:my_project/models/sleep_entry.dart';

class SleepHistoryList extends StatelessWidget {
  final List<SleepEntry> entries;
  final void Function(SleepEntry entry)? onEdit;

  const SleepHistoryList({required this.entries, super.key, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries.map((entry) {
        return ListTile(
          title: Text('${entry.sleepTime} → ${entry.wakeTime}'),
          subtitle: Text('Тривалість: ${entry.duration.inHours} '
              'год ${entry.duration.inMinutes % 60} хв'),
          trailing: onEdit != null
              ? IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => onEdit!(entry),
          )
              : null,
        );
      }).toList(),
    );
  }
}
