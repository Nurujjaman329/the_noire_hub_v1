
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/api/api_exception.dart';
import '../../data/service_rating_service.dart';

class ServiceRatingController extends GetxController {
  final ServiceRatingService _ratingService;
  ServiceRatingController(this._ratingService);

  // Loading state for the submit button
  var isLoading = false.obs;

  // UI States (Optional: helps manage the rating dialog internally)
  var selectedRating = 5.obs;
  final TextEditingController commentController = TextEditingController();

  /// ✅ Submit the review to the backend
  Future<void> submitServiceReview({
    required String bookingId,
    int? rating,
    String? comment,
  }) async {
    if (bookingId.isEmpty) {
      Get.snackbar("Error", "Invalid booking reference.");
      return;
    }

    isLoading.value = true;

    try {
      // Use passed values or fall back to controller's internal state
      final bool success = await _ratingService.submitRating(
        bookingId: bookingId,
        rating: rating ?? selectedRating.value,
        comment: comment ?? commentController.text.trim(),
      );

      if (success) {
        // Clear internal state on success
        _resetForm();

        // Close dialog/bottomsheet if open
        if (Get.isOverlaysOpen) Get.back();

        Get.snackbar(
          "Success",
          "Thank you for your feedback!",
          backgroundColor: const Color(0xFF1D3826),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
        );
      }
    } on AppException catch (e) {
      // Catches ServerException, NoInternetException, etc., from your ApiClient
      Get.snackbar(
        "Rating Failed",
        e.message,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred while saving your review.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _resetForm() {
    selectedRating.value = 5;
    commentController.clear();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}