import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static LocalStorage? _instance;
  static SharedPreferences? _preferences;

  // lazy initialization
  static Future<LocalStorage> get instance async {
    _instance = _instance ?? LocalStorage();
    _preferences = _preferences ?? await SharedPreferences.getInstance();
    return _instance!;
  }

  reload() async {
    await _preferences?.reload();
  }

  // GETTERS & SETTERS

  cacheSearchQueries(String value) => _saveToDisk("searchQueries", value);
  List<String> readSearchQueries() {
    var rawString = _getFromDisk("searchQueries");
    return rawString == null
        ? <String>[]
        : List.castFrom<dynamic, String>(json.decode(rawString));
  }

  // stores data using type-specific methods
  void _saveToDisk<T>(String key, T content) {
    try {
      if (content is String) {
        _preferences?.setString(key, content);
      } else if (content is bool) {
        _preferences?.setBool(key, content);
      } else if (content is int) {
        _preferences?.setInt(key, content);
      } else if (content is double) {
        _preferences?.setDouble(key, content);
      } else if (content is List<String>) {
        _preferences?.setStringList(key, content);
      } else if (content is DateTime) {
        _preferences?.setString(key, content.toIso8601String());
      } else {
        _preferences?.remove(key);
      }
    } catch (_) {
      throw _;
    }
  }

  dynamic _getFromDisk(String key) {
    var value = _preferences?.get(key);
    return value;
  }
}
