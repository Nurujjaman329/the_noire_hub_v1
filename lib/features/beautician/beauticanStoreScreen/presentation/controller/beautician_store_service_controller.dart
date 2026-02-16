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

  @override
  void onInit() {
    super.onInit();
    // ONLY fetch if the role is correct to avoid 403 logs
    if (CacheService.role.toLowerCase().contains('beautician')) {
      fetchServices();
    }
  }

  /// Initial Fetch
  Future<void> fetchServices({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
      services.clear();
    }

    if (!hasMore || isLoading.value) return;

    try {
      isLoading.value = true;

      final response = await _service.getBeauticianServices(
        page: currentPage,
      );

      final newItems = response.data.attributes.results;

      if (newItems.isEmpty) {
        hasMore = false;
      } else {
        services.addAll(newItems);
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