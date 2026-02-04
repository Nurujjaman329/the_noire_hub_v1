import 'package:get/get.dart';
import 'package:the_noire_hub_v1/core/constants/route_constants.dart';
import '../../../login/data/login_service.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final LoginService _loginService;
  LoginController(this._loginService);

  // --- UI State & Controllers ---
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var rememberMe = false.obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isLoggedInStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🚀 LoginController Initialized');
    checkLoginStatus();
  }

  @override
  void onClose() {
    debugPrint('🧹 LoginController disposing...');
    // Only dispose if they haven't been disposed by the framework already
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = "Please enter both email and password";
      // Optional: Show a quick snackbar for empty fields
      Get.snackbar("Error", "Email and Password are required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }

    debugPrint('🔐 Attempting login for: $email');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _loginService.login(email, password);

      // Check if the controller is still active before proceeding
      if (isClosed) return;

      if (response.code == 200 || response.code == 201) {
        isLoggedInStatus.value = true;

        Get.snackbar("Success", "Welcome back!",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));

        final userRole = response.data.attributes.user.role.toLowerCase();

        // The navigation happens here, which triggers onClose()
        if (userRole.contains('vendor') || userRole.contains('beautician')) {
          Get.offAllNamed(RouteConstants.vendorMainContainer, arguments: {'role': userRole});
        } else {
          Get.offAllNamed(RouteConstants.customerMainContainer);
        }
      } else {
        _showErrorSnackbar(response.message);
      }
    } catch (e) {
      if (isClosed) return; // Prevent updating UI if we've navigated away
      errorMessage.value = e.toString();
      _showErrorSnackbar("Login failed. Please check your connection.");
    } finally {
      // This is usually where the crash happens
      // Only update isLoading if the controller hasn't been disposed yet
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  Future<void> logout() async {
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      await _loginService.logout();
      isLoggedInStatus.value = false;

      // 2. Clear the navigation stack
      // We do NOT use Future.delayed here; we want the transition to start immediately
      Get.offAllNamed(RouteConstants.login);

    } catch (e) {
      _showErrorSnackbar("Logout failed: ${e.toString()}");
    }
  }

  // Helper method to keep code clean
  void _showErrorSnackbar(String message) {
    Get.snackbar("Error", message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
        icon: const Icon(Icons.error_outline, color: Colors.white));
  }

  Future<void> checkLoginStatus() async {
    isLoggedInStatus.value = await _loginService.isLoggedIn();
  }
}