import 'package:flutter/material.dart';
import 'package:my_project/models/sleep_entry.dart';

class SleepHistoryList extends StatelessWidget {
  final List<SleepEntry> entries;

  const SleepHistoryList({required this.entries, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries.reversed.map((entry) {
        return ListTile(
          title: Text('Sleep: ${entry.sleepTime}'),
          subtitle: Text('Wake: ${entry.wakeTime}'),
          trailing: Text('${entry.duration.inHours}h'),
        );
      }).toList(),
    );
  }
}
