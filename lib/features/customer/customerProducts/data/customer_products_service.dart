

import 'package:flutter/foundation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import 'customer_products_response_model.dart';

class CustomerProductsService {
  final ApiClient _apiClient;

  CustomerProductsService(this._apiClient);

  Future<CustomerProductsResponseModel> getCustomerProducts({
    int page = 1,
    int limit = 10,
    double? latitude,
    double? longitude,
    int? maxDistance,
    String? name,
    String? category,    // 👈 Added
    String? subcategory, // 👈 Added
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'limit': limit,
      };

      if (latitude != null) queryParams['latitude'] = latitude;
      if (longitude != null) queryParams['longitude'] = longitude;
      if (maxDistance != null) queryParams['maxDistance'] = maxDistance;

      // Only add to params if string is not empty
      if (name != null && name.isNotEmpty) queryParams['name'] = name;
      if (category != null && category.isNotEmpty) queryParams['category'] = category;
      if (subcategory != null && subcategory.isNotEmpty) queryParams['subcategory'] = subcategory;

      debugPrint('📦 Request Params: $queryParams');

      final response = await _apiClient.get(
        ApiConstants.customerProducts,
        queryParameters: queryParams,
      );

      return CustomerProductsResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}