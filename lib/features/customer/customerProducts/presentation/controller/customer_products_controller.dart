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

  var selectedDistance = 0.obs;
  var selectedRating = 0.0.obs;
  var minPrice = 0.0.obs;
  var maxPrice = 0.0.obs;
  var hasOffer = false.obs;
  var ratingValue = 1.0.obs;

  final ScrollController scrollController = ScrollController();
  var isMoreLoading = false.obs;


  @override
  void onInit() {
    super.onInit();

    // Setup pagination listener
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });

    debounce(searchQuery, (_) => fetchProducts(), time: const Duration(milliseconds: 500));
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
        name: searchQuery.value,
        category: selectedCategoryId.value,
        subcategory: selectedSubCategoryId.value,
        // Only send maxDistance if it's greater than 0
        maxDistance: selectedDistance.value > 0 ? selectedDistance.value : null,
        minRating: selectedRating.value > 0 ? selectedRating.value : null,
        minPrice: minPrice.value > 0 ? minPrice.value : null,
        maxPrice: maxPrice.value > 0 ? maxPrice.value : null,
        hasOffer: hasOffer.value ? true : null,
      );

      productList.assignAll(response.data?.attributes?.results ?? []);
      hasMore = currentPage < (response.data?.attributes?.totalPages ?? 1);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> loadMore() async {
    if (isLoading.value || isMoreLoading.value || !hasMore) return;

    isMoreLoading.value = true;
    currentPage++;

    try {
      final response = await _service.getCustomerProducts(
        page: currentPage,
        latitude: CacheService.lat != 0.0 ? CacheService.lat : null,
        longitude: CacheService.lon != 0.0 ? CacheService.lon : null,
        name: searchQuery.value,
        category: selectedCategoryId.value,
        subcategory: selectedSubCategoryId.value,
        maxDistance: selectedDistance.value > 0 ? selectedDistance.value : null,
        minRating: selectedRating.value > 0 ? selectedRating.value : null,
        minPrice: minPrice.value > 0 ? minPrice.value : null,
        maxPrice: maxPrice.value > 0 ? maxPrice.value : null,
        hasOffer: hasOffer.value ? true : null,
      );

      final newResults = response.data?.attributes?.results ?? [];
      if (newResults.isNotEmpty) {
        productList.addAll(newResults);
        // Update hasMore based on meta data
        hasMore = currentPage < (response.data?.attributes?.totalPages ?? 1);
      } else {
        hasMore = false;
      }
    } catch (e) {
      currentPage--;
      debugPrint("Pagination Error: $e");
    } finally {
      isMoreLoading.value = false;
    }
  }


  void clearRating() {
    selectedRating.value = 0.0;
    fetchProducts();
  }

  void clearPrice() {
    minPrice.value = 0.0;
    maxPrice.value = 0.0;
    fetchProducts();
  }

  var priceRange = const RangeValues(1, 50000).obs;

  void updatePriceRange(RangeValues values) {
    priceRange.value = values;
    minPrice.value = values.start;
    maxPrice.value = values.end;
  }

// but you can reset it to default here if needed.
  void resetDistance() {
    selectedDistance.value = 0; // Clear the filter
    fetchProducts();
  }

  void toggleOffer() {
    hasOffer.value = !hasOffer.value;
    fetchProducts();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}