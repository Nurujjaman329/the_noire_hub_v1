import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/change_password_service.dart';

class ChangePasswordController extends GetxController {
  final ChangePasswordService _service;
  ChangePasswordController(this._service);

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;
  var isOldVisible = false.obs;
  var isNewVisible = false.obs;
  var isConfirmVisible = false.obs;

  void toggleOldVisibility() => isOldVisible.toggle();
  void toggleNewVisibility() => isNewVisible.toggle();
  void toggleConfirmVisibility() => isConfirmVisible.toggle();

  Future<void> handleChangePassword() async {
    final oldPass = oldPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    // Basic Validations
    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar("Error", "All fields are required",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar("Mismatch", "New passwords do not match",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final success = await _service.changePassword(
        oldPassword: oldPass,
        newPassword: newPass,
      );

      if (success) {
        Get.back();
        // 1. Show the snackbar first
        Get.snackbar(
          "Success",
          "Your password has been changed.",
          backgroundColor: const Color(0xFFD9E8B9),
          colorText: const Color(0xFF1B3022),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2), // Ensure it has a set duration
        );

        // 2. Clear fields
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        // Future.delayed(const Duration(milliseconds: 500), () {
        //   if (Get.isOverlaysOpen) Get.back();
        //   Get.back(); // Go back to settings
        // });
      }
    } catch (e) {
      // CLEANING LOGIC: Removes "Exception:", "ServerException:", etc.
      String errorMsg = e.toString()
          .replaceAll(RegExp(r'^[a-zA-Z]*Exception.*:\s*'), '')
          .replaceAll(RegExp(r'^\(\d+\):\s*'), '')
          .trim();

      Get.snackbar(
        "Update Failed",
        errorMsg, // e.g., "Current password is wrong"
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}