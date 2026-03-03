
import 'package:flutter/material.dart';
import 'package:the_noire_hub_v1/core/constants/api_constants.dart';
import '../../../../core/api/api_client.dart';
import 'feedback_response_model.dart';

class FeedbackService {
  final ApiClient _apiClient;
  FeedbackService(this._apiClient);

  // Send Feedback
  Future<bool> sendFeedback(String subject, String message) async {
    try {
      final response = await _apiClient.postJson(
        ApiConstants.feedback,
        data: {"subject": subject, "message": message},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("❌ [SEND FEEDBACK] Error: $e");
      return false;
    }
  }

  // Get User Feedback List
  Future<FeedbackResponseModel> getMyFeedbacks() async {
    final String url = "${ApiConstants.feedback}/my";

    try {
      final response = await _apiClient.get(url);
      return FeedbackResponseModel.fromJson(response.data);
    } catch (e) {
      debugPrint("❌ [GET FEEDBACKS] Error: $e");
      rethrow;
    }
  }
}