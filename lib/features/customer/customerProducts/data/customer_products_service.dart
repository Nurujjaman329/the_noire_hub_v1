

import 'package:flutter/foundation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import 'customer_products_response_model.dart';

class CustomerProductsService {
  final ApiClient _apiClient;

  CustomerProductsService(this._apiClient);

  /// Fetches products with optional pagination parameters
  Future<CustomerProductsResponseModel> getCustomerProducts({int page = 1, int limit = 10}) async {
    debugPrint('🛒 [Store Request]: Fetching page $page with limit $limit');

    try {
      final response = await _apiClient.get(
        ApiConstants.customerProducts,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      // Mapping JSON to our safe model (with all those ?? '' and ?? 0)
      return CustomerProductsResponseModel.fromJson(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('🆘 [Store Exception]: $e');
      throw UnknownException(e.toString());
    }
  }
}