import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/api/api_exception.dart';
import '../../data/average_review_response_model.dart';
import '../../data/average_review_service.dart';

class AverageReviewController extends GetxController {
  final AverageReviewService _service;
  AverageReviewController(this._service);

  var isLoading = false.obs;
  // Reactive variable to hold the review attributes
  var reviewData = Rxn<EvaluationAttributes>();

  @override
  void onInit() {
    super.onInit();
    fetchEvaluations();
  }

  /// Initial fetch and manual refresh
  Future<void> fetchEvaluations() async {
    isLoading.value = true;
    try {
      final response = await _service.getVendorEvaluations();
      reviewData.value = response.data.attributes;
    } on AppException catch (e) {
      debugPrint("❌ Error in EvaluationController: ${e.message}");
      // AppSnackbar.error(e.message);
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper to get the bar width percentage for the UI
  double calculateRatingRatio(String star) {
    if (reviewData.value == null || reviewData.value!.totalReviews == 0) {
      return 0.0;
    }
    int count = reviewData.value!.ratingCount[star] ?? 0;
    return count / reviewData.value!.totalReviews;
  }
}