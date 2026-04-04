
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'about_us_response_model.dart';

class AboutUsService {
  final ApiClient _apiClient;
  AboutUsService(this._apiClient);

  Future<AboutUsResponseModel> fetchAboutUs() async {
    final uri = ApiConstants.aboutUs;
    try {
      // Using your ApiClient's get method
      final response = await _apiClient.get(uri);

      if (response.statusCode == 200) {
        return AboutUsResponseModel.fromJson(response.data);
      } else {
        throw Exception("Server returned ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ TermsOfServiceService Error: $e");
      rethrow;
    }
  }
}