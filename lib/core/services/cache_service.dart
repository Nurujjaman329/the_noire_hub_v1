import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint('🟢 CacheService initialized');
  }

  // --- Keys ---
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _roleKey = 'user_role';
  static const String _businessNameKey = 'business_name';
  static const String _imageKey = 'user_image';
  static const String _fullNameKey = 'user_fullName';
  static const String _phoneKey = 'user_phone';
  static const String _bioKey = 'user_bio';

  // --- Getters ---
  static String get token {
    final value = _prefs?.getString(_tokenKey) ?? '';
    debugPrint('🔑 Get token: $value');
    return value;
  }

  static String get userId {
    final value = _prefs?.getString(_userIdKey) ?? '';
    debugPrint('🔑 Get userId: $value');
    return value;
  }

  static String get role {
    final value = _prefs?.getString(_roleKey) ?? '';
    debugPrint('🔑 Get role: $value');
    return value;
  }

  static String get businessName {
    final value = _prefs?.getString(_businessNameKey) ?? '';
    debugPrint('🔑 Get businessName: $value');
    return value;
  }

  static bool get isLoggedIn {
    final value = token.isNotEmpty;
    debugPrint('🔑 Check isLoggedIn: $value');
    return value;
  }

  static String get userImage {
    final value = _prefs?.getString(_imageKey) ?? '';
    debugPrint('🔑 Get userImage: $value');
    return value;
  }

  static String get userFullName {
    final value = _prefs?.getString(_fullNameKey) ?? '';
    debugPrint('🔑 Get userFullName: $value');
    return value;
  }

  static String get phone {
    final value = _prefs?.getString(_phoneKey) ?? '';
    debugPrint('🔑 Get phone: $value');
    return value;
  }

  static String get bio {
    final value = _prefs?.getString(_bioKey) ?? '';
    debugPrint('🔑 Get bio: $value');
    return value;
  }

  // --- Setters ---
  static Future<void> saveSession({
    required String token,
    required String userId,
    String? role,
    String? businessName,
    String? image,
    String? fullName,
    String? phone,
    String? bio,
  }) async {
    debugPrint('💾 Saving session...');
    await _prefs?.setString(_tokenKey, token);
    debugPrint('💾 token saved: $token');
    await _prefs?.setString(_userIdKey, userId);
    debugPrint('💾 userId saved: $userId');
    if (role != null) {
      await _prefs?.setString(_roleKey, role);
      debugPrint('💾 role saved: $role');
    }
    if (businessName != null) {
      await _prefs?.setString(_businessNameKey, businessName);
      debugPrint('💾 businessName saved: $businessName');
    }
    if (image != null) {
      await _prefs?.setString(_imageKey, image);
      debugPrint('💾 userImage saved: $image');
    }
    if (fullName != null) {
      await _prefs?.setString(_fullNameKey, fullName);
      debugPrint('💾 fullName saved: $fullName');
    }
    if (phone != null) {
      await _prefs?.setString(_phoneKey, phone);
      debugPrint('💾 phone saved: $phone');
    }
    if (bio != null) {
      await _prefs?.setString(_bioKey, bio);
      debugPrint('💾 bio saved: $bio');
    }
  }

  static Future<void> clear() async {
    debugPrint('🧹 Clearing CacheService data...');
    await _prefs?.clear();
    debugPrint('🧹 CacheService cleared');
  }
}
