import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataStorage {
  static const String keyUser = 'user_data';
  static const String keyUserId = 'user_id';

  static Future<void> saveUser(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(keyUser, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(keyUser);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(keyUser);
  }
  
  static Future<void> saveUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyUserId, id);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyUserId);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(keyUserId);
  }
}
