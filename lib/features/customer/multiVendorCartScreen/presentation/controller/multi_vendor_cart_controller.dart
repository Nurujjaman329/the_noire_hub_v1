

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/multi_vendor_cart_response_model.dart';
import '../../data/multi_vendor_cart_service.dart';

class MultiVendorCartController extends GetxController {
  final MultiVendorCartService _cartService;
  MultiVendorCartController(this._cartService);

  var isLoading = false.obs;
  var isUpdating = false.obs;

  // Using Rxn to handle the initial null state before data is fetched
  final cartAttributes = Rxn<CartAttributes>();

  @override
  void onInit() {
    super.onInit();
    getCartDetails();
  }

  Future<void> getCartDetails() async {
    try {
      isLoading.value = true;
      final response = await _cartService.fetchCart();

      if (response.code == 200 && response.data != null) {
        cartAttributes.value = response.data!.attributes;
      }
    } catch (e) {
      debugPrint("❌ CartController Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Handle Quantity Change
  Future<void> updateItemQuantity(String cartItemId, int newQuantity) async {
    if (newQuantity < 1) return; // Prevent zero/negative quantities

    try {
      isUpdating.value = true;
      await _cartService.updateQuantity(cartItemId, newQuantity);

      // Re-fetch cart to get updated grand total and subtotals
      await getCartDetails();
    } catch (e) {
      Get.snackbar("Error", "Could not update quantity");
      debugPrint("❌ Update Qty Error: $e");
    } finally {
      isUpdating.value = false;
    }
  }

  // --- Helpers for UI ---

  bool get isCartEmpty => cartAttributes.value == null || cartAttributes.value!.vendors.isEmpty;

  double get grandTotal => cartAttributes.value?.grandTotal ?? 0.0;

  int get totalItemCount => cartAttributes.value?.totalItems ?? 0;
}