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

      if (flowType != "forgot_password") {
        final attributes = verificationResponse.data.attributes;
        final user = attributes.user;

        // --- 1. Extract Address & Coordinates ---
        String? combinedAddress;
        double? latitude;
        double? longitude;

        if (user.addresses.isNotEmpty) {
          final addr = user.addresses.firstWhere(
                (a) => a.isDefault,
            orElse: () => user.addresses.first,
          );

          combinedAddress = "${addr.city}|${addr.country}";

          if (addr.location.coordinates.length >= 2) {
            // Standard GeoJSON: [longitude, latitude]
            longitude = addr.location.coordinates[0];
            latitude = addr.location.coordinates[1];
          }
        }

        // --- 2. Save everything to CacheService ---
        await CacheService.saveSession(
          token: attributes.tokens.access.token,
          userId: user.id,
          role: user.role,
          businessName: user.businessName,
          fullName: user.fullName,
          image: user.image,
          address: combinedAddress,
          lat: latitude,  // ✅ Added Lat
          lon: longitude, // ✅ Added Lon
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