

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/sub_categories_response_model.dart';
import '../../data/sub_categories_service.dart';

class SubCategoryController extends GetxController {
  final SubCategoryService _service;
  SubCategoryController(this._service);

  var subCategories = <SubCategory>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var errorMessage = ''.obs;

  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  String? selectedCategoryId;
  String? categoryType; // Stores the active filter (product/service)

  Future<void> fetchSubCategories({
    String? categoryId,
    String? categoryType,
    bool isRefresh = true
  }) async {
    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      isLoading.value = true;
      selectedCategoryId = categoryId;
      // Store the type in state for future pagination/loads
      this.categoryType = categoryType;
    } else {
      isMoreLoading.value = true;
    }

    errorMessage.value = '';

    try {
      final response = await _service.getSubCategories(
        page: currentPage.value,
        categoryId: selectedCategoryId,
        categoryType: this.categoryType, // Use the stored state
      );

      if (isRefresh) {
        subCategories.assignAll(response.data.attributes.results);
      } else {
        subCategories.addAll(response.data.attributes.results);
      }

      hasMoreData.value = currentPage.value < response.data.attributes.totalPages;

      if (hasMoreData.value) {
        currentPage.value++;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('❌ SubCategory Error: $e');
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!isLoading.value && !isMoreLoading.value && hasMoreData.value) {
      // Pass categoryType: categoryType to maintain the product/service filter
      await fetchSubCategories(
          categoryId: selectedCategoryId,
          categoryType: categoryType,
          isRefresh: false
      );
    }
  }
}