import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';

class ResetPasswordService {
  final ApiClient _apiClient;

  ResetPasswordService(this._apiClient);

  /// Final step: Resets the password using the OTP code sent to the email
  /// Endpoint usually expects: email, code (otp), and new password
  Future<bool> resetPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.postJson(
        ApiConstants.resetPassword,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Extract specific error message from the API response body
        final errorMsg = response.data['message'] ?? 'Failed to reset password';
        throw Exception(errorMsg);
      }
    } catch (e) {
      // If the error is a Dio error or network failure, extract the message
      rethrow;
    }
  }
}