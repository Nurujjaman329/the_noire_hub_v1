import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

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

  // Token methods
  static Future<bool> setToken(String? token) async {
    return await prefs.setString('token', token ?? '');
  }

  static String? getToken() {
    return prefs.getString('token') ?? '';
  }

  static Future<bool> removeToken() async {
    return await prefs.remove('token');
  }

  // User ID methods
  static Future<bool> setUserId(String? userId) async {
    return await prefs.setString('userId', userId ?? '');
  }

  static String? getUserId() {
    return prefs.getString('userId');
  }

  static Future<bool> removeUserId() async {
    return await prefs.remove('userId');
  }

  // User Type methods
  static Future<bool> setUserType(String? userType) async {
    return await prefs.setString('userType', userType ?? '');
  }

  static String? getUserType() {
    return prefs.getString('userType');
  }

  static Future<bool> removeUserType() async {
    return await prefs.remove('userType');
  }

  // Login status methods
  static Future<bool> setIsLoggedIn(bool isLoggedIn) async {
    return await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  static bool getIsLoggedIn() {
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<bool> removeIsLoggedIn() async {
    return await prefs.remove('isLoggedIn');
  }

  // Clear all stored data
  static Future<bool> clearAll() async {
    return await prefs.clear();
  }
}