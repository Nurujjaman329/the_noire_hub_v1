import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
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
  static String get token => _prefs?.getString(_tokenKey) ?? '';
  static String get userId => _prefs?.getString(_userIdKey) ?? '';
  static String get role => _prefs?.getString(_roleKey) ?? '';
  static String get businessName => _prefs?.getString(_businessNameKey) ?? '';
  static bool get isLoggedIn => token.isNotEmpty;
  static String get userImage => _prefs?.getString(_imageKey) ?? '';
  static String get userFullName => _prefs?.getString(_fullNameKey) ?? '';
  static String get phone => _prefs?.getString(_phoneKey) ?? '';
  static String get bio => _prefs?.getString(_bioKey) ?? '';

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
    await _prefs?.setString(_tokenKey, token);
    await _prefs?.setString(_userIdKey, userId);
    if (role != null) await _prefs?.setString(_roleKey, role);
    if (businessName != null) await _prefs?.setString(_businessNameKey, businessName);
    if (image != null) await _prefs?.setString(_imageKey, image);
    if (fullName != null) await _prefs?.setString(_fullNameKey, fullName);
    if (phone != null) await _prefs?.setString(_phoneKey, phone);
    if (bio != null) await _prefs?.setString(_bioKey, bio);

  }

  static Future<void> clear() async {
    await _prefs?.clear();
  }
}