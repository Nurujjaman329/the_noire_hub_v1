import 'package:get/get.dart';
import 'package:the_noire_hub_v1/features/customer/customerServices/data/customer_services_response_model.dart';
import '../../../../../core/services/cache_service.dart';
import 'package:flutter/material.dart';

import '../../data/customer_service_book_service.dart';

class CustomerServiceController extends GetxController {
  final CustomerServiceBookService _service;
  CustomerServiceController(this._service);

  final searchController = TextEditingController();
  var isLoading = false.obs;
  var serviceList = <CustomerService>[].obs;

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
  var homeService = false.obs;
  var ratingValue = 1.0.obs;

  @override
  void onInit() {
    super.onInit();

    // Debounce for search only
    debounce(searchQuery, (_) {
      fetchService();
    }, time: const Duration(milliseconds: 500));

    fetchService();
  }

  // --- Action Methods ---

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void filterByCategory(String id) {
    // Toggle logic: if clicking the same one, clear it.
    selectedCategoryId.value = (selectedCategoryId.value == id) ? "" : id;
    selectedSubCategoryId.value = ""; // Reset sub when category changes
    fetchService();
  }

  void filterBySubCategory(String id) {
    selectedSubCategoryId.value = (selectedSubCategoryId.value == id) ? "" : id;
    fetchService();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = "";
    fetchService();
  }

  // --- API Calls ---

  Future<void> fetchService() async {
    isLoading.value = true;
    currentPage = 1;

    try {
      final response = await _service.getCustomerService(
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
        homeService: homeService.value ? true : null,
      );

      serviceList.assignAll(response.data?.attributes?.results ?? []);
      hasMore = currentPage < (response.data?.attributes?.totalPages ?? 1);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


// Inside CustomerServiceController
  Future<void> loadMore() async {
    if (isLoading.value || !hasMore) return;
    currentPage++;
    // We don't set isLoading to true here to avoid showing the big center spinner
    // during pagination (optional: use a bottom loading indicator)

    try {
      final response = await _service.getCustomerService(
        page: currentPage,
        latitude: CacheService.lat != 0.0 ? CacheService.lat : null,
        longitude: CacheService.lon != 0.0 ? CacheService.lon : null,
        name: searchQuery.value,
        category: selectedCategoryId.value,
        subcategory: selectedSubCategoryId.value,
        maxDistance: selectedDistance.value, // Keep the 10km or current selection
        minRating: selectedRating.value > 0 ? selectedRating.value : null,
        minPrice: minPrice.value > 0 ? minPrice.value : null,
        maxPrice: maxPrice.value > 0 ? maxPrice.value : null,
        hasOffer: hasOffer.value ? true : null,
        homeService: homeService.value ? true : null,
      );

      final newResults = response.data?.attributes?.results ?? [];
      if (newResults.isNotEmpty) {
        serviceList.addAll(newResults);
      } else {
        hasMore = false;
      }
    } catch (e) {
      currentPage--;
      debugPrint("Pagination Error: $e");
    }
  }


  void clearRating() {
    selectedRating.value = 0.0;
    fetchService();
  }

  void clearPrice() {
    minPrice.value = 0.0;
    maxPrice.value = 0.0;
    fetchService();
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
    fetchService();
  }

  void toggleOffer() {
    hasOffer.value = !hasOffer.value;
    fetchService();
  }
  void toggleHomeService() {
    homeService.value = !homeService.value;
    fetchService();
  }
}