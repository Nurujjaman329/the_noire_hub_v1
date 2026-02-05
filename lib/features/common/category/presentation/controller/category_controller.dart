import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/storage/local_storage.dart';
import '../../data/category_response_model.dart';
import '../../data/category_service.dart';


class CategoryController extends GetxController {
  final CategoryService _categoryService;
  CategoryController(this._categoryService);

  var categories = <Category>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var currentPage = 1.obs;
  var totalPages = 0.obs;
  var totalResults = 0.obs;
  var hasMoreData = true.obs;
  String? categoryType;

  Future<void> loadCategories({int page = 1, int limit = 10, String? categoryType}) async {
    if (page == 1) isLoading.value = true;
    errorMessage.value = '';

    // Use specific categoryType if provided, otherwise auto-detect
    String? finalType = categoryType ?? this.categoryType;

    if (finalType == null) {
      // PRO AUTO-DETECTION: Using the strongly-typed UserModel
      final user = LocalStorage.getUserModel();
      final String role = user?.role.toLowerCase() ?? '';

      if (role.contains('vendor')) {
        finalType = 'product';
      } else if (role.contains('beautician')) {
        finalType = 'service';
      }

      // Save the detected type for pagination/refreshing
      this.categoryType = finalType;
    }

    try {
      final response = await _categoryService.getCategories(
        page: page,
        limit: limit,
        categoryType: finalType,
      );

      if (page == 1) {
        categories.assignAll(response.data.attributes.results);
      } else {
        categories.addAll(response.data.attributes.results);
      }

      // Update pagination metadata
      currentPage.value = response.data.attributes.page;
      totalPages.value = response.data.attributes.totalPages;
      totalResults.value = response.data.attributes.totalResults;
      hasMoreData.value = currentPage.value < totalPages.value;

    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = "An unexpected error occurred";
      debugPrint("Category Load Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreCategories({int limit = 10}) async {
    if (!hasMoreData.value || isLoading.value) return;
    await loadCategories(page: currentPage.value + 1, limit: limit);
  }

  Future<void> refreshCategories({int limit = 10}) async {
    await loadCategories(page: 1, limit: limit);
  }

  // Improved search: Don't overwrite the original list permanently
  // In a real app, this should call a search API endpoint
  void searchLocalCategories(String query) {
    if (query.isEmpty) {
      refreshCategories(); // Reset to full list
      return;
    }

    final filtered = categories.where((cat) =>
        cat.name.toLowerCase().contains(query.toLowerCase())).toList();
    categories.assignAll(filtered);
  }
}