import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/api/api_exception.dart';
import '../../../data/businessInfo/business_info_response_model.dart';
import '../../../data/businessInfo/business_info_service.dart';

class BusinessInfoController extends GetxController {
  final BusinessInfoService _service;
  BusinessInfoController(this._service);

  var isLoading = false.obs;
  var businessData = Rxn<BusinessData>();

  @override
  void onInit() {
    super.onInit();
    fetchBusinessInfo();
  }

  Future<void> fetchBusinessInfo() async {
    isLoading.value = true;
    try {
      final response = await _service.getBusinessInfo();
      businessData.value = response.data;
    } on AppException catch (e) {
      debugPrint("Error fetching business info: ${e.message}");
    } finally {
      isLoading.value = false;
    }
  }
}