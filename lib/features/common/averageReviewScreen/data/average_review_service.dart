
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/cache_service.dart';
import 'average_review_response_model.dart';

class AverageReviewService {
  final ApiClient _apiClient;
  AverageReviewService(this._apiClient);

  Future<AverageReviewResponseModel> getVendorEvaluations() async {
    try {
      final String rolePath = CacheService.evaluationRoleSegment;
      final String userId = CacheService.userId;
      final String url = "${ApiConstants.evaluationsBase}$rolePath/$userId";

      debugPrint('🚀 [GET] Fetching Evaluations: $url');

      final response = await _apiClient.get(url);

      // response.data is already a Map because of ApiClient configuration
      return AverageReviewResponseModel.fromJson(response.data);
    } on AppException catch (e) {
      debugPrint("❌ Evaluation Service Error: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("❌ Unexpected Error in EvaluationService: $e");
      rethrow;
    }
  }
}