import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
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
}