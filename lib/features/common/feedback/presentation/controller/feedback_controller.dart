import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../data/feedback_response_model.dart';
import '../../data/feedback_service.dart';


class FeedbackController extends GetxController {
  final FeedbackService _service;
  FeedbackController(this._service);

  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  var isLoading = false.obs;
  var feedbackList = <FeedbackItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeedbacks();
  }

  Future<void> fetchFeedbacks() async {
    isLoading.value = true;
    try {
      final response = await _service.getMyFeedbacks();
      feedbackList.assignAll(response.data?.results ?? []);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitFeedback() async {
    if (subjectController.text.isEmpty || messageController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;
    bool success = await _service.sendFeedback(
      subjectController.text,
      messageController.text,
    );

    if (success) {
      subjectController.clear();
      messageController.clear();
      fetchFeedbacks(); // Refresh list
      Get.snackbar("Success", "Feedback sent to admin");
    } else {
      Get.snackbar("Error", "Failed to send feedback");
    }
    isLoading.value = false;
  }
}