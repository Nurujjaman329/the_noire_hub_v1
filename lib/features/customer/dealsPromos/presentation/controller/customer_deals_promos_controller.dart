import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/customer_deals_promos_response_model.dart';
import '../../data/customer_deals_promos_service.dart';

class CustomerDealsPromosController extends GetxController {
  final CustomerDealsPromosService _service;
  CustomerDealsPromosController(this._service);

  // State
  var promoList = <CustomerPromoCodeModel>[].obs;
  var isListLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPromos();
  }

  /// Fetch promos (optionally filtered by user role / createdBy)
  Future<void> fetchPromos({String? createdBy}) async {
    try {
      isListLoading.value = true;
      final response = await _service.fetchPromos(createdBy: createdBy);

      if (response.data?.attributes != null) {
        promoList.value = response.data!.attributes!.results;
        debugPrint("✅ Loaded ${promoList.length} promos");
      } else {
        promoList.clear();
      }
    } catch (e) {
      promoList.clear();
      debugPrint("❌ PromoCodeController fetchPromos error: $e");
    } finally {
      isListLoading.value = false;
    }
  }

  /// Remove promo locally
  void removePromo(String id) {
    promoList.removeWhere((promo) => promo.id == id);
  }
}