

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/sub_categories_response_model.dart';
import '../../data/sub_categories_service.dart';

class SubCategoryController extends GetxController {
  final SubCategoryService _service;
  SubCategoryController(this._service);

  // Observable Data Lists
  var subCategories = <SubCategory>[].obs;

  // State States
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var errorMessage = ''.obs;

  // Pagination State
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  String? selectedCategoryId;

  /// Fetches subcategories.
  /// If [categoryId] is provided, it filters the results.
  /// If [isRefresh] is true, it clears the list and starts from page 1.
  Future<void> fetchSubCategories({String? categoryId, bool isRefresh = true}) async {
    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      isLoading.value = true;
      selectedCategoryId = categoryId;
    } else {
      isMoreLoading.value = true;
    }

    errorMessage.value = '';

    try {
      final response = await _service.getSubCategories(
        page: currentPage.value,
        categoryId: selectedCategoryId,
      );

      if (isRefresh) {
        subCategories.assignAll(response.data.attributes.results);
      } else {
        subCategories.addAll(response.data.attributes.results);
      }

      // Logic to determine if there is more data to fetch
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

  /// Triggered when user scrolls to the bottom
  Future<void> loadMore() async {
    if (!isLoading.value && !isMoreLoading.value && hasMoreData.value) {
      await fetchSubCategories(categoryId: selectedCategoryId, isRefresh: false);
    }
  }
}