import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/cache_service.dart';
import 'package:flutter/foundation.dart';
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

      // Only save session if it's not a password reset flow
      if (flowType != "forgot_password") {
        final attributes = verificationResponse.data.attributes;

        // --- Simplified Saving logic ---
        // No more manual mapping or Future.wait lists.
        // We just save the essentials to CacheService.

        await CacheService.saveSession(
          token: attributes.tokens.access.token,
          userId: attributes.user.id,
          role: attributes.user.role,
          businessName: attributes.user.businessName,
        );

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
    try {
      await _apiClient.postJson(
        ApiConstants.resendOtp,
        data: {'email': email},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}