
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

    try {
      final response = await _apiClient.get(
        ApiConstants.customerFavorites,
        queryParameters: queryParams,
      );
      return FavoritesResponseModel.fromJson(response.data);
    } catch (e) {
      debugPrint("❌ [GET FAVORITES] Error: $e");
      rethrow;
    }
  }

  /// Toggle Favorite (Add/Remove)
  /// item: ID of the product or service
  /// itemType: 'Product' or 'Service'
  Future<bool> toggleFavorite({required String itemId, required String itemType}) async {
    try {
      final response = await _apiClient.postJson(
        ApiConstants.customerFavorites,
        data: {
          "item": itemId,
          "itemType": itemType,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("❌ [TOGGLE FAVORITE] Error: $e");
      return false;
    }
  }

  /// Delete Favorite by ID
  Future<bool> deleteFavorite(String favoriteId) async {
    try {
      final response = await _apiClient.delete(
        "${ApiConstants.customerFavorites}/$favoriteId",
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("❌ [DELETE FAVORITE] Error: $e");
      return false;
    }
  }
}