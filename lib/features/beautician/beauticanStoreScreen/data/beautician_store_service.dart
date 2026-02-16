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
      debugPrint('🚀 [GET] Fetching Beautician Services...');

      final response = await _apiClient.get(
        ApiConstants.beauticianServiceList,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return BeauticianStoreResponseModel.fromJson(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      debugPrint('🗑️ [DELETE] Removing Service: $serviceId');
      await _apiClient.delete("${ApiConstants.beauticianServiceList}/$serviceId");
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}