
import 'package:flutter/material.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/constants/api_constants.dart';
import 'business_info_response_model.dart';
import 'business_info_update_form_body.dart';
import 'categoryUpdate/category_update_post_body.dart';

class BusinessInfoService {
  final ApiClient _apiClient;
  BusinessInfoService(this._apiClient);

  Future<BusinessInfoResponseModel> getBusinessInfo() async {
    try {
      debugPrint("🚀 [GET] Fetching Business Info from: ${ApiConstants.getBusinessInfo}");

      final response = await _apiClient.get(ApiConstants.getBusinessInfo);

      // Print raw response to verify the JSON structure matches your model
      debugPrint("📥 [RESPONSE] Raw Data: ${response.data}");

      final model = BusinessInfoResponseModel.fromJson(response.data);

      debugPrint("✅ [SUCCESS] Model parsed for: ${model.data.businessName}");
      return model;
    } on AppException catch (e) {
      debugPrint("❌ [AppException]: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("💥 [Unknown Error during Fetch/Parsing]: $e");
      throw UnknownException(e.toString());
    }
  }

  /// New Method: Update Business Profile (Name, Bio, Image, etc.)
  Future<void> updateBusinessInfo(BusinessInfoUpdateFormBody body) async {
    try {
      debugPrint("🚀 [START] Partial Update...");

      final formData = await body.toFormData();

      // --- Verification Debugging ---
      debugPrint("📍 PATCH URL: ${ApiConstants.getBusinessInfo}");
      debugPrint("📝 Payload details (sending only non-null fields):");
      for (var field in formData.fields) {
        debugPrint("   ✅ ${field.key}: ${field.value}");
      }
      for (var file in formData.files) {
        debugPrint("   📁 ${file.key}: ${file.value.filename}");
      }
      // -----------------------------

      final response = await _apiClient.patch(
        ApiConstants.getBusinessInfo,
        data: formData,
      );

      debugPrint("✅ [SUCCESS] Business Info Updated: ${response.data}");
    } on AppException catch (e) {
      debugPrint("❌ [AppException]: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("💥 [Unknown Error]: $e");
      throw UnknownException(e.toString());
    }
  }


  Future<void> updateCategories(CategoryUpdatePostBody body) async {
    try {
      final Map<String, dynamic> jsonPayload = body.toJson();
      debugPrint("🚀 Sending Category Update Request...");

      final response = await _apiClient.patch(
        ApiConstants.categoryUpdate,
        data: jsonPayload,
      );
      debugPrint("✅ Categories Updated: ${response.data}");
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}