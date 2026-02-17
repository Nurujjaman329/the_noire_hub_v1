
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import 'beautician_service_update_post_body.dart';

class BeauticiansUpdateService {
  final ApiClient _apiClient;

  BeauticiansUpdateService(this._apiClient);

  /// ✅ PATCH: Update Service
  Future<bool> updateService(String serviceId, BeauticianServiceUpdatePostBody updateBody) async {
    try {
      debugPrint('🚀 [PATCH] Updating Service: $serviceId');

      final formData = await updateBody.toFormData();

      // Debugging local FormData before sending
      debugPrint('📦 FormData fields: ${formData.fields.map((e) => "${e.key}: ${e.value}").toList()}');

      final response = await _apiClient.patch(
        '${ApiConstants.serviceRoute}/$serviceId',
        data: formData,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      // 🎯 This is where the magic happens
      final responseData = e.response?.data;
      final statusCode = e.response?.statusCode;

      debugPrint("🛑 [BACKEND ERROR] Status: $statusCode");
      debugPrint("🛑 [FULL ERROR DATA]: $responseData");

      // If your backend sends a specific "message" or "error" field
      if (responseData is Map) {
        debugPrint("❌ Specific Backend Message: ${responseData['message'] ?? responseData['error']}");
      }

      rethrow;
    } on AppException catch (e) {
      debugPrint("❌ App Layer Error: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("❌ Unexpected Error: $e");
      throw Exception("Failed to update service: $e");
    }
  }
}