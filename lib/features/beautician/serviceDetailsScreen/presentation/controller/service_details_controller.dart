import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/service_details_response_model.dart';
import '../../data/service_details_service.dart';


class ServiceDetailsController extends GetxController {
  final ServiceDetailsService _service;
  final String serviceId;

  ServiceDetailsController(this._service, {required this.serviceId});

  // Observables
  final isLoading = true.obs;
  final serviceData = Rxn<ServiceAttributes>();

  @override
  void onInit() {
    super.onInit();
    fetchServiceDetails();
  }

  Future<void> fetchServiceDetails() async {
    try {
      isLoading(true);
      final response = await _service.getServiceDetails(serviceId);
      serviceData.value = response.data.attributes;
    } catch (e) {
      // Error handling is managed by your AppException/Global handler
      debugPrint("❌ Error in Controller: $e");
    } finally {
      isLoading(false);
    }
  }
}