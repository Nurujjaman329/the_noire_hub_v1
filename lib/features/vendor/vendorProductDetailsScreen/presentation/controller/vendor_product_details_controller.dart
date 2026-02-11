import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_exception.dart';
import '../../data/vendor_product_details_response_model.dart';
import '../../data/vendor_product_details_service.dart';


class VendorProductDetailsController extends GetxController {
  final VendorProductDetailsService _service;
  VendorProductDetailsController(this._service);

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Reactive Product Detail Data
  var productDetails = Rxn<ProductDetailData>();


  @override
  void onInit() {
    super.onInit();
    // Get the ID passed from the previous screen (VendorStoreScreen)
    final productId = Get.arguments;
    if (productId != null && productId is String) {
      fetchDetails(productId);
    } else {
      errorMessage.value = "Product ID is missing";
    }
  }

  Future<void> fetchDetails(String id) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _service.getProductDetails(id);
      productDetails.value = response.data;
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = "Failed to load product details";
      debugPrint("❌ Detail Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}