import 'package:flutter/material.dart';
import 'package:my_project/models/sleep_entry.dart';
import 'package:my_project/storage/sleep_storage.dart';
import 'package:my_project/widgets/sleep_chart.dart';
import 'package:my_project/widgets/sleep_history_list.dart';
import 'package:my_project/widgets/sleep_input_buttons.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SleepStorage _storage = SleepStorage();
  List<SleepEntry> _entries = [];
  DateTime? _tempSleepTime;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final data = await _storage.loadEntries();
    setState(() {
      _entries = data;
    });
  }

  Future<void> _saveEntries() async {
    await _storage.saveEntries(_entries);
  }

  void _onSleep() {
    setState(() {
      _tempSleepTime = DateTime.now();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Час засинання збережено')),
      );
    });
  }

  void _onWake() async {
    if (_tempSleepTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Спочатку натисніть "Ліг спати"')),
      );
      return;
    }

    final newEntry = SleepEntry(
      sleepTime: _tempSleepTime!,
      wakeTime: DateTime.now(),
    );

    setState(() {
      _entries.add(newEntry);
      _tempSleepTime = null;
    });

    await _saveEntries();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Запис збережено')),
    );
  }

  void _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистити історію?'),
        content: const Text('Це дію неможливо скасувати.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Очистити'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _entries.clear());
      await _saveEntries();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Історію очищено')),
      );
    }
  }

  Widget _buildRecommendedTime() {
    if (_entries.isEmpty) return const SizedBox();

    final avgDuration = _entries
        .map((e) => e.duration.inMinutes)
        .reduce((a, b) => a + b) ~/
        _entries.length;

    final recommendation = DateTime.now().add(Duration(minutes: avgDuration));
    final formattedTime =
        '${recommendation.hour.toString().padLeft(2, '0')}:'
        '${recommendation.minute.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Рекомендований час для пробудження:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(formattedTime, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Розумний будильник'),
        actions: [
          IconButton(
            onPressed: _clearHistory,
            icon: const Icon(Icons.delete),
            tooltip: 'Очистити історію',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SleepChart(entries: _entries),
            const SizedBox(height: 20),
            _buildRecommendedTime(),
            const SizedBox(height: 20),
            SleepInputButtons(
              onSleep: _onSleep,
              onWake: _onWake,
            ),
            const SizedBox(height: 20),
            const Text(
              'Історія сну:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SleepHistoryList(entries: _entries),
          ],
        ),
      ),
    );
  }
}
