import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _booksKey = 'books';
  static const String _usersKey = 'users';

  static Future<void> saveData(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(data));
  }

  static Future<dynamic> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    return data != null ? json.decode(data) : null;
  }

  static Future<void> saveBooks(List<dynamic> books) async => saveData(_booksKey, books);
  static Future<List<dynamic>> getBooks() async => await getData(_booksKey) ?? [];

  static Future<void> saveUsers(Map<String, dynamic> users) async => saveData(_usersKey, users);
  static Future<Map<String, dynamic>> getUsers() async => await getData(_usersKey) ?? {};
}
