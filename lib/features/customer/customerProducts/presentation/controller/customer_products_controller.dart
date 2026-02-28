import 'package:get/get.dart';
import '../../data/customer_products_response_model.dart';
import '../../data/customer_products_service.dart';

class CustomerProductsController extends GetxController {
  final CustomerProductsService _service;
  CustomerProductsController(this._service);

  // Observable state variables
  var isLoading = false.obs;
  var productList = <CustomerProduct>[].obs;

  // Pagination tracking
  int currentPage = 1;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Initial fetch
  }

  /// Initial load or refresh
  Future<void> fetchProducts() async {
    isLoading.value = true;
    currentPage = 1;

    try {
      final response = await _service.getCustomerProducts(page: currentPage);

      // Safety: drill down through the nested model
      final results = response.data?.attributes?.results ?? [];
      productList.assignAll(results);

      // Check if we have more pages (optional but helpful)
      int totalPages = response.data?.attributes?.totalPages ?? 1;
      hasMore = currentPage < totalPages;

    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Logic for infinite scrolling / load more
  Future<void> loadMore() async {
    if (isLoading.value || !hasMore) return;

    currentPage++;
    try {
      final response = await _service.getCustomerProducts(page: currentPage);
      final newResults = response.data?.attributes?.results ?? [];

      if (newResults.isNotEmpty) {
        productList.addAll(newResults);
      } else {
        hasMore = false;
      }
    } catch (e) {
      currentPage--; // Reset page on error
    }
  }
}