import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
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

      if (response.statusCode == 200) {
        final loginResponse = LoginResponseModel.fromJson(response.data);

        // Store the tokens in local storage
        await LocalStorage.setAccessToken(loginResponse.data.attributes.tokens.access.token);
        await LocalStorage.setRefreshToken(loginResponse.data.attributes.tokens.refresh.token);

        // Store user data in local storage
        await LocalStorage.setUserData(loginResponse.data.attributes.user.toJson());

        // Also store the main token for the API interceptor
        await LocalStorage.setToken(loginResponse.data.attributes.tokens.access.token);

        return loginResponse;
      } else {
        throw Exception('Failed to login: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
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