import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_project/models/sleep_entry.dart';

class SleepChart extends StatelessWidget {
  final List<SleepEntry> entries;

  const SleepChart({required this.entries, super.key});

  @override
  Widget build(BuildContext context) {
    final data = entries.take(7).toList();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: data.asMap().entries.map((entry) {
            final i = entry.key;
            final e = entry.value;
            return BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                  color: Colors.indigo,
                  toY: e.duration.inHours.toDouble(),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
