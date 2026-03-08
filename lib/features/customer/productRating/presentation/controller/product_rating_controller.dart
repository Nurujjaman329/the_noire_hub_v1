
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/api/api_exception.dart';
import '../../data/product_rating_service.dart';

class ProductRatingController extends GetxController {
  final ProductRatingService _ratingService;
  ProductRatingController(this._ratingService);

  var isLoading = false.obs;
  var selectedRating = 5.obs;
  final TextEditingController commentController = TextEditingController();

  /// ✅ Submit the product review
  Future<void> submitProductReview({
    required String productId,
    required String orderId,
    int? rating,
    String? comment,
  }) async {
    if (productId.isEmpty || orderId.isEmpty) {
      Get.snackbar("Error", "Missing product or order reference.");
      return;
    }

    isLoading.value = true;

    try {
      final bool success = await _ratingService.submitRating(
        productId: productId,
        orderId: orderId,
        rating: rating ?? selectedRating.value,
        comment: comment ?? commentController.text.trim(),
      );

      if (success) {
        _resetForm();
        if (Get.isOverlaysOpen) Get.back();

        Get.snackbar(
          "Success",
          "Product review submitted!",
          backgroundColor: const Color(0xFF1D3826),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on AppException catch (e) {
      Get.snackbar("Failed", e.message, backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Unexpected error occurred.", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void _resetForm() {
    selectedRating.value = 5;
    commentController.clear();
  }
}