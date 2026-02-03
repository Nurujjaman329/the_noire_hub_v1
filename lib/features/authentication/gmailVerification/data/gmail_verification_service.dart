//
//
// import '../../../../core/api/api_client.dart';
// import '../../../../core/constants/api_constants.dart';
// import '../../../../core/storage/local_storage.dart';
// import 'gmail_verification_response_model.dart';
//
// import 'package:flutter/foundation.dart';
//
// class GmailVerificationService {
//   final ApiClient _apiClient;
//
//   GmailVerificationService(this._apiClient);
//
//   Future<GmailVerificationResponseModel> verifyOtp(String email, String otp) async {
//     debugPrint('📩 [OTP Verify Request]: Email: $email, Code: $otp');
//
//     try {
//       final response = await _apiClient.postJson(
//         ApiConstants.verifyEmail,
//         data: {
//           'email': email,
//           'code': otp,
//         },
//       );
//
//       debugPrint('📡 [OTP Verify Response Status]: ${response.statusCode}');
//       debugPrint('📦 [OTP Verify Response Data]: ${response.data}');
//
//       if (response.statusCode == 200) {
//         final verificationResponse = GmailVerificationResponseModel.fromJson(response.data);
//
//         // 1. Store Tokens
//         String accessToken = verificationResponse.data.attributes.tokens.access.token;
//         await LocalStorage.setAccessToken(accessToken);
//         await LocalStorage.setRefreshToken(verificationResponse.data.attributes.tokens.refresh.token);
//         await LocalStorage.setToken(accessToken);
//
//         debugPrint('🔑 [Storage]: Access & Refresh Tokens stored successfully');
//
//         // 2. Store User Data
//         var userData = verificationResponse.data.attributes.user.toJson();
//         await LocalStorage.setUserData(userData);
//
//         debugPrint('👤 [Storage]: User Profile data stored successfully');
//
//         return verificationResponse;
//       } else {
//         String errorMsg = response.data['message'] ?? 'Verification failed';
//         debugPrint('⚠️ [OTP Verify Failed]: $errorMsg');
//         throw Exception(errorMsg);
//       }
//     } catch (e) {
//       debugPrint('🆘 [OTP Verify Exception]: $e');
//       rethrow;
//     }
//   }
//
//   Future<void> resendOtp(String email) async {
//     debugPrint('🔄 [Resend OTP Request]: Email: $email');
//     try {
//       final response = await _apiClient.postJson(
//         ApiConstants.resendOtp,
//         data: {'email': email},
//       );
//       debugPrint('📡 [Resend OTP Response]: ${response.statusCode} - ${response.data}');
//     } catch (e) {
//       debugPrint('🆘 [Resend OTP Exception]: $e');
//       rethrow;
//     }
//   }
// }