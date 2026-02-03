import 'package:get/get.dart';
import 'package:the_noire_hub_v1/core/constants/route_constants.dart';
import '../../../../../core/storage/local_storage.dart';
import '../../../login/data/login_service.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final LoginService _loginService;

  LoginController(this._loginService);

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isLoggedInStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🚀 LoginController Initialized');
    checkLoginStatus();
  }

  Future<void> login(String email, String password) async {
    debugPrint('🔐 Attempting login for: $email');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _loginService.login(email, password);
      debugPrint('📡 Login Response Code: ${response.code}');

      if (response.code == 200 || response.code == 201) {
        isLoggedInStatus.value = true;

        // Determine user role and navigate accordingly
        final userRole = response.data.attributes.user.role.toLowerCase();
        debugPrint('👤 User Role: $userRole');

        if (userRole.contains('customer') || userRole.contains('user')) {
          debugPrint('🛍️ Customer role detected. Navigating to Customer Main Container...');
          Get.offAllNamed(RouteConstants.customerMainContainer);
        } else if (userRole.contains('vendor') || userRole.contains('beautician')) {
          debugPrint('💇‍♀️ Vendor/Beautician role detected. Navigating to Vendor Main Container...');
          Get.offAllNamed(RouteConstants.vendorMainContainer);
        } else {
          // Default to customer container if role is unknown
          debugPrint('❓ Unknown role. Defaulting to Customer Main Container...');
          Get.offAllNamed(RouteConstants.customerMainContainer);
        }
      } else {
        errorMessage.value = response.message;
        debugPrint('⚠️ Login Failed: ${response.message}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('❌ Error during login: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    debugPrint('🚪 Logging out...');
    try {
      await _loginService.logout();
      isLoggedInStatus.value = false;
      debugPrint('👋 Logout successful. Redirecting to Login screen.');
      Get.offAllNamed(RouteConstants.login);
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('❌ Error during logout: $e');
    }
  }

  Future<void> checkLoginStatus() async {
    isLoggedInStatus.value = await _loginService.isLoggedIn();
    debugPrint('🧐 Initial Login Check: ${isLoggedInStatus.value ? "Logged In" : "Logged Out"}');
  }

  String? getStoredAccessToken() {
    final token = LocalStorage.getAccessToken();
    debugPrint('🔑 Access Token retrieved: ${token != null ? "EXISTS" : "NULL"}');
    return token;
  }

  String? getStoredRefreshToken() {
    return LocalStorage.getRefreshToken();
  }

  Map<String, dynamic>? getStoredUserData() {
    return LocalStorage.getUserData();
  }
}