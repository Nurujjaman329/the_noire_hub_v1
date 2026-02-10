import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import 'order_full_fillment_post_body.dart';
import 'order_full_fillment_response_model.dart';
import 'dart:convert';


class OrderFullFillmentService {
  final ApiClient _apiClient;
  OrderFullFillmentService(this._apiClient);

  /// Fetch existing fulfillment settings
  Future<OrderFullFillmentResponseModel> getFulfillmentSettings() async {
    try {
      debugPrint('🚀 [GET] Fetching Fulfillment: ${ApiConstants.orderFullFillMent}');

      final response = await _apiClient.get(ApiConstants.orderFullFillMent);

      // --- DEBUG RESPONSE ---
      // Using jsonEncode with indent makes the console output easy to read
      final prettyJson = const JsonEncoder.withIndent('  ').convert(response.data);
      debugPrint('📥 Response Data:\n$prettyJson');
      // ----------------------

      return OrderFullFillmentResponseModel.fromJson(response.data);
    } on AppException catch (e) {
      debugPrint("❌ Get Fulfillment Error: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("❌ Unexpected Parsing Error: $e");
      rethrow;
    }
  }

  /// Update or Create fulfillment settings

  Future<bool> saveFulfillmentSettings(OrderFullFillmentPostBody body) async {
    try {
      debugPrint('🚀 [POST] Saving Fulfillment: ${ApiConstants.orderFullFillMent}');

      // --- DEBUG BODY ---
      final jsonMap = body.toJson();
      final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonMap);
      debugPrint('📦 Payload Body:\n$prettyJson');
      // ------------------

      final response = await _apiClient.postJson(
        ApiConstants.orderFullFillMent,
        data: jsonMap,
      );

      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Data: ${response.data}');

      return response.statusCode == 200;
    } on AppException catch (e) {
      debugPrint("❌ Save Fulfillment Error: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("❌ Unexpected Error: $e");
      rethrow;
    }
  }
}