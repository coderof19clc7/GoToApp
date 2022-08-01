import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageManager {
  static LocalStorageManager? _instance;
  static SharedPreferences? _sharedPreferences;

  LocalStorageManager._privateConstructor();

  static LocalStorageManager getInstance() {
    _instance ??= LocalStorageManager._privateConstructor();
    return _instance!;
  }

  static init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  bool? getBool(String key, bool? defaultValue) {
    return _sharedPreferences?.getBool(key) ?? defaultValue;
  }
  Future<void> setBool(String key, bool value) async {
    await _sharedPreferences?.setBool(key, value);
  }

  int? getInt(String key) {
    return _sharedPreferences?.getInt(key);
  }
  Future<void> setInt(String key, int value) async {
    await _sharedPreferences?.setInt(key, value);
  }

  double? getDouble(String key) {
    return _sharedPreferences?.getDouble(key);
  }
  Future<void> setDouble(String key, double value) async {
    await _sharedPreferences?.setDouble(key, value);
  }

  String? getString(String key) {
    return _sharedPreferences?.getString(key);
  }
  Future<void> setString(String key, String value) async {
    await _sharedPreferences?.setString(key, value);
  }

  Future<void> clearKey(String key) async {
    await _sharedPreferences?.remove(key);
  }
  Future<void> clearAll() async {
    await _sharedPreferences?.clear();
  }
}