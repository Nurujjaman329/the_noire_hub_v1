import 'package:get/get.dart';

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

    if (categoryType != null) {
      this.categoryType = categoryType;
    }

    // AUTO-DETECTION LOGIC
    String? finalType = categoryType;
    if (finalType == null) {
      final userData = LocalStorage.getUserData();
      final String role = (userData?['role'] ?? '').toString().toLowerCase();

      // Map user role to backend category filter
      if (role == 'vendor') finalType = 'product';
      else if (role == 'beautician') finalType = 'service';
    }

    try {
      final response = await _categoryService.getCategories(
        page: page,
        limit: limit,
        categoryType: finalType, // Use the detected type
      );

      if (response.code == 200) {
        if (page == 1) {
          // Refresh the list if it's the first page
          categories.assignAll(response.data.attributes.results);
        } else {
          // Append to the list if it's a subsequent page
          categories.addAll(response.data.attributes.results);
        }

        // Update pagination info
        currentPage.value = response.data.attributes.page;
        totalPages.value = response.data.attributes.totalPages;
        totalResults.value = response.data.attributes.totalResults;
        hasMoreData.value = currentPage.value < totalPages.value;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreCategories({int limit = 10, String? categoryType}) async {
    if (!hasMoreData.value || isLoading.value) return;

    await loadCategories(
      page: currentPage.value + 1,
      limit: limit,
      categoryType: categoryType,
    );
  }

  Future<void> refreshCategories({int limit = 10, String? categoryType}) async {
    await loadCategories(page: 1, limit: limit, categoryType: categoryType);
  }

  Future<Category?> getCategoryById(String id) async {
    try {
      final category = await _categoryService.getCategoryById(id);
      return category;
    } catch (e) {
      errorMessage.value = e.toString();
      return null;
    }
  }

  Future<void> searchCategories(String query, {int limit = 10}) async {
    // For now, we'll just filter the existing categories
    // In a real implementation, you'd likely have a search endpoint
    if (query.isEmpty) {
      await refreshCategories(limit: limit);
      return;
    }

    final filtered = categories.where((category) =>
        category.name.toLowerCase().contains(query.toLowerCase()) ||
        category.categoryType.toLowerCase().contains(query.toLowerCase())).toList();
    
    categories.assignAll(filtered);
  }
}