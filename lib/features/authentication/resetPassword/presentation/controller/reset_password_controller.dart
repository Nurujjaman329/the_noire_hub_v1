import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../data/reset_password_service.dart';

class ResetPasswordController extends GetxController {
  final ResetPasswordService _service;
  ResetPasswordController(this._service);

  // --- Controllers ---
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // --- State Variables ---
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // Retrieve email passed from OTP/Verification screen
  late String email;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      email = args['email'] ?? "";
    } else {
      email = args ?? "";
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  /// Handles the password reset API call
  Future<void> handleResetPassword() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // 1. Basic Validation
    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (password.length < 6) {
      Get.snackbar("Weak Password", "Password must be at least 6 characters",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Mismatch", "Passwords do not match",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      // 2. Call Service
      final bool success = await _service.resetPassword(
        email: email,
        password: password,
      );

      if (success) {
        Get.snackbar(
          "Success",
          "Your password has been reset successfully!",
          backgroundColor: const Color(0xFFD9E8B9),
          colorText: const Color(0xFF1B3022),
          snackPosition: SnackPosition.BOTTOM,
        );

        // 3. Navigate back to Login
        // offAllNamed prevents the user from going back to the reset screen
        Get.offAllNamed(RouteConstants.login);
      }
    } catch (e) {
      String errorMsg = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar("Reset Failed", errorMsg,
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}