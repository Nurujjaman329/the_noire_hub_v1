

import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/local_storage.dart';
import 'otp_verification_response_model.dart';

import 'package:flutter/foundation.dart';

class OtpVerificationService {
  final ApiClient _apiClient;

  OtpVerificationService(this._apiClient);

  Future<OtpVerificationResponseModel> verifyOtp(String email, String otp, String flowType) async {
    debugPrint('📩 [OTP Verify Request]: Email: $email, Code: $otp, Flow: $flowType');

    try {
      final response = await _apiClient.postJson(
        ApiConstants.verifyOtp,
        data: {
          'email': email,
          'code': otp,
        },
      );

      if (response.statusCode == 200) {
        final verificationResponse = OtpVerificationResponseModel.fromJson(response.data);

        // ONLY store tokens if it is NOT a forgot password flow
        if (flowType != "forgot_password") {
          // 1. Store Tokens
          String accessToken = verificationResponse.data.attributes.tokens.access.token;
          await LocalStorage.setAccessToken(accessToken);
          await LocalStorage.setRefreshToken(verificationResponse.data.attributes.tokens.refresh.token);
          await LocalStorage.setToken(accessToken);

          // 2. Store User Data
          var userData = verificationResponse.data.attributes.user.toJson();
          await LocalStorage.setUserData(userData);

          debugPrint('🔑 [Storage]: Auth data saved for registration/login flow');
        } else {
          debugPrint('🛡️ [Storage]: Skipped token storage for forgot_password flow');
        }

        return verificationResponse;
      } else {
        String errorMsg = response.data['message'] ?? 'Verification failed';
        throw Exception(errorMsg);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendOtp(String email) async {
    debugPrint('🔄 [Resend OTP Request]: Email: $email');
    try {
      final response = await _apiClient.postJson(
        ApiConstants.resendOtp,
        data: {'email': email},
      );

      debugPrint('📡 [Resend OTP Response Status]: ${response.statusCode}');

      // Some APIs return 200 but the "code" inside the body is what matters
      final responseData = response.data;
      if (response.statusCode == 200) {
        debugPrint('✅ [Resend OTP Success]: ${responseData['message']}');
      } else {
        throw Exception(responseData['message'] ?? "Failed to resend code");
      }
    } on DioException catch (e) {
      // Catch Dio specific errors to see the real server message
      String serverMsg = e.response?.data['message'] ?? "Connection Error";
      debugPrint('🆘 [Dio Error]: $serverMsg');
      throw Exception(serverMsg);
    } catch (e) {
      debugPrint('🆘 [Resend OTP Exception]: $e');
      rethrow;
    }
  }
}