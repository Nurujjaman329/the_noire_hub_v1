import 'package:get/get.dart';

import '../../../../../core/constants/route_constants.dart';
import 'package:flutter/material.dart';

import '../../data/otp_verification_service.dart';

class OtpVerificationController extends GetxController {
  final OtpVerificationService _service;
  OtpVerificationController(this._service);

  // --- OTP Specific Fields ---
  final List<TextEditingController> controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  var isLoading = false.obs;

  // Retrieve arguments (Handling both String and Map cases)
  late String email;
  late String flowType;

  @override
  void onInit() {
    super.onInit();
    // Safely parse arguments passed from GmailVerificationScreen
    final args = Get.arguments;
    if (args is Map) {
      email = args['email'] ?? "";
      flowType = args['flow'] ?? "verification_only";
    } else {
      email = args.toString();
      flowType = "verification_only";
    }
  }

  Future<void> verify() async {
    // 1. Combine digits into a String
    String otpString = controllers.map((e) => e.text).join();

    if (otpString.length < 4) {
      Get.snackbar("Incomplete", "Please enter the full 4-digit code",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    // NO NEED to parse to int. Keep it as String.
    isLoading.value = true;

    try {
      // Pass the otpString directly
      final response = await _service.verifyOtp(email, otpString);

      Get.snackbar("Success", response.message,
          backgroundColor: Colors.green, colorText: Colors.white);

      // 3. Navigation Logic
      if (flowType == "forgot_password") {
        Get.toNamed(RouteConstants.resetPasswordScreen, arguments: {"email": email});
      } else {
        final userRole = response.data.attributes.user.role.toLowerCase();
        if (userRole.contains('vendor') || userRole.contains('beautician')) {
          Get.offAllNamed(RouteConstants.vendorMainContainer);
        } else {
          Get.offAllNamed(RouteConstants.customerMainContainer);
        }
      }
    } catch (e) {
      String errorMsg = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar("Error", errorMsg, backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> resendCode() async {
    try {
      await _service.resendOtp(email);
      Get.snackbar("Sent", "New code has been sent to your email",
          backgroundColor: const Color(0xFFD9E8B9), colorText: const Color(0xFF1B3022));
    } catch (e) {
      Get.snackbar("Error", "Failed to resend code");
    }
  }

  @override
  void onClose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}