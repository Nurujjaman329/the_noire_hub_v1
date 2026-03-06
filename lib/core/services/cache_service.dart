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
  static const String _addressKey = 'user_address';
  static const String _latKey = 'user_lat';
  static const String _lonKey = 'user_lon';

  // --- Getters ---

  static double get lat => _prefs?.getDouble(_latKey) ?? 0.0;
  static double get lon => _prefs?.getDouble(_lonKey) ?? 0.0;

  static String get address {
    final value = _prefs?.getString(_addressKey) ?? '';
    debugPrint('🔑 Get address: $value');
    return value;
  }

  static String get formattedLocation {
    final String fullAddress = _prefs?.getString(_addressKey) ?? '';
    if (fullAddress.isEmpty) return '';

    // This assumes we save it as "City|Country" in saveSession
    final parts = fullAddress.split('|');
    if (parts.length == 2) {
      final city = parts[0].trim();
      final country = parts[1].trim();

      if (city.isNotEmpty && country.isNotEmpty) return '$city, $country';
      return city.isNotEmpty ? city : country;
    }
    return fullAddress;
  }


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
    String? address,
    double? lat,
    double? lon,
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

    if (address != null) {
      await _prefs?.setString(_addressKey, address);
      debugPrint('💾 address saved: $address');
    }

    if (lat != null) {
      await _prefs?.setDouble(_latKey, lat);
      debugPrint('💾 lat saved: $lat');
    }
    if (lon != null) {
      await _prefs?.setDouble(_lonKey, lon);
      debugPrint('💾 lon saved: $lon');
    }

  }

  static Future<void> clear() async {
    debugPrint('🧹 Clearing CacheService data...');
    await _prefs?.clear();
    debugPrint('🧹 CacheService cleared');
  }
}
