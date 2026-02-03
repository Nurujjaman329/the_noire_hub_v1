// import 'package:get/get.dart';
//
// import '../../../../../core/constants/route_constants.dart';
// import '../../data/gmail_verification_service.dart';
// import 'package:flutter/material.dart';
//
// class GmailVerificationController extends GetxController {
//   final GmailVerificationService _service;
//   GmailVerificationController(this._service);
//
//   // --- State Variables ---
//   final otpController = TextEditingController();
//   var isLoading = false.obs;
//
//   final emailController = TextEditingController();
//
//   // Retrieve email passed from Registration screen
//   final String email = Get.arguments ?? "";
//
//   Future<void> verify() async {
//     final otp = otpController.text.trim();
//
//     if (otp.length < 4) { // Adjust length based on your OTP requirement
//       Get.snackbar("Invalid OTP", "Please enter a valid verification code",
//           backgroundColor: Colors.orange, colorText: Colors.white);
//       return;
//     }
//
//     isLoading.value = true;
//
//     try {
//       final response = await _service.verifyOtp(email, otp);
//
//       Get.snackbar("Success", response.message,
//           backgroundColor: Colors.green, colorText: Colors.white);
//
//       // --- Role Based Navigation ---
//       final userRole = response.data.attributes.user.role.toLowerCase();
//
//       if (userRole.contains('vendor') || userRole.contains('beautician')) {
//         Get.offAllNamed(RouteConstants.vendorMainContainer);
//       } else {
//         Get.offAllNamed(RouteConstants.customerMainContainer);
//       }
//
//     } catch (e) {
//       String errorMsg = e.toString().replaceFirst('Exception: ', '');
//       Get.snackbar("Verification Failed", errorMsg,
//           backgroundColor: Colors.redAccent, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//
//   Future<void> sendCode(String flowType) async {
//     final email = emailController.text.trim();
//
//     if (email.isEmpty || !GetUtils.isEmail(email)) {
//       Get.snackbar("Error", "Please enter a valid email address",
//           backgroundColor: Colors.redAccent, colorText: Colors.white);
//       return;
//     }
//
//     isLoading.value = true;
//     try {
//       if (flowType == "forgot_password") {
//         // await _service.requestPasswordReset(email); // Add this to your service
//       } else {
//         await _service.resendOtp(email);
//       }
//
//       Get.snackbar(
//           "Success",
//           flowType == "forgot_password" ? "Reset code sent!" : "Verification code sent!",
//           backgroundColor: const Color(0xFFD9E8B9),
//           colorText: const Color(0xFF1B3022)
//       );
//
//       // Navigate to OTP Screen and pass email + flow
//       Get.toNamed(RouteConstants.otpVerifyScreen, arguments: {
//         "email": email,
//         "flow": flowType
//       });
//
//     } catch (e) {
//       Get.snackbar("Error", e.toString(), backgroundColor: Colors.redAccent, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     otpController.dispose();
//     super.onClose();
//   }
// }