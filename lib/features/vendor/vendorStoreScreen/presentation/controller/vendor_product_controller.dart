import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../data/vendor_products_response_model.dart';
import '../../data/vendor_products_service.dart';

class VendorProductController extends GetxController {
  final VendorProductList _service;
  VendorProductController(this._service);

  // Observables
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var productList = <Product>[].obs;
  var errorMessage = ''.obs;

  // Pagination Variables
  int currentPage = 1;
  bool hasNextPage = true;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  /// Initial fetch or Pull-to-refresh
  Future<void> refreshProducts() async {
    await fetchProducts(isLoadMore: false);
  }

  Future<void> fetchProducts({bool isLoadMore = false}) async {
    // 1. Prevent unnecessary calls
    if (isLoadMore) {
      if (!hasNextPage || isMoreLoading.value) return;
      isMoreLoading.value = true;
      currentPage++;
    } else {
      currentPage = 1;
      hasNextPage = true;
      isLoading.value = true;
      productList.clear(); // Clear list for fresh data
    }

    errorMessage.value = '';

    try {
      // 2. Fetch data from service
      final response = await _service.getVendorProducts(
        page: currentPage,
        limit: 10,
      );

      // 3. Drill down into the response model: response.data.attributes.results
      final newProducts = response.data.attributes.results;

      if (newProducts.isNotEmpty) {
        productList.addAll(newProducts);
      }

      // 4. Update pagination state from attributes
      hasNextPage = currentPage < response.data.attributes.totalPages;

    } on AppException catch (e) {
      errorMessage.value = e.message;
      // Revert page count on failure
      if (isLoadMore) currentPage--;
    } catch (e) {
      errorMessage.value = "An unexpected error occurred";
      if (isLoadMore) currentPage--;
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }


  Future<void> deleteProduct(String productId) async {
    try {
      // We don't necessarily need a global loading state here
      // unless you want to block the whole screen
      errorMessage.value = '';

      await _service.deleteProduct(productId);

      // Remove from local list so UI updates instantly
      productList.removeWhere((p) => p.id == productId);


      AppSnackbar.success("Product deleted successfully");


    } on AppException catch (e) {
      AppSnackbar.error(e.message);
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      AppSnackbar.error("Failed to delete product");
    }
  }
}