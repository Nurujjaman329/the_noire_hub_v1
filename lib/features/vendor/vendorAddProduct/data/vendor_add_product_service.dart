import 'package:the_noire_hub_v1/features/vendor/vendorAddProduct/data/vendor_add_product_post_body.dart';
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';

class VendorAddProductService {
  final ApiClient _apiClient;
  VendorAddProductService(this._apiClient);

  Future<bool> createProduct(VendorAddProductPostBody productData) async {
    try {
      debugPrint('🚀 [POST] Creating Product: ${ApiConstants.vendorCreateProduct}');

      final formData = await productData.toFormData();

      // FormData Debugging: Iterating through fields to see what's inside
      debugPrint('📦 FormData Fields:');
      for (var field in formData.fields) {
        debugPrint('   - ${field.key}: ${field.value}');
      }
      for (var file in formData.files) {
        debugPrint('   - 📁 File: ${file.key} | Name: ${file.value.filename}');
      }

      final response = await _apiClient.postFormData(
        ApiConstants.vendorCreateProduct,
        data: formData,
      );

      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Data: ${response.data}');

      return response.statusCode == 201;
    } on AppException catch (e) {
      debugPrint("❌ API Error (AppException): ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("❌ Unexpected Error in Service: $e");
      throw Exception("Unexpected error occurred: $e");
    }
  }
}