

import 'package:get/get.dart';
import 'package:the_noire_hub_v1/core/constants/category_type_constants.dart';
import 'package:the_noire_hub_v1/core/services/cache_service.dart';
import 'package:the_noire_hub_v1/features/common/subCategories/data/sub_categories_response_model.dart';
import '../../data/sub_categories_service.dart';

class SubCategoryController extends GetxController {
  final SubCategoryService _service;
  SubCategoryController(this._service);

  var subCategories = <SubCategoryItem>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var errorMessage = ''.obs;

  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  var selectedCategoryId = RxnString();
  String? categoryType;
  String? currentUserId;

  /// [categoryType] — pass explicitly for registration before cache role exists.
  /// When omitted, vendor/beautician session roles resolve to product/service automatically.
  Future<void> fetchSubCategories({
    String? categoryId,
    String? categoryType,
    String? id,
    bool isRefresh = true,
  }) async {
    final resolvedType = _resolveCategoryType(categoryType);

    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      isLoading.value = true;

      selectedCategoryId.value = categoryId;
      this.categoryType = resolvedType;
      currentUserId = id;
    } else {
      isMoreLoading.value = true;
    }

    errorMessage.value = '';

    try {
      final response = await _service.getSubCategories(
        page: currentPage.value,
        categoryId: selectedCategoryId.value,
        categoryType: this.categoryType,
        id: currentUserId,
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
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  String? _resolveCategoryType(String? explicitType) {
    if (explicitType != null && explicitType.isNotEmpty) {
      return explicitType;
    }
    if (CategoryTypeConstants.isBusinessRole(CacheService.role)) {
      return CategoryTypeConstants.forCurrentBusinessRole();
    }
    return null;
  }

  Future<void> loadMore() async {
    if (!isLoading.value && !isMoreLoading.value && hasMoreData.value) {
      await fetchSubCategories(
        categoryId: selectedCategoryId.value,
        categoryType: categoryType,
        isRefresh: false,
      );
    }
  }
}
