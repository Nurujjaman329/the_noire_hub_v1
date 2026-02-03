
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('LocalStorage not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Generic methods
  static Future<bool> setData(String key, dynamic value) async {
    if (value is String) {
      return await prefs.setString(key, value);
    } else if (value is int) {
      return await prefs.setInt(key, value);
    } else if (value is double) {
      return await prefs.setDouble(key, value);
    } else if (value is bool) {
      return await prefs.setBool(key, value);
    } else if (value is List<String>) {
      return await prefs.setStringList(key, value);
    }
    return false;
  }

  static dynamic getData(String key, {dynamic defaultValue}) {
    return prefs.get(key) ?? defaultValue;
  }

  static Future<bool> removeData(String key) async {
    return await prefs.remove(key);
  }

  static Future<bool> clearAll() async {
    return await prefs.clear();
  }

  // Specific methods for common keys
  static Future<bool> setToken(String token) async {
    return await setData('token', token);
  }

  static String? getToken() {
    return getData('token');
  }

  static Future<bool> removeToken() async {
    return await removeData('token');
  }

  static Future<bool> setUserData(Map<String, dynamic> userData) async {
    return await setData('userData', userData.toString());
  }

  static Map<String, dynamic>? getUserData() {
    final userDataStr = getData('userData') as String?;
    if (userDataStr != null) {
      // Parse the string back to map - this would require json.decode in a real implementation
      return {'userData': userDataStr}; // Simplified for now
    }
    return null;
  }

  static Future<bool> setOnboardingCompleted(bool completed) async {
    return await setData('onboardingCompleted', completed);
  }

  static bool getOnboardingCompleted() {
    return getData('onboardingCompleted', defaultValue: false) as bool;
  }

  static Future<bool> setLanguage(String languageCode) async {
    return await setData('languageCode', languageCode);
  }

  static String getLanguage() {
    return getData('languageCode', defaultValue: 'en') as String;
  }

  static Future<bool> setThemeMode(String themeMode) async {
    return await setData('themeMode', themeMode);
  }

  static String getThemeMode() {
    return getData('themeMode', defaultValue: 'system') as String;
  }
}