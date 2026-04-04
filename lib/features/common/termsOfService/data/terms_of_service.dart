import 'package:the_noire_hub_v1/features/common/termsOfService/data/terms_of_service_response_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';

class TermsOfService {
  final ApiClient _apiClient;
  TermsOfService(this._apiClient);

  Future<TermsOfServiceResponseModel> fetchTerms() async {
    final uri = ApiConstants.termsOfService;
    try {
      // Using your ApiClient's get method
      final response = await _apiClient.get(uri);

      if (response.statusCode == 200) {
        return TermsOfServiceResponseModel.fromJson(response.data);
      } else {
        throw Exception("Server returned ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ TermsOfServiceService Error: $e");
      rethrow;
    }
  }
}