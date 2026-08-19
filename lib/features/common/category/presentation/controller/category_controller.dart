// lib/features/common/category/presentation/controller/category_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/category_response_model.dart';
import '../../data/category_service.dart';


class CategoryController extends GetxController {
  final CategoryService _categoryService;
  CategoryController(this._categoryService);

  var categories = <Category>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var errorMessage = ''.obs;
  var currentPage = 1.obs;
  var totalPages = 0.obs;
  var totalResults = 0.obs;
  var hasMoreData = true.obs;

  String? currentUserId;

  /// Loads all categories from `/categories` (no categoryType filter).
  Future<void> loadCategories({
    int page = 1,
    int limit = 10,
    String? userId,
  }) async {
    if (page == 1) {
      isLoading.value = true;
      currentPage.value = 1;
      hasMoreData.value = true;
    } else {
      isMoreLoading.value = true;
    }

    currentUserId = userId;

    try {
      final response = await _categoryService.getCategories(
        page: page,
        limit: limit,
        id: userId,
      );

      if (page == 1) {
        categories.assignAll(response.data.attributes.results);
      } else {
        categories.addAll(response.data.attributes.results);
      }

      final attributes = response.data.attributes;
      currentPage.value = attributes.page;
      totalPages.value = attributes.totalPages;
      totalResults.value = attributes.totalResults;
      hasMoreData.value = currentPage.value < totalPages.value;
    } catch (e) {
      debugPrint("Load Error: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> loadMoreCategories({int limit = 10}) async {
    if (!hasMoreData.value || isLoading.value || isMoreLoading.value) return;
    await loadCategories(
      page: currentPage.value + 1,
      limit: limit,
      userId: currentUserId,
    );
  }

  Future<void> refreshCategories({int limit = 10}) async {
    await loadCategories(
      page: 1,
      limit: limit,
      userId: currentUserId,
    );
  }

  void searchLocalCategories(String query) {
    if (query.isEmpty) {
      refreshCategories();
      return;
    }
    final filtered = categories.where((cat) =>
        cat.name.toLowerCase().contains(query.toLowerCase())).toList();
    categories.assignAll(filtered);
  }
}
