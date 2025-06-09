import 'dart:convert';
import 'package:my_project/models/user.dart';
import 'package:my_project/storage/storage_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage implements Storage {
  static const _userKey = 'user_data';

  @override
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return null;

    final jsonRaw = jsonDecode(jsonString);
    if (jsonRaw is! Map) {
      throw const FormatException('Invalid user data format');
    }

    final Map<String, dynamic> json = Map<String, dynamic>.from(jsonRaw);
    return User.fromJson(json);
  }


  @override
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
