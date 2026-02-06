import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/authentication/login/data/login_response_model.dart';

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

  // --- Generic Storage Methods ---
  static Future<bool> setData(String key, dynamic value) async {
    if (value is String) return await prefs.setString(key, value);
    if (value is int) return await prefs.setInt(key, value);
    if (value is double) return await prefs.setDouble(key, value);
    if (value is bool) return await prefs.setBool(key, value);
    if (value is List<String>) return await prefs.setStringList(key, value);
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

  // --- Token Management ---
  // Access Token
  static Future<bool> setAccessToken(String token) => setData('accessToken', token);
  static String? getAccessToken() => getData('accessToken');
  static Future<bool> removeAccessToken() => removeData('accessToken');

  // Refresh Token
  static Future<bool> setRefreshToken(String token) => setData('refreshToken', token);
  static String? getRefreshToken() => getData('refreshToken');
  static Future<bool> removeRefreshToken() => removeData('refreshToken');

  // Generic Token (Used in your Service)
  static Future<bool> setToken(String token) => setData('token', token);
  static String? getToken() => getData('token');
  static Future<bool> removeToken() => removeData('token');

  // --- User Model Management ---

  /// Saves the entire UserModel object to local storage
  static Future<bool> setUserModel(UserModel user) async {
    try {
      final String userJson = jsonEncode(user.toJson());
      return await setData('userData', userJson);
    } catch (e) {
      debugPrint('Error encoding UserModel: $e');
      return false;
    }
  }

  /// Retrieves the UserModel object with full type safety
  static UserModel? getUserModel() {
    final String? userStr = getData('userData');
    if (userStr != null) {
      try {
        return UserModel.fromJson(jsonDecode(userStr));
      } catch (e) {
        debugPrint('Error parsing UserModel: $e');
        return null;
      }
    }
    return null;
  }

  /// Helper to check if a user is logged in based on model existence
  static bool hasUserModel() => getUserModel() != null;

  // --- App Settings ---
  static Future<bool> setOnboardingCompleted(bool completed) => setData('onboardingCompleted', completed);
  static bool getOnboardingCompleted() => getData('onboardingCompleted', defaultValue: false);

  static Future<bool> setLanguage(String code) => setData('languageCode', code);
  static String getLanguage() => getData('languageCode', defaultValue: 'en');

  static Future<bool> setThemeMode(String mode) => setData('themeMode', mode);
  static String getThemeMode() => getData('themeMode', defaultValue: 'system');

  // --- Logout Helper ---
  /// Clears all session data while preserving app settings (Language/Theme)
  static Future<void> clearUserSession() async {
    await removeAccessToken();
    await removeRefreshToken();
    await removeToken();
    await removeData('userData');
  }
}