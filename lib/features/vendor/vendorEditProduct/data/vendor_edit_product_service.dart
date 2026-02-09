import 'package:get/get.dart';
import 'package:the_noire_hub_v1/features/vendor/vendorEditProduct/data/vendor_edit_product_form_body.dart';

import '../../../../core/api/api_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';

class VendorEditProductService {
  final ApiClient _apiClient;
  VendorEditProductService(this._apiClient);

  Future<bool> patchProduct(String productId, VendorUpdateProductFormBody productData) async {
    try {
      final String url = "${ApiConstants.vendorEditProduct}$productId";
      debugPrint('🚀 [PATCH] Updating Product: $url');

      final formData = await productData.toFormData();

      // FormData Debugging: Verifying the mapped keys
      debugPrint('📦 FormData Fields:');
      for (var field in formData.fields) {
        debugPrint('   - ${field.key}: ${field.value}');
      }
      for (var file in formData.files) {
        debugPrint('   - 📁 Image: ${file.key} | Name: ${file.value.filename}');
      }

      final response = await _apiClient.patchFormData(
        url,
        data: formData,
      );

      debugPrint('📥 Response Status: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 204;

    } on AppException catch (e) {
      debugPrint("❌ API Error (AppException): ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("❌ Unexpected Error in Service: $e");
      throw Exception("Unexpected error occurred: $e");
    }
  }
}