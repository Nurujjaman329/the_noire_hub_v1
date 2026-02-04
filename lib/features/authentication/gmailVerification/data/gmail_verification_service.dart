

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'package:flutter/foundation.dart';

class GmailVerificationService {
  final ApiClient _apiClient;

  GmailVerificationService(this._apiClient);

  /// Sends a verification email to the user.
  /// Returns true if the email was sent successfully.
  Future<bool> sendVerificationEmail(String email) async {
    try {
      final response = await _apiClient.postJson(
        ApiConstants.verifyMail,
        data: {'email': email},
      );

      if (response.statusCode == 200 || response.data['code'] == 200) {
        return true;
      } else {
        throw response.data['message'] ?? 'Failed to send email';
      }
    } catch (e) {
      // If your ApiClient throws an error for 400/500, we need to extract the message
      // This logic depends on how your ApiClient is structured, but usually:
      if (e.toString().contains(':')) {
        // This splits "ServerException (400): Message" and takes the last part
        final parts = e.toString().split(':');
        throw parts.length > 1 ? parts.last.trim() : e.toString();
      }
      rethrow;
    }
  }
}