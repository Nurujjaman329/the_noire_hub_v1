import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/local_storage.dart';
import 'login_response_model.dart';

class LoginService {
  final ApiClient _apiClient;

  LoginService(this._apiClient);

  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await _apiClient.postJson(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final loginResponse = LoginResponseModel.fromJson(response.data);
      final attributes = loginResponse.data.attributes;

      // Batch saving data to LocalStorage
      // Using the specific model setter we defined for type safety
      await Future.wait([
        LocalStorage.setAccessToken(attributes.tokens.access.token),
        LocalStorage.setRefreshToken(attributes.tokens.refresh.token),
        LocalStorage.setToken(attributes.tokens.access.token),
        LocalStorage.setUserModel(attributes.user),
      ]);

      return loginResponse;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      // Use the centralized helper from LocalStorage
      // This ensures session data is cleared but settings (theme/lang) remain
      await LocalStorage.clearUserSession();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    final accessToken = LocalStorage.getAccessToken();
    // Use the helper method we added to check for the user model
    return accessToken != null && accessToken.isNotEmpty && LocalStorage.hasUserModel();
  }
}