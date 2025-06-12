import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_project/models/sleep_entry.dart';
import 'package:my_project/services/mqtt_service.dart';
import 'package:my_project/storage/sleep_storage.dart';
import 'package:my_project/widgets/connection_status_banner.dart';
import 'package:my_project/widgets/device_connection_section.dart';
import 'package:my_project/widgets/edit_sleep_entry_dialog.dart';
import 'package:my_project/widgets/recommended_wake_time.dart';
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
  final MqttService _mqttService = MqttService();

  List<SleepEntry> _entries = [];
  DateTime? _tempSleepTime;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isConnected = false;

  bool _isDeviceConnected = false;
  String _currentState = 'Невідомо';

  @override
  void initState() {
    super.initState();
    _loadEntries();
    _startListening();
    _checkInitialConnection();
  }

  void _startListening() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
            (results) {
      final hasConnection = results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile);
      setState(() => _isConnected = hasConnection);
    });
  }

  Future<void> _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    final hasConnection = !result.contains(ConnectivityResult.none);
    setState(() => _isConnected = hasConnection);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    final data = await _storage.loadEntries();
    setState(() => _entries = data);
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

    final newEntry = SleepEntry(sleepTime: _tempSleepTime!,
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

  void _editEntry(SleepEntry entry) async {
    final editedEntry = await showDialog<SleepEntry>(
      context: context,
      builder: (context) => EditSleepEntryDialog(entry: entry),
    );

    if (editedEntry != null) {
      setState(() {
        final index = _entries.indexOf(entry);
        _entries[index] = editedEntry;
      });
      await _saveEntries();
    }
  }

  void _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистити історію?'),
        content: const Text('Цю дію неможливо скасувати.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: const Text('Скасувати'),
          ),
          TextButton(onPressed: () => Navigator.pop(context, true),
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

  void _connectDevice() async {
    await _mqttService.connect();
    _mqttService.subscribe();
    _mqttService.messages.listen((message) {
      final data = jsonDecode(message);
      final state = data['state'];
      final time = DateTime.parse(data['time'].toString());

      if (state == 'sleeping') {
        _addSleepEntry(time, null);
      } else if (state == 'awake') {
        _updateLastSleepEntry(time);
      }

      setState(() {
        _currentState = state == 'sleeping' ? 'Спить' : 'Прокинувся';
      });
    });

    setState(() {
      _isDeviceConnected = true;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Годинник підключено')),
    );
  }

  void _addSleepEntry(DateTime start, DateTime? end) {
    final alreadyExists = _entries.any((entry) => entry.sleepTime == start);

    if (!alreadyExists) {
      final newEntry = SleepEntry(sleepTime: start, wakeTime: end ??
          DateTime.now(),
      );
      setState(() {
        _entries.add(newEntry);
      });
      _saveEntries();
    }
  }

  void _updateLastSleepEntry(DateTime end) {
    if (_entries.isEmpty) return;

    final lastEntry = _entries.last;
    if (lastEntry.wakeTime == end) return;

    setState(() {
      final last = _entries.removeLast();
      _entries.add(SleepEntry(sleepTime: last.sleepTime, wakeTime: end));
    });
    _saveEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Розумний будильник'),
        actions: [
          IconButton(onPressed: _clearHistory, icon: const Icon(Icons.delete),
              tooltip: 'Очистити історію',
          ),
          IconButton(icon: const Icon(Icons.person), onPressed: () =>
              Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConnectionStatusBanner(isConnected: _isConnected),
            SleepChart(entries: _entries),
            const SizedBox(height: 20),
            RecommendedWakeTime(entries: _entries),
            const SizedBox(height: 20),
            SleepInputButtons(onSleep: _onSleep, onWake: _onWake),
            const SizedBox(height: 20),
            DeviceConnectionSection(
              isDeviceConnected: _isDeviceConnected,
              currentState: _currentState,
              onConnect: _connectDevice,
            ),
            const Text('Історія сну:', style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SleepHistoryList(entries: _entries, onEdit: _editEntry),
          ],
        ),
      ),
    );
  }
}
