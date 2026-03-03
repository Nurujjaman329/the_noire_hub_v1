
import 'package:flutter/material.dart';
import 'package:the_noire_hub_v1/core/constants/api_constants.dart';
import '../../../../core/api/api_client.dart';
import 'multi_vendor_cart_response_model.dart';

class MultiVendorCartService {
  final ApiClient _apiClient;
  MultiVendorCartService(this._apiClient);

  Future<MultiVendorCartResponseModel> fetchCart() async {
    final uri = ApiConstants.cart;

    try {
      final response = await _apiClient.get(uri);

      if (response.statusCode == 200) {
        return MultiVendorCartResponseModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load cart: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ CartService Error: $e");
      rethrow;
    }
  }
}