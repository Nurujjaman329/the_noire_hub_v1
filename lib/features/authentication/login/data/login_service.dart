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

      await LocalStorage.setAccessToken(
          loginResponse.data.attributes.tokens.access.token);
      await LocalStorage.setRefreshToken(
          loginResponse.data.attributes.tokens.refresh.token);
      await LocalStorage.setUserData(
          loginResponse.data.attributes.user.toJson());
      await LocalStorage.setToken(
          loginResponse.data.attributes.tokens.access.token);

      return loginResponse;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

    Future<void> logout() async {
    try {
      // Remove tokens and user data from local storage
      await LocalStorage.removeAccessToken();
      await LocalStorage.removeRefreshToken();
      await LocalStorage.removeUserData();
      await LocalStorage.removeToken(); // Remove the main token too
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    final accessToken = LocalStorage.getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
}