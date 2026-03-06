


import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/constants/api_constants.dart';
import '../model/add_deals_promos_post_body.dart';
import '../model/deals_promos_response_model.dart';

class DealsPromosService {
  final ApiClient _apiClient;
  DealsPromosService(this._apiClient);



  // GET: Fetch all promos
  Future<DealsPromosResponseModel> fetchPromos() async {
    if (kDebugMode) {
      debugPrint('🔍 PROMO_SERVICE: Fetching all promos...');
    }

    final response = await _apiClient.get(ApiConstants.promoCode);

    // Convert dynamic response data to our Response Model
    return DealsPromosResponseModel.fromJson(response.data);
  }

  // POST: Create Promo
  Future<Response> createPromo(AddDealsPromosPostBody body) async {
    if (kDebugMode) {
      debugPrint('🚀 PROMO_SERVICE: Sending Create Request...');
      debugPrint('📦 Payload: ${body.toJson()}');
    }

    final response = await _apiClient.postJson(ApiConstants.promoCode,data: body.toJson());

    if (kDebugMode) {
      debugPrint('✅ PROMO_SERVICE: Create Response Status: ${response.statusCode}');
    }
    return response;
  }

  // PATCH: Update Promo
  Future<Response> updatePromo(String id, EditDealsPromosPostBody body) async {
    if (kDebugMode) {
      debugPrint('🔧 PROMO_SERVICE: Updating Promo ID: $id');
      debugPrint('📦 Update Payload: ${body.toJson()}');
    }

    final response = await _apiClient.patch("${ApiConstants.promoCode}/$id", data: body.toJson());

    if (kDebugMode) {
      debugPrint('✅ PROMO_SERVICE: Update Response Status: ${response.statusCode}');
    }
    return response;
  }

  // DELETE: Remove Promo
  Future<Response> deletePromo(String id) async {
    if (kDebugMode) {
      debugPrint('🗑️ PROMO_SERVICE: Deleting Promo ID: $id');
    }

    final response = await _apiClient.delete("${ApiConstants.promoCode}/$id");

    if (kDebugMode) {
      debugPrint('✅ PROMO_SERVICE: Delete Response Status: ${response.statusCode}');
    }
    return response;
  }
}