// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LocalStorage {
//   static SharedPreferences? _prefs;
//
//   static Future<void> init() async {
//     _prefs ??= await SharedPreferences.getInstance();
//   }
//
//   // --- Core Keys ---
//   static const String _keyToken = 'token';
//   static const String _keyUser = 'user_data';
//
//   // --- Token & ID Helpers ---
//   static String? get token => _prefs?.getString(_keyToken);
//   static Future<void> saveToken(String val) => _prefs!.setString(_keyToken, val);
//
//   // Get ID directly from the stored User Model
//   static String? get userId => userModel?.id;
//
//   // --- User Model Handling ---
//   static Future<void> saveUserModel(UserModel user) async {
//     await _prefs!.setString(_keyUser, jsonEncode(user.toJson()));
//   }
//
//   static UserModel? get userModel {
//     final data = _prefs?.getString(_keyUser);
//     return data != null ? UserModel.fromJson(jsonDecode(data)) : null;
//   }
//
//   // --- Clear Session ---
//   static Future<void> logout() async {
//     await _prefs!.remove(_keyToken);
//     await _prefs!.remove(_keyUser);
//   }
// }