import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../data/feedback_response_model.dart';
import '../../data/feedback_service.dart';


class FeedbackController extends GetxController {
  final FeedbackService _service;
  FeedbackController(this._service);

  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  var isFetching = false.obs;
  var isSubmitting = false.obs;

  var feedbackList = <FeedbackItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeedbacks();
  }

  Future<void> fetchFeedbacks() async {
    isFetching.value = true;
    try {
      final response = await _service.getMyFeedbacks();
      feedbackList.assignAll(response.data?.results ?? []);
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> submitFeedback() async {
    if (subjectController.text.isEmpty || messageController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isSubmitting.value = true;

    bool success = await _service.sendFeedback(
      subjectController.text,
      messageController.text,
    );

    if (success) {
      subjectController.clear();
      messageController.clear();
      await fetchFeedbacks();
      Get.snackbar("Success", "Feedback sent to admin");
    } else {
      Get.snackbar("Error", "Failed to send feedback");
    }

    isSubmitting.value = false;
  }
}