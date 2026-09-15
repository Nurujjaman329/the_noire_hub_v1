import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/utils/auth_role_guard.dart';
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

        AuthRoleGuard.ensureAllowed(user.role);

        debugPrint(
          '📥 [OTP_VERIFY_RES] userId=${user.id}, role=${user.role}, email=${user.email}, '
          'addressesCount=${user.addresses.length}',
        );

        // --- 1. Extract Address & Coordinates ---
        String? combinedAddress;
        double? latitude;
        double? longitude;

        if (user.addresses.isNotEmpty) {
          for (int i = 0; i < user.addresses.length; i++) {
            final a = user.addresses[i];
            final lon = a.location.coordinates.isNotEmpty ? a.location.coordinates[0] : null;
            final lat = a.location.coordinates.length > 1 ? a.location.coordinates[1] : null;
            debugPrint(
              '📥 [OTP_VERIFY_RES] address[$i] city=${a.city}, country=${a.country}, '
              'lat=$lat, lon=$lon, isDefault=${a.isDefault}',
            );
          }

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
        debugPrint(
          '💾 [OTP_CACHE_WRITE] address=$combinedAddress, lat=$latitude, lon=$longitude',
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