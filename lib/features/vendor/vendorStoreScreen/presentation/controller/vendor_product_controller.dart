import 'package:get/get.dart';

import '../../../../../core/api/api_exception.dart';
import '../../data/vendor_products_response_model.dart';
import '../../data/vendor_products_service.dart';

class VendorProductController extends GetxController {
  final VendorProductService _service;
  VendorProductController(this._service);

  var isLoading = false.obs;
  var productList = <VendorProductModel>[].obs;
  var errorMessage = ''.obs;

  // Pagination Variables
  int currentPage = 1;
  bool hasNextPage = true;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (!hasNextPage) return;
      currentPage++;
    } else {
      currentPage = 1;
      productList.clear();
      isLoading.value = true;
    }

    errorMessage.value = '';

    try {
      final response = await _service.getVendorProducts(
        page: currentPage,
        limit: 10,
      );

      productList.addAll(response.data.results);

      // Check if more pages exist
      hasNextPage = currentPage < response.data.totalPages;

    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = "An unexpected error occurred";
    } finally {
      isLoading.value = false;
    }
  }
}