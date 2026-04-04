
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'help_response_model.dart';

class HelpService {
  final ApiClient _apiClient;
  HelpService(this._apiClient);

  Future<HelpResponseModel> fetchHelpContent() async {
    final uri = ApiConstants.helpContent;
    try {
      // Using your ApiClient's get method
      final response = await _apiClient.get(uri);

      if (response.statusCode == 200) {
        return HelpResponseModel.fromJson(response.data);
      } else {
        throw Exception("Server returned ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ TermsOfServiceService Error: $e");
      rethrow;
    }
  }
}