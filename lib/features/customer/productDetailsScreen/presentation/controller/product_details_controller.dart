import 'package:get/get.dart';
import '../../../customerProducts/data/customer_products_response_model.dart';
import '../../../customerProducts/data/customer_products_service.dart';
import '../../data/product_details_response_model.dart';

class ProductDetailsController extends GetxController {
  final CustomerProductsService _service;
  ProductDetailsController(this._service);

  var isLoading = false.obs;

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

  // --- Logic Methods ---
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