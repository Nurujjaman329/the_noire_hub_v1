

import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';

class CheckOutService {
  final ApiClient _apiClient;
  CheckOutService(this._apiClient);

  /// Creates a new product order
  /// POST /product-orders
  Future<Map<String, dynamic>?> createOrder(Map<String, dynamic> orderData) async {
    debugPrint("===> CREATE ORDER REQUEST: ${ApiConstants.productOrders}");
    debugPrint("===> PAYLOAD: $orderData");

    try {
      final response = await _apiClient.postJson(
        ApiConstants.productOrders,
        data: orderData,
      );

      debugPrint("<=== ORDER RESPONSE CODE: ${response.statusCode}");

      if (response.data != null && response.data['code'] == 201) {
        // Returning the attributes which contain checkoutUrl and order details
        return response.data['data']['attributes'];
      }
      return null;
    } catch (e) {
      debugPrint("!!! CREATE ORDER SERVICE ERROR: $e");
      rethrow;
    }
  }
}