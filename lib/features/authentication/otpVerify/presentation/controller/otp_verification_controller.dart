import 'package:get/get.dart';

import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/controllers/profile_controller.dart';
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
    String otpString = controllers.map((e) => e.text).join();

    if (otpString.length < 4) {
      Get.snackbar("Incomplete", "Please enter the full 4-digit code",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      // Pass flowType here ------------------------👇
      final response = await _service.verifyOtp(email, otpString, flowType);

      Get.snackbar("Success", response.message,
          backgroundColor: const Color(0xFFD9E8B9), colorText: const Color(0xFF1B3022));

      if (flowType == "forgot_password") {
        Get.toNamed(RouteConstants.resetPasswordScreen, arguments: {"email": email});
      } else {
        // Normal flow: Storage happened in service, now refresh ProfileController
        // This ensures all screens immediately see updated location, address, etc.
        final profileController = Get.find<ProfileController>();
        profileController.refreshProfile();
        
        // Navigate to Home
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