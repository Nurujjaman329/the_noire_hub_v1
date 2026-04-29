import 'package:get/get.dart';
import '../../../customerProducts/data/customer_products_response_model.dart';
import '../../../customerProducts/data/customer_products_service.dart';
import '../../../multiVendorCartScreen/presentation/controller/multi_vendor_cart_controller.dart';
import '../../data/product_details_response_model.dart';
import 'package:flutter/material.dart';

class ProductDetailsController extends GetxController {
  final CustomerProductsService _service;
  ProductDetailsController(this._service);

  var isLoading = false.obs;
  var isCartLoading = false.obs;
  var selectedPromoCode = ''.obs;

  // 🟢 Fixed: Use the correct class name from your model
  var product = Rxn<DetailsProductAttributes>();

  // UI States
  var selectedImageIndex = 0.obs;
  var selectedVariantId = "".obs;
  var quantity = 1.obs; // 👈 Added: Missing in your snippet

  @override
  void onInit() {
    super.onInit();
    // Handles both String ID or full Object passed via Get.toNamed
    final dynamic args = Get.arguments;
    String? productId;

    if (args is String) {
      productId = args;
    } else if (args is CustomerProduct) {
      productId = args.id;
    }

    if (productId != null && productId.isNotEmpty) {
      fetchProductDetails(productId);
    } else {
      Get.back();
      Get.snackbar("Error", "Product ID not found");
    }
  }

  Future<void> fetchProductDetails(String id) async {
    isLoading.value = true;
    try {
      final response = await _service.getProductDetails(id);
      product.value = response.data?.attributes;

      if (product.value?.variants.isNotEmpty ?? false) {
        selectedVariantId.value = product.value!.variants.first.id;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load details");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> addToCart() async {
    if (product.value == null) return;

    isCartLoading.value = true;
    try {
      // 1. Always include productId and quantity
      final Map<String, dynamic> cartData = {
        "productId": product.value!.id,
        "quantity": quantity.value,
      };

      // 2. Add variantId ONLY if one is selected
      if (selectedVariantId.value.isNotEmpty) {
        cartData["variantId"] = selectedVariantId.value;
      }

      // Call service with updated map
      await _service.addToCart(cartData);

      if (Get.isRegistered<MultiVendorCartController>()) {
        Get.find<MultiVendorCartController>().getCartDetails();
      }

      Get.snackbar(
        "Success",
        "Item added to cart",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0XFF1D3826),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to add item to cart");
    } finally {
      isCartLoading.value = false;
    }
  }
  // --- Logic Methods ---

  void togglePromoCode(String code) {
    if (selectedPromoCode.value == code) {
      selectedPromoCode.value = ''; // Deselect if already selected
    } else {
      selectedPromoCode.value = code;
    }
  }

  void changeImage(int index) => selectedImageIndex.value = index;
  void selectVariant(String id) => selectedVariantId.value = id;

  void incrementQty() {
    if (quantity.value < (product.value?.stock ?? 1)) quantity.value++;
  }

  void decrementQty() {
    if (quantity.value > 1) quantity.value--;
  }

  // 🟢 Helper: Dynamic Price Calculation
  num get currentPrice {
    final v = selectedVariant;
    if (v != null) return v.price;
    return product.value?.discountedPrice ?? 0;
  }

  DetailsVariant? get selectedVariant => product.value?.variants
      .firstWhereOrNull((v) => v.id == selectedVariantId.value);
}