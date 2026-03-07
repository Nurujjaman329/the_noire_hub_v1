import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import 'order_full_fillment_post_body.dart';
import 'order_full_fillment_response_model.dart';


class OrderFullFillmentService {
  final ApiClient _apiClient;
  OrderFullFillmentService(this._apiClient);

  Future<OrderFullFillmentResponseModel> getFulfillmentSettings({String? vendorId}) async {
    try {
      String url = ApiConstants.orderFullFillMent;

      // Ensure vendorId is a valid non-empty, non-null string
      if (vendorId != null && vendorId.isNotEmpty && vendorId != "null") {
        url = '$url?vendorId=$vendorId';
      }

      debugPrint('🚀 [GET] Fetching Fulfillment: $url');
      final response = await _apiClient.get(url);

      return OrderFullFillmentResponseModel.fromJson(response.data);
    } on AppException catch (e) {
      debugPrint("❌ Get Fulfillment Error: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("❌ Unexpected Parsing Error: $e");
      rethrow;
    }
  }

  Future<bool> saveFulfillmentSettings(OrderFullFillmentPostBody body) async {
    try {
      final jsonMap = body.toJson();
      final response = await _apiClient.postJson(
        ApiConstants.orderFullFillMent,
        data: jsonMap,
      );
      return response.statusCode == 200;
    } on AppException catch (e) {
      debugPrint("❌ Save Fulfillment Error: ${e.message}");
      rethrow;
    }
  }
}