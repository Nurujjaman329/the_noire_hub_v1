import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';

class ChangePasswordService {
  final ApiClient _apiClient;

  ChangePasswordService(this._apiClient);

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.postJson(
        ApiConstants.changePassword,
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Grab the backend message: e.g., "The current password you entered is incorrect"
        throw response.data['message'] ?? 'Failed to update password';
      }
    } catch (e) {
      // Re-throwing so the controller's catch block handles the specific AppException
      rethrow;
    }
  }
}