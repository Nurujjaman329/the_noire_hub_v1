
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'customer_orders_response_model.dart';

class CustomerOrdersService {
  final ApiClient _apiClient;
  CustomerOrdersService(this._apiClient);

  /// Fetches orders with pagination and status filtering
  /// GET /product-orders?page=1&limit=10&status=pending
  Future<CustomerOrdersResponseModel> getCustomerOrders({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    Map<String, dynamic> queryParameters = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (status != null && status.isNotEmpty) {
      queryParameters['status'] = status;
    }

    // --- DEBUG: LOG REQUEST ---
    debugPrint("===> GET ORDERS REQUEST: ${ApiConstants.productOrders}");
    debugPrint("===> PARAMS: $queryParameters");

    try {
      final response = await _apiClient.get(
        ApiConstants.productOrders,
        queryParameters: queryParameters,
      );

      // --- DEBUG: LOG RESPONSE STATUS & DATA ---
      debugPrint("<=== ORDERS RESPONSE CODE: ${response.statusCode}");
      // Printing the first 200 characters of data to avoid flooding console while confirming structure
      debugPrint("<=== DATA PREVIEW: ${response.data.toString().substring(0, response.data.toString().length > 200 ? 200 : response.data.toString().length)}...");

      // Ensure we pass the Map to the model
      return CustomerOrdersResponseModel.fromJson(response.data);

    } catch (e) {
      // --- DEBUG: LOG ERRORS ---
      debugPrint("!!! ORDERS SERVICE ERROR: $e");
      rethrow;
    }
  }

  Future<bool> cancelOrder({required String orderId, required String reason}) async {
    final String url = "${ApiConstants.productOrders}/$orderId/cancel";

    debugPrint("===> CANCEL ORDER REQUEST: $url");
    debugPrint("===> BODY: {'cancellationReason': '$reason'}");

    try {
      // Changed 'body' to 'data' to match your postJson signature
      final response = await _apiClient.postJson(
        url,
        data: {
          "cancellationReason": reason,
        },
      );

      debugPrint("<=== CANCEL RESPONSE CODE: ${response.statusCode}");

      // Check if the API returned a success code in the JSON body
      if (response.data != null && response.data['code'] == 200) {
        debugPrint("<=== CANCEL SUCCESSFUL");
        return true;
      }

      debugPrint("<=== CANCEL FAILED: ${response.data['message']}");
      return false;
    } catch (e) {
      debugPrint("!!! CANCEL ORDER SERVICE ERROR: $e");
      return false;
    }
  }

}