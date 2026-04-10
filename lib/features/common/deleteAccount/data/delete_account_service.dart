import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/cache_service.dart';

class DeleteAccountService {
  final ApiClient _apiClient;

  DeleteAccountService(this._apiClient);

  /// Delete the authenticated user's account
  Future<void> deleteAccount(String password) async {
    try {
      await _apiClient.postJson(
        ApiConstants.deleteMe,
        data: {'password': password},
      );

      // Clear session after successful deletion
      await CacheService.clear();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}
