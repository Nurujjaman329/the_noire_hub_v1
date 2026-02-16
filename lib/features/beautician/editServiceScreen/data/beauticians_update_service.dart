
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import 'Beautician_service_update_post_body.dart';

class BeauticiansUpdateService {
  final ApiClient _apiClient; // Assuming you have an ApiClient for Dio

  BeauticiansUpdateService(this._apiClient);

  /// ✅ PATCH: Update Service
  Future<bool> updateService(String serviceId, BeauticianServiceUpdatePostBody updateBody) async {
    try {
      debugPrint('🚀 [PATCH] Updating Service: $serviceId');

      // Convert our model to FormData
      final formData = await updateBody.toFormData();

      // Debugging FormData
      debugPrint('📦 FormData contains:');
      for (var field in formData.fields) {
        debugPrint('   - ${field.key}: ${field.value}');
      }
      for (var file in formData.files) {
        debugPrint('   - 📁 File Key: ${file.key} | Name: ${file.value.filename}');
      }

      final response = await _apiClient.patch(
        '${ApiConstants.serviceRoute}/$serviceId',
        data: formData,
      );

      debugPrint('📥 Response: ${response.statusCode} - ${response.data}');

      return response.statusCode == 200 || response.statusCode == 201;
    } on AppException catch (e) {
      debugPrint("❌ Update Service Error: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("❌ Unexpected Error: $e");
      throw Exception("Failed to update service: $e");
    }
  }
}