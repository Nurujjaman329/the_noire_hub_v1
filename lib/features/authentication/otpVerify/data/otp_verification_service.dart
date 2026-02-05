



import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/local_storage.dart';

import 'package:flutter/foundation.dart';

import '../../login/data/login_response_model.dart';
import 'otp_verification_response_model.dart';

class OtpVerificationService {
  final ApiClient _apiClient;

  OtpVerificationService(this._apiClient);

  Future<OtpVerificationResponseModel> verifyOtp(String email, String otp, String flowType) async {
    debugPrint('📩 [OTP Request]: Email: $email, Code: $otp, Flow: $flowType');

    try {
      final response = await _apiClient.postJson(
        ApiConstants.verifyOtp,
        data: {
          'email': email,
          'code': otp,
        },
      );

      final verificationResponse = OtpVerificationResponseModel.fromJson(response.data);

      if (flowType != "forgot_password") {
        final attributes = verificationResponse.data.attributes;

        // Convert OtpUserModel to Map, then Map to the expected UserModel
        final userJson = attributes.user.toJson();
        final userModel = UserModel.fromJson(userJson);

        await Future.wait([
          LocalStorage.setAccessToken(attributes.tokens.access.token),
          LocalStorage.setRefreshToken(attributes.tokens.refresh.token),
          LocalStorage.setToken(attributes.tokens.access.token),
          LocalStorage.setUserModel(userModel),
        ]);
      }

      return verificationResponse;
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('🆘 [OTP Exception]: $e');
      throw UnknownException(e.toString());
    }
  }

  Future<void> resendOtp(String email) async {
    debugPrint('🔄 [Resend OTP]: $email');
    try {
      await _apiClient.postJson(
        ApiConstants.resendOtp,
        data: {'email': email},
      );
      debugPrint('✅ [Resend OTP Success]');
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}