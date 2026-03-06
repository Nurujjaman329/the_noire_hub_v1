import 'package:the_noire_hub_v1/features/vendor/vendorStoreScreen/data/vendor_products_response_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';

class VendorProductList {
  final ApiClient _apiClient;
  VendorProductList(this._apiClient);

  Future<VendorProductsResponseModel> getVendorProducts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      debugPrint('🚀 [GET] Fetching Vendor Products...');
      debugPrint('   URL: ${ApiConstants.vendorProductList}');
      debugPrint('   Params: {page: $page, limit: $limit}');

      final response = await _apiClient.get(
        ApiConstants.vendorProductList,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      debugPrint('📥 Response Status: ${response.statusCode}');
      // Useful to see if the structure matches your Model
      debugPrint('📥 Response Body: ${response.data}');

      final model = VendorProductsResponseModel.fromJson(response.data);

      // Log specific details to confirm mapping success
      debugPrint('✅ Successfully parsed ${model.data.attributes.results.length} products');

      return model;
    } on AppException catch (e) {
      debugPrint('❌ API Error (AppException): ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected Error in getVendorProducts: $e');
      throw UnknownException(e.toString());
    }
  }


  Future<void> deleteProduct(String productId) async {
    try {
      await _apiClient.delete(
        "${ApiConstants.vendorDeleteSingleProduct}$productId",
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}