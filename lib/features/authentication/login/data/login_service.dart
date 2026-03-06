import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/cache_service.dart';
import 'login_response_model.dart';

class LoginService {
  final ApiClient _apiClient;

  LoginService(this._apiClient);

  /// Login with email & password
  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await _apiClient.postJson(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final loginResponse = LoginResponseModel.fromJson(response.data);
      final attr = loginResponse.data.attributes;
      final user = attr.user;
      double? latitude;
      double? longitude;

      String? combinedAddress;

      if (user.addresses.isNotEmpty) {
        final addr = user.addresses.firstWhere(
                (a) => a.isDefault,
            orElse: () => user.addresses.first
        );
        combinedAddress = "${addr.city}|${addr.country}";

        // coordinates are usually [longitude, latitude] in GeoJSON
        if (addr.location.coordinates.length >= 2) {
          longitude = addr.location.coordinates[0];
          latitude = addr.location.coordinates[1];
        }
      }

      // Save specific fields to cache
      await CacheService.saveSession(
        token: attr.tokens.access.token,
        userId: attr.user.id,
        role: attr.user.role,
        businessName: attr.user.businessName,
        image: attr.user.image,
        fullName : attr.user.fullName,
        address: combinedAddress,
        lat: latitude,
        lon: longitude,
      );

      return loginResponse;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
  /// Logout user
  Future<void> logout() async {
    try {
      // Clear all cached data (token and userId) in one go
      await CacheService.clear();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  /// Check login status
  Future<bool> isLoggedIn() async {
    // Uses the clean getter we defined in CacheService
    return CacheService.isLoggedIn;
  }
}