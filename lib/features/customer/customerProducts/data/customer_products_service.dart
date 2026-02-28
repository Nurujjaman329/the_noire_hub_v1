

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
  }) async {
    try {
      // 1. Prepare Parameters
      final Map<String, dynamic> queryParams = {
        'page': page,
        'limit': limit,
      };

      if (latitude != null) queryParams['latitude'] = latitude;
      if (longitude != null) queryParams['longitude'] = longitude;
      if (maxDistance != null) queryParams['maxDistance'] = maxDistance;
      if (name != null && name.isNotEmpty) queryParams['name'] = name;

      // 2. Debug Log before request
      debugPrint('--- 🛒 [CustomerProducts Request] ---');
      debugPrint('📍 Endpoint: ${ApiConstants.customerProducts}');
      debugPrint('📦 Params: $queryParams');
      if (name != null) debugPrint('🔍 Searching for: "$name"');
      debugPrint('--------------------------------------');

      final response = await _apiClient.get(
        ApiConstants.customerProducts,
        queryParameters: queryParams,
      );

      // 3. Optional: Debug successful response count
      final model = CustomerProductsResponseModel.fromJson(response.data);
      debugPrint('✅ [Store Success]: Found ${model.data?.attributes?.results.length ?? 0} products');

      return model;
    } on AppException catch (e) {
      debugPrint('❌ [Store AppException]: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('🆘 [Store Unknown Exception]: $e');
      throw UnknownException(e.toString());
    }
  }
}