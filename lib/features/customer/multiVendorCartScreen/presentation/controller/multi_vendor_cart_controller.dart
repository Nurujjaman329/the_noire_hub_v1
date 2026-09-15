import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/app_snackbar.dart';
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

  /// Minus: qty stays ≥ 1 → PATCH; otherwise DELETE item.
  Future<void> updateItemQuantity(String cartItemId, int newQuantity) async {
    if (newQuantity < 1) {
      await removeCartItem(cartItemId);
      return;
    }

    if (isUpdating.value) return;

    try {
      isUpdating.value = true;
      await _cartService.updateQuantity(cartItemId, newQuantity);
      await getCartDetails();
    } catch (e) {
      AppSnackbar.error('Could not update quantity', title: 'Cart');
      debugPrint("❌ Update Qty Error: $e");
    } finally {
      isUpdating.value = false;
    }
  }

  /// Single line remove — DELETE /cart/items/{id}
  Future<void> removeCartItem(String cartItemId) async {
    final id = cartItemId.trim();
    if (id.isEmpty || isUpdating.value) return;

    try {
      isUpdating.value = true;
      await _cartService.removeItem(id);
      await getCartDetails();
      AppSnackbar.success('Item removed from cart', title: 'Cart');
    } catch (e) {
      AppSnackbar.error('Could not remove item. Please try again.', title: 'Cart');
      debugPrint("❌ Remove item Error: $e");
    } finally {
      isUpdating.value = false;
    }
  }

  /// Entire cart — DELETE /cart (with confirm by default)
  Future<void> clearEntireCart({bool confirm = true}) async {
    if (isCartEmpty || isUpdating.value) return;

    if (confirm) {
      final ok = await Get.dialog<bool>(
            AlertDialog(
              title: const Text('Clear cart?'),
              content: const Text(
                'This removes every item from your cart. This cannot be undone.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Get.back(result: true),
                  child: const Text('Clear'),
                ),
              ],
            ),
          ) ??
          false;
      if (!ok) return;
    }

    try {
      isUpdating.value = true;
      await _cartService.clearCart();
      await getCartDetails();
      AppSnackbar.success('Cart cleared', title: 'Cart');
    } catch (e) {
      AppSnackbar.error('Could not clear cart. Please try again.', title: 'Cart');
      debugPrint("❌ Clear cart Error: $e");
    } finally {
      isUpdating.value = false;
    }
  }

  // --- Helpers for UI ---

  bool get isCartEmpty =>
      cartAttributes.value == null || cartAttributes.value!.vendors.isEmpty;

  double get grandTotal => cartAttributes.value?.grandTotal ?? 0.0;

  int get totalItemCount => cartAttributes.value?.totalItems ?? 0;
}
