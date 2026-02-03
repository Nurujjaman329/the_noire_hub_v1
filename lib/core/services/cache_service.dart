import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  // Singleton Pattern
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  late SharedPreferences _prefs;

  /// Initialize the SharedPreferences instance
  /// Call this in main(): await CacheService().init();
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Generic Methods ---

  bool containsKey(String key) => _prefs.containsKey(key);

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clear() => _prefs.clear();

  // --- Type-Specific Getters (Synchronous) ---

  String getString(String key, {String defaultValue = ''}) =>
      _prefs.getString(key) ?? defaultValue;

  bool getBool(String key, {bool defaultValue = false}) =>
      _prefs.getBool(key) ?? defaultValue;

  int getInt(String key, {int defaultValue = 0}) =>
      _prefs.getInt(key) ?? defaultValue;

  double getDouble(String key, {double defaultValue = 0.0}) =>
      _prefs.getDouble(key) ?? defaultValue;

  List<String> getStringList(String key) =>
      _prefs.getStringList(key) ?? [];

  // --- Type-Specific Setters (Asynchronous) ---

  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);

  Future<bool> setStringList(String key, List<String> value) => _prefs.setStringList(key, value);
}