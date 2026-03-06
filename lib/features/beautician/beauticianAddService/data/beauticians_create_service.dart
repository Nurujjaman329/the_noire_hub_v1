

import '../../../../core/api/api_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import 'beauticians_create_service_post_body.dart';


class BeauticiansCreateService {
  final ApiClient _apiClient;
  BeauticiansCreateService(this._apiClient);

  Future<bool> createService(BeauticiansCreateServicePostBody serviceData) async {
    try {
      debugPrint('🚀 [POST] Creating Service: ${ApiConstants.serviceRoute}');

      final formData = await serviceData.toFormData();

      // FormData Debugging
      debugPrint('📦 FormData Fields:');
      for (var field in formData.fields) {
        debugPrint('   - ${field.key}: ${field.value}');
      }
      for (var file in formData.files) {
        debugPrint('   - 📁 File: ${file.key} | Name: ${file.value.filename}');
      }

      final response = await _apiClient.postFormData(
        ApiConstants.serviceRoute,
        data: formData,
      );

      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Data: ${response.data}');

      return response.statusCode == 201 || response.statusCode == 200;
    } on AppException catch (e) {
      debugPrint("❌ API Error (AppException): ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("❌ Unexpected Error in Service: $e");
      throw Exception("Unexpected error occurred: $e");
    }
  }
}