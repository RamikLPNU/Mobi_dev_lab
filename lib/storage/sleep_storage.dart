import 'dart:convert';
import 'package:my_project/models/sleep_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SleepStorage {
  static const _key = 'sleep_entries';

  Future<void> saveEntries(List<SleepEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = entries.map((e) => e.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  Future<List<SleepEntry>> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List<dynamic> decoded = jsonDecode(jsonString) as List;
    return decoded.map((e) => SleepEntry.fromJson
      (e as Map<String, dynamic>),
    ).toList();
  }
}
