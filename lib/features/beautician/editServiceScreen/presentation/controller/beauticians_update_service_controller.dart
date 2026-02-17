import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../beauticanStoreScreen/presentation/controller/beautician_store_service_controller.dart';
import '../../data/Beautician_service_update_post_body.dart';
import '../../data/beauticians_update_service.dart';


class BeauticiansUpdateServiceController extends GetxController {
  final BeauticiansUpdateService _storeService;
  BeauticiansUpdateServiceController(this._storeService);

  var isLoading = false.obs;

  // Observable list to manage variants directly in the update controller
  var selectedVariants = <ServiceVariantUpdateBody>[].obs;

  Future<void> patchService(String serviceId, BeauticianServiceUpdatePostBody updateData) async {
    if (serviceId.isEmpty) {
      Get.snackbar("Error", "Service ID is missing", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final bool success = await _storeService.updateService(serviceId, updateData);
      if (success) {
        Get.back();
        Get.snackbar("Success", "Service updated successfully!", backgroundColor: const Color(0xFF1D3826), colorText: Colors.white);
        Get.find<BeauticianStoreServiceController>().fetchServices();
      }
    } finally {
      isLoading.value = false;
    }
  }
}