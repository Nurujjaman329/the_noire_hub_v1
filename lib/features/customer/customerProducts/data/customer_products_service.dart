import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../../productDetailsScreen/data/product_details_response_model.dart';
import 'customer_products_response_model.dart';
import 'package:flutter/material.dart';

class CustomerProductsService {
  final ApiClient _apiClient;

  CustomerProductsService(this._apiClient);

  Future<CustomerProductsResponseModel> getCustomerProducts({
    int page = 1,
    int limit = 10,
    double? latitude,
    double? longitude,
    String? name,
    String? category,
    String? subcategory,
    int? maxDistance,
    double? minRating,
    double? minPrice,
    double? maxPrice,
    bool? hasOffer,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
    };

    if (latitude != null) queryParams['latitude'] = latitude;
    if (longitude != null) queryParams['longitude'] = longitude;
    if (name != null && name.isNotEmpty) queryParams['name'] = name;
    if (category != null && category.isNotEmpty) queryParams['category'] = category;
    if (subcategory != null && subcategory.isNotEmpty) queryParams['subcategory'] = subcategory;
    if (maxDistance != null) queryParams['maxDistance'] = maxDistance;
    if (minRating != null) queryParams['minRating'] = minRating;
    if (minPrice != null) queryParams['minPrice'] = minPrice;
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
    if (hasOffer != null) queryParams['hasOffer'] = hasOffer;

    // --- DEBUG PRINT: REQUEST ---
    debugPrint('🚀 [GET] Request to: ${ApiConstants.customerProducts}');
    debugPrint('Params: $queryParams');

    try {
      final response = await _apiClient.get(
        ApiConstants.customerProducts,
        queryParameters: queryParams,
      );

      // --- DEBUG PRINT: SUCCESS ---
      debugPrint('✅ [GET] Success: ${ApiConstants.customerProducts}');
      debugPrint('Response Data: ${response.data}');

      return CustomerProductsResponseModel.fromJson(response.data);
    } catch (e) {
      // --- DEBUG PRINT: ERROR ---
      debugPrint('❌ [GET] Error at: ${ApiConstants.customerProducts}');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }

  Future<ProductDetailsResponseModel> getProductDetails(String productId) async {
    final String url = "${ApiConstants.customerProducts}/$productId";

    debugPrint('🚀 [GET] Request to: $url');

    try {
      final response = await _apiClient.get(url);

      debugPrint('✅ [GET] Success: $url');
      return ProductDetailsResponseModel.fromJson(response.data);
    } catch (e) {
      debugPrint('❌ [GET] Error at: $url');
      rethrow;
    }
  }

  // Add to Cart
  Future<void> addToCart(Map<String, dynamic> data) async {
    const String url = ApiConstants.cartItems;

    // --- DEBUG PRINT: REQUEST ---
    debugPrint('🚀 [POST] Request to: $url');
    debugPrint('Payload: $data');

    try {
      final response = await _apiClient.postJson(
        url,
        data: data,
      );

      // --- DEBUG PRINT: SUCCESS ---
      debugPrint('✅ [POST] Success: $url');
      debugPrint('Response Data: ${response.data}');

      return response.data;
    } catch (e) {
      // --- DEBUG PRINT: ERROR ---
      debugPrint('❌ [POST] Error at: $url');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }


  /// ✅ POST: Toggle Favorite (Add/Remove)
  Future<bool> toggleFavorite(String id, String itemType) async {
    final String url = "${ApiConstants.customerFavorites}/$id";
    final Map<String, dynamic> body = {"itemType": itemType};

    debugPrint('🚀 [POST] Request to: $url');
    debugPrint('Payload: $body');

    try {
      final response = await _apiClient.postJson(
        url,
        data: body,
      );

      debugPrint('✅ [POST] Success: $url');
      // Returns true if added/removed successfully
      return response.statusCode == 200 || response.statusCode == 201;
    } on AppException catch (e) {
      debugPrint("🛑 [AppException] ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint('❌ [POST] Error at: $url');
      throw Exception("Failed to update favorite: $e");
    }
  }

}