
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'favorites_response_model.dart';

class CustomerFavoritesService {
  final ApiClient _apiClient;
  CustomerFavoritesService(this._apiClient);

  /// Get Paginated Favorites
  Future<FavoritesResponseModel> getFavorites({int page = 1, int limit = 10}) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
    };

    // --- DEBUG PRINT: REQUEST ---
    debugPrint('🚀 [GET] Request to: ${ApiConstants.customerFavorites}');
    debugPrint('Params: $queryParams');

    try {
      final response = await _apiClient.get(
        ApiConstants.customerFavorites,
        queryParameters: queryParams,
      );

      // --- DEBUG PRINT: SUCCESS ---
      debugPrint('✅ [GET FAVORITES] Success');
      debugPrint('Response Data: ${response.data}');

      return FavoritesResponseModel.fromJson(response.data);
    } catch (e) {
      // --- DEBUG PRINT: ERROR ---
      debugPrint("❌ [GET FAVORITES] Error: $e");
      rethrow;
    }
  }

  /// Toggle Favorite (Add/Remove)
  Future<bool> toggleFavorite({required String itemId, required String itemType}) async {
    final Map<String, dynamic> body = {
      "item": itemId,
      "itemType": itemType,
    };

    // --- DEBUG PRINT: REQUEST ---
    debugPrint('🚀 [POST] Request to: ${ApiConstants.customerFavorites}');
    debugPrint('Body: $body');

    try {
      final response = await _apiClient.postJson(
        ApiConstants.customerFavorites,
        data: body,
      );

      // --- DEBUG PRINT: SUCCESS ---
      debugPrint('✅ [TOGGLE FAVORITE] Status: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // --- DEBUG PRINT: ERROR ---
      debugPrint("❌ [TOGGLE FAVORITE] Error: $e");
      return false;
    }
  }

  /// Delete Favorite by ID
  Future<bool> deleteFavorite(String favoriteId) async {
    final String url = "${ApiConstants.customerFavorites}/$favoriteId";

    // --- DEBUG PRINT: REQUEST ---
    debugPrint('🚀 [DELETE] Request to: $url');

    try {
      final response = await _apiClient.delete(url);

      // --- DEBUG PRINT: SUCCESS ---
      debugPrint('✅ [DELETE FAVORITE] Status: ${response.statusCode}');

      return response.statusCode == 200;
    } catch (e) {
      // --- DEBUG PRINT: ERROR ---
      debugPrint("❌ [DELETE FAVORITE] Error: $e");
      return false;
    }
  }
}