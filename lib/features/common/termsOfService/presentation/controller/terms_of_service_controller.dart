

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/terms_of_service.dart';

class TermsOfServiceController extends GetxController {
  final TermsOfService _service;
  TermsOfServiceController(this._service);

  final RxBool isLoading = false.obs;
  final RxString content = "".obs;
  final RxString lastUpdated = "".obs; // Added for dynamic date

  @override
  void onInit() {
    super.onInit();
    fetchTermsAndConditions();
  }

  Future<void> fetchTermsAndConditions() async {
    try {
      isLoading.value = true;
      final response = await _service.fetchTerms();

      if (response.data?.attributes != null) {
        content.value = response.data!.attributes!.content;
        lastUpdated.value = response.data!.attributes!.updatedAt;
      } else {
        content.value = "No content available.";
      }
    } catch (e) {
      debugPrint("❌ Controller Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Simple helper to format the ISO date to a readable string
  String get formattedDate {
    if (lastUpdated.value.isEmpty) return "";
    try {
      DateTime dateTime = DateTime.parse(lastUpdated.value);
      // Returns format like: April 02, 2026
      return DateFormat('MMMM dd, yyyy').format(dateTime);
    } catch (e) {
      return lastUpdated.value; // Fallback to raw string if parsing fails
    }
  }
}