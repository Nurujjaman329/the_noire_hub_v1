import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import 'order_full_fillment_post_body.dart';
import 'order_full_fillment_response_model.dart';


import 'dart:convert'; // Required for JsonEncoder

class OrderFullFillmentService {
  final ApiClient _apiClient;
  OrderFullFillmentService(this._apiClient);

  /// Fetch existing fulfillment settings
  Future<OrderFullFillmentResponseModel> getFulfillmentSettings({String? vendorId}) async {
    try {
      String url = ApiConstants.orderFullFillMent;
      if (vendorId != null && vendorId.isNotEmpty && vendorId != "null") {
        url = '$url?vendorId=$vendorId';
      }

      debugPrint('🚀 [GET] Fetching Fulfillment: $url');

      final response = await _apiClient.get(url);

      // --- DEBUG: Pretty Print Response ---
      try {
        final prettyJson = const JsonEncoder.withIndent('  ').convert(response.data);
        debugPrint('📥 Response Data (Vendor: $vendorId):\n$prettyJson');
      } catch (_) {
        debugPrint('📥 Response Data: ${response.data}');
      }
      // ------------------------------------

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
      final jsonMap = body.toJson();

      // --- DEBUG: Pretty Print Payload ---
      final prettyPayload = const JsonEncoder.withIndent('  ').convert(jsonMap);
      debugPrint('📦 [POST] Saving Fulfillment Payload:\n$prettyPayload');
      // -----------------------------------

      final response = await _apiClient.postJson(
        ApiConstants.orderFullFillMent,
        data: jsonMap,
      );

      debugPrint('✅ Save Status: ${response.statusCode} | Data: ${response.data}');
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