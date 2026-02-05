

import 'package:the_noire_hub_v1/features/vendor/vendorProductDetailsScreen/data/vendor_product_details_response_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';

class VendorProductDetailsService {
  final ApiClient _apiClient;
  VendorProductDetailsService(this._apiClient);

  Future<VendorProductDetailsResponseModel> getProductDetails(String productId) async {
    // 1. Check the ID being passed
    debugPrint('[ProductDetailService] Fetching ID: $productId');

    try {
      // 2. Check the final URL (Adding a '/' if it's missing)
      final url = "${ApiConstants.vendorSingleProduct}$productId";
      debugPrint('[ProductDetailService] Request URL: ${ApiConstants.baseUrl}$url');

      final response = await _apiClient.get(url);

      // 3. Print the raw response body from the server
      debugPrint('[ProductDetailService] Raw Response: ${response.data}');

      return VendorProductDetailsResponseModel.fromJson(response.data);
    } on AppException catch (e) {
      debugPrint('[ProductDetailService] AppException: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('[ProductDetailService] Unknown Error: $e');
      throw UnknownException(e.toString());
    }
  }
}