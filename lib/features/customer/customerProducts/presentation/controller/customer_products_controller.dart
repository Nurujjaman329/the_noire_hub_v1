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

  // --- Search & Filter State ---
  var searchQuery = "".obs;
  var selectedCategoryId = "".obs;    // 👈 Added
  var selectedSubCategoryId = "".obs; // 👈 Added

  @override
  void onInit() {
    super.onInit();

    // Debounce for search only
    debounce(searchQuery, (_) {
      fetchProducts();
    }, time: const Duration(milliseconds: 500));

    fetchProducts();
  }

  // --- Action Methods ---

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void filterByCategory(String id) {
    // Toggle logic: if clicking the same one, clear it.
    selectedCategoryId.value = (selectedCategoryId.value == id) ? "" : id;
    selectedSubCategoryId.value = ""; // Reset sub when category changes
    fetchProducts();
  }

  void filterBySubCategory(String id) {
    selectedSubCategoryId.value = (selectedSubCategoryId.value == id) ? "" : id;
    fetchProducts();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = "";
    fetchProducts();
  }

  // --- API Calls ---

  Future<void> fetchProducts() async {
    isLoading.value = true;
    currentPage = 1;

    try {
      final response = await _service.getCustomerProducts(
        page: currentPage,
        latitude: CacheService.lat != 0.0 ? CacheService.lat : null,
        longitude: CacheService.lon != 0.0 ? CacheService.lon : null,
        maxDistance: 10,
        name: searchQuery.value,
        category: selectedCategoryId.value,    // 👈 Added
        subcategory: selectedSubCategoryId.value, // 👈 Added
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
        name: searchQuery.value, // 👈 Keep search
        category: selectedCategoryId.value, // 👈 Keep category
        subcategory: selectedSubCategoryId.value, // 👈 Keep subcategory
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