import 'package:get/get.dart';
import '../../../../../core/services/cache_service.dart';
import '../../data/customer_products_response_model.dart';
import '../../data/customer_products_service.dart';
import 'package:flutter/material.dart';

class CustomerProductsController extends GetxController {
  final CustomerProductsService _service;
  CustomerProductsController(this._service);

  final searchController = TextEditingController();
  var isLoading = false.obs;
  var productList = <CustomerProduct>[].obs;

  int currentPage = 1;
  bool hasMore = true;

  // Use an observable string for the search to trigger debounce
  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();

    // Now debounce listens to the observable 'searchQuery'
    debounce(searchQuery, (_) {
      fetchProducts();
    }, time: const Duration(milliseconds: 500));

    fetchProducts();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value; // This triggers the debounce
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = "";
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    currentPage = 1;

    try {
      final response = await _service.getCustomerProducts(
        page: currentPage,
        latitude: CacheService.lat != 0.0 ? CacheService.lat : null,
        longitude: CacheService.lon != 0.0 ? CacheService.lon : null,
        maxDistance: 10,
        name: searchQuery.value, // Use the observable value
      );

      final results = response.data?.attributes?.results ?? [];
      productList.assignAll(results);

      int totalPages = response.data?.attributes?.totalPages ?? 1;
      hasMore = currentPage < totalPages;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || !hasMore) return;
    currentPage++;

    try {
      final response = await _service.getCustomerProducts(
        page: currentPage,
        latitude: CacheService.lat != 0.0 ? CacheService.lat : null,
        longitude: CacheService.lon != 0.0 ? CacheService.lon : null,
        maxDistance: 10,
        // name: currentSearch, // 👈 Maintain search during pagination
      );

      final newResults = response.data?.attributes?.results ?? [];
      if (newResults.isNotEmpty) {
        productList.addAll(newResults);
      } else {
        hasMore = false;
      }
    } catch (e) {
      currentPage--;
    }
  }

}