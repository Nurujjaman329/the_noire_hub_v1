import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import 'edit_profile_response_model.dart';

class EditProfileService {
  final ApiClient _apiClient;
  EditProfileService(this._apiClient);

  Future<EditProfileResponseModel> updateProfile({
    required Map<String, dynamic> body,
    String? imagePath,
  }) async {
    try {
      debugPrint("🟡 updateProfile called");
      debugPrint("📦 Body data: $body");
      debugPrint("🖼 Image path: $imagePath");

      // Create FormData
      final formData = FormData.fromMap(body);

      // Add image if path is provided
      if (imagePath != null && imagePath.isNotEmpty) {
        debugPrint("✅ Adding image to FormData");

        formData.files.add(
          MapEntry(
            'image', // must match backend field name
            await MultipartFile.fromFile(
              imagePath,
              filename: imagePath.split('/').last,
            ),
          ),
        );
      } else {
        debugPrint("⚠️ No image provided");
      }

      // Debug FormData content
      debugPrint("📤 FormData fields:");
      for (var field in formData.fields) {
        debugPrint("  ${field.key}: ${field.value}");
      }

      debugPrint("📤 FormData files:");
      for (var file in formData.files) {
        debugPrint("  ${file.key}: ${file.value.filename}");
      }

      // API call
      debugPrint("🚀 Sending PATCH request to ${ApiConstants.updateProfile}");

      final response = await _apiClient.patchFormData(
        ApiConstants.updateProfile,
        data: formData,
      );

      debugPrint("✅ Response status: ${response.statusCode}");
      debugPrint("📥 Response data: ${response.data}");

      return EditProfileResponseModel.fromJson(response.data);
    } on AppException catch (e) {
      debugPrint("❌ AppException: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("🔥 Unknown error: $e");
      throw UnknownException(e.toString());
    }
  }
}
