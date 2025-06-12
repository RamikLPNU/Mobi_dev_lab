import 'package:flutter/material.dart';
import 'package:my_project/models/sleep_entry.dart';

class RecommendedWakeTime extends StatelessWidget {
  final List<SleepEntry> entries;

  const RecommendedWakeTime({required this.entries, super.key});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox();

    final avgDuration = entries.map((e) => e.duration.inMinutes).
    reduce((a, b) => a + b) ~/ entries.length;
    final recommendation = DateTime.now().add(Duration(minutes: avgDuration));
    final formattedTime = '${recommendation.hour.toString().padLeft(2, '0')}:'
        '${recommendation.minute.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Рекомендований час для пробудження:', style:
        TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(formattedTime, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
