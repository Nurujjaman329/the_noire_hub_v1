import 'package:get/get.dart';
import 'package:the_noire_hub_v1/core/utils/app_snackbar.dart';

import '../../../../../core/services/cache_service.dart';
import '../../data/beautician_store_response_model.dart';
import '../../data/beautician_store_service.dart';

class BeauticianStoreServiceController extends GetxController {
  final BeauticianStoreService _service;
  BeauticianStoreServiceController(this._service);

  // Observable State
  var isLoading = false.obs;
  var services = <ServiceModel>[].obs;

  // Pagination State
  int currentPage = 1;
  bool hasMore = true;
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    if (CacheService.role.toLowerCase().contains('beautician')) {
      fetchServices();
    }
  }

  /// Initial Fetch
  Future<void> fetchServices({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
      // Clearing here ensures that when the user pulls-to-refresh,
      // the old list is gone and the new one starts fresh.
      services.clear();
    }

    if (isLoading.value || !hasMore) return;

    try {
      isLoading.value = true;
      final response = await _service.getBeauticianServices(
        page: currentPage,
        limit: limit,
      );

      final newItems = response.data.attributes.results;

      if (newItems.isEmpty && currentPage == 1) {
        services.clear(); // Ensure it's empty if no results on page 1
      } else {
        services.addAll(newItems);
      }

      // Logic: If we received less than the limit, no more data exists.
      if (newItems.length < limit) {
        hasMore = false;
      } else {
        currentPage++;
      }
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  /// Delete Logic
  Future<void> removeService(String id) async {
    try {
      // Optimistic Update: remove from UI first for speed
      final backup = List<ServiceModel>.from(services);
      services.removeWhere((element) => element.id == id);

      await _service.deleteService(id);
      Get.snackbar("Success", "Service deleted successfully");
    } catch (e) {
      // Rollback if API fails
      fetchServices(isRefresh: true);
      Get.snackbar("Error", "Failed to delete service");
    }
  }
}