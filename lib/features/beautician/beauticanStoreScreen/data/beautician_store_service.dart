import 'package:flutter/material.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import 'beautician_store_response_model.dart';


class BeauticianStoreService {
  final ApiClient _apiClient;
  BeauticianStoreService(this._apiClient);

  Future<BeauticianStoreResponseModel> getBeauticianServices({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // ✅ Construct and Debug the full URL
      final String fullUrl = "${ApiConstants.baseUrl}${ApiConstants.beauticianServiceList}?page=$page&limit=$limit";
      debugPrint('🚀 [GET] Full Request URL: $fullUrl');

      final response = await _apiClient.get(
        ApiConstants.beauticianServiceList,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      debugPrint('📥 Response Status: ${response.statusCode}');
      return BeauticianStoreResponseModel.fromJson(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error in getBeauticianServices: $e');
      throw UnknownException(e.toString());
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      final String deleteUrl = "${ApiConstants.baseUrl}${ApiConstants.beauticianServiceList}/$serviceId";
      debugPrint('🗑️ [DELETE] Full URL: $deleteUrl');

      await _apiClient.delete("${ApiConstants.serviceRoute}/$serviceId");
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}