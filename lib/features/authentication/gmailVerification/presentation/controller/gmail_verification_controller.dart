import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../data/gmail_verification_service.dart';


class GmailVerificationController extends GetxController {
  final GmailVerificationService _service;
  GmailVerificationController(this._service);

  var isLoading = false.obs;
  final emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    // Extract email from arguments (String or Map)
    if (args is String) {
      emailController.text = args;
    } else if (args is Map && args.containsKey('email')) {
      emailController.text = args['email'];
    }
  }

  // Inside GmailVerificationController

  Future<void> sendVerificationCode() async {
    final email = emailController.text.trim();
    final dynamic args = Get.arguments;
    final String flowType = (args is Map) ? (args['flow'] ?? "registration") : "registration";

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar("Invalid Email", "Please enter a valid email address",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final isSent = await _service.sendVerificationEmail(email);

      if (isSent) {
        Get.snackbar("Success", "Verification code sent to $email",
            backgroundColor: const Color(0xFFD9E8B9), colorText: const Color(0xFF1B3022));

        if (Get.currentRoute != RouteConstants.otpVerifyScreen) {
          Get.toNamed(RouteConstants.otpVerifyScreen, arguments: {
            "email": email,
            "flow": flowType,
          });
        }
      }
    } catch (e) {
      // CLEANING LOGIC:
      // This regex removes common exception prefixes like "Exception: ", "ServerException: ", or "(400): "
      String errorMsg = e.toString()
          .replaceAll(RegExp(r'^[a-zA-Z]+Exception.*:\s*'), '')
          .replaceAll(RegExp(r'^\(\d+\):\s*'), '')
          .trim();

      Get.snackbar(
        "Verification Failed",
        errorMsg, // Now shows "No users found with this email"
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}