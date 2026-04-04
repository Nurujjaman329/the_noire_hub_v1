import 'package:get/get.dart';
import 'package:the_noire_hub_v1/features/customer/customerServices/data/customer_services_response_model.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/services/cache_service.dart';
import 'package:flutter/material.dart';

import '../../data/customer_service_book_service.dart';

class CustomerServiceController extends GetxController {
  final CustomerServiceBookService _service;
  CustomerServiceController(this._service);

  final searchController = TextEditingController();

  // --- Observables ---
  var isLoading = false.obs;          // For initial/filter loading
  var isMoreLoading = false.obs;      // For pagination loading (bottom spinner)
  var serviceList = <CustomerService>[].obs;
  var favoriteLoadingState = <String, bool>{}.obs;


  // --- Pagination State ---
  int currentPage = 1;
  int totalPages = 1;
  bool get hasMore => currentPage < totalPages;

  // --- Search & Filter State ---
  var searchQuery = "".obs;
  var selectedCategoryId = "".obs;
  var selectedSubCategoryId = "".obs;
  var selectedDistance = 0.obs;
  var selectedRating = 0.0.obs;
  var minPrice = 0.0.obs;
  var maxPrice = 0.0.obs;
  var hasOffer = false.obs;
  var homeService = false.obs;
  var ratingValue = 1.0.obs;
  var priceRange = const RangeValues(1, 50000).obs;

  @override
  void onInit() {
    super.onInit();
    // Debounce for search to avoid API spamming while typing
    debounce(searchQuery, (_) => fetchService(), time: const Duration(milliseconds: 500));
    fetchService();
  }

  // --- Search Actions ---
  void onSearchChanged(String value) => searchQuery.value = value;

  void clearSearch() {
    searchController.clear();
    searchQuery.value = "";
    // fetchService is triggered by debounce automatically
  }

  // --- Filter Actions ---
  void filterByCategory(String id) {
    selectedCategoryId.value = (selectedCategoryId.value == id) ? "" : id;
    selectedSubCategoryId.value = "";
    fetchService();
  }

  void filterBySubCategory(String id) {
    selectedSubCategoryId.value = (selectedSubCategoryId.value == id) ? "" : id;
    fetchService();
  }

  void updatePriceRange(RangeValues values) {
    priceRange.value = values;
    minPrice.value = values.start;
    maxPrice.value = values.end;
  }

  // --- Core API Logic ---

  Future<void> fetchService() async {
    isLoading.value = true;
    currentPage = 1; // Reset to first page on new search/filter

    try {
      final response = await _service.getCustomerService(
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
        homeService: homeService.value ? true : null,
      );

      final attributes = response.data?.attributes;
      final results = attributes?.results ?? <CustomerService>[];
      serviceList.assignAll(results.cast<CustomerService>());
      totalPages = attributes?.totalPages ?? 1;

    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleServiceFavorite(String productId) async {
    try {
      favoriteLoadingState[productId] = true;

      // itemType is "Service" as per your requirement
      final success = await _service.toggleFavorite(productId, "Service");

      if (success) {
        // Find the service in the local list and toggle its 'isFavorite' status
        // to update UI instantly without a full refresh
        int index = serviceList.indexWhere((p) => p.id == productId);
        if (index != -1) {
          // Toggle the isFavorite status and replace the item in the list
          final updatedService = serviceList[index];
          updatedService.isFavorite = !updatedService.isFavorite;
          // Replace the item at the same index to trigger UI update
          serviceList[index] = updatedService;
        }

        // Get.snackbar(
        //   "Success",
        //   "Favorites updated",
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: const Color(0xFF1D3826),
        //   colorText: Colors.white,
        // );
      }
    } on AppException catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      favoriteLoadingState[productId] = false;
    }
  }


  Future<void> loadMore() async {
    // Guard clause: don't load if already loading or no more pages
    if (isLoading.value || isMoreLoading.value || !hasMore) return;

    isMoreLoading.value = true;
    currentPage++;

    try {
      final response = await _service.getCustomerService(
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
        homeService: homeService.value ? true : null,
      );

      final newResults = response.data?.attributes?.results ?? <CustomerService>[];
      if (newResults.isNotEmpty) {
        serviceList.addAll(newResults.cast<CustomerService>());
      }
    } catch (e) {
      currentPage--; // Rollback page on failure
      debugPrint("Pagination Error: $e");
    } finally {
      isMoreLoading.value = false;
    }
  }


  Future<void> onRefresh() async => await fetchService();

  // --- Clear Helpers ---
  void clearRating() { selectedRating.value = 0.0; fetchService(); }
  void clearPrice() { minPrice.value = 0.0; maxPrice.value = 0.0; fetchService(); }
  void resetDistance() { selectedDistance.value = 0; fetchService(); }
  void toggleOffer() { hasOffer.value = !hasOffer.value; fetchService(); }
  void toggleHomeService() { homeService.value = !homeService.value; fetchService(); }
}