


import 'package:get/get.dart';
import 'package:the_noire_hub_v1/core/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import '../../data/model/add_deals_promos_post_body.dart';
import '../../data/model/deals_promos_response_model.dart';
import '../../data/service/deals_promos_service.dart';

class PromoCodeController extends GetxController {
  final DealsPromosService _service;
  PromoCodeController(this._service);

  var isLoading = false.obs;
  var isListLoading = false.obs; // Separate loader for the list
  var promoList = <PromoCodeModel>[].obs; // Observable list

  @override
  void onInit() {
    super.onInit();
    getPromos(); // Fetch data when controller starts
  }

  // Fetch all promos
  Future<void> getPromos() async {
    try {
      isListLoading.value = true;
      final responseModel = await _service.fetchPromos();
      promoList.assignAll(responseModel.data.attributes.results);
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      isListLoading.value = false;
    }
  }

  // Create
  Future<void> addPromo(AddDealsPromosPostBody body) async {
    try {
      isLoading.value = true;
      await _service.createPromo(body);
      Get.back();
      getPromos(); // ✅ Refresh list
      AppSnackbar.success("Promo code created successfully");
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Update
  Future<void> patchPromo(String id, EditDealsPromosPostBody body) async {
    try {
      isLoading.value = true;
      await _service.updatePromo(id, body);
      Get.back();
      getPromos(); // ✅ Refresh list
      AppSnackbar.success("Promo updated successfully", title: "Updated");
    } catch (e) {
      AppSnackbar.error(e.toString(), title: "Update Failed");
    } finally {
      isLoading.value = false;
    }
  }

  // Delete
  Future<void> removePromo(String id) async {
    try {
      isLoading.value = true;
      await _service.deletePromo(id);
      getPromos(); // ✅ Refresh list
      AppSnackbar.success("Promo code removed", title: "Deleted");
    } catch (e) {
      AppSnackbar.error(e.toString(), title: "Delete Failed");
    } finally {
      isLoading.value = false;
    }
  }
}