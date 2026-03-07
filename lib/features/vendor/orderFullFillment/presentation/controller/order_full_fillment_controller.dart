import 'package:get/get.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../data/order_full_fillment_post_body.dart';
import '../../data/order_full_fillment_response_model.dart';
import '../../data/order_full_fillment_service.dart';
import 'package:flutter/material.dart';

class OrderFullFillmentController extends GetxController {
  final OrderFullFillmentService _service;
  OrderFullFillmentController(this._service);

  var isLoading = false.obs;
  var isSaving = false.obs;

  // We use two different variables to prevent data from flickering
  // between "General" and "Vendor-Specific" views.
  var vendorFulfillmentData = Rxn<GetOrderFulfillmentAttributes>();
  var generalFulfillmentData = Rxn<GetOrderFulfillmentAttributes>();

  // Helper getter to decide which data to show if you use one variable
  var fulfillmentData = Rxn<GetOrderFulfillmentAttributes>();

  @override
  void onInit() {
    super.onInit();
    // Only call this here if you want general settings pre-loaded
    // fetchSettings();
  }

  /// GET: Fetch settings
  Future<void> fetchSettings({String? vendorId}) async {
    isLoading.value = true;
    try {
      final response = await _service.getFulfillmentSettings(vendorId: vendorId);

      // Update the specific observable based on whether an ID was provided
      if (vendorId != null && vendorId.isNotEmpty && vendorId != "null") {
        vendorFulfillmentData.value = response.data.attributes;
        fulfillmentData.value = response.data.attributes; // For shared UI
      } else {
        generalFulfillmentData.value = response.data.attributes;
        fulfillmentData.value = response.data.attributes; // For shared UI
      }
    } on AppException catch (e) {
      debugPrint("Error fetching fulfillment: ${e.message}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSettings(OrderFullFillmentPostBody body) async {
    isSaving.value = true;
    try {
      final success = await _service.saveFulfillmentSettings(body);
      if (success) {
        AppSnackbar.success("Fulfillment settings updated successfully!");
        // Refresh without ID (General settings)
        await fetchSettings();
      }
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isSaving.value = false;
    }
  }
}