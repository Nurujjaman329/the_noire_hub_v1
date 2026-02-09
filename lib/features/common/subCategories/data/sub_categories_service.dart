import 'package:flutter/material.dart';
import 'package:the_noire_hub_v1/features/common/subCategories/data/sub_categories_response_model.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';

class SubCategoryService {
  final ApiClient _apiClient;
  SubCategoryService(this._apiClient);

  Future<SubCategoryResponse> getSubCategories({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? categoryType,
    String? id,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'limit': limit,
      };

      if (categoryId != null) queryParams['category'] = categoryId;
      if (categoryType != null) queryParams['categoryType'] = categoryType;
      if (id != null) queryParams['id'] = id;

      // --- DEBUG LOGS ---
      debugPrint('🚀 [GET] SubCategories: ${ApiConstants.subCategories}');
      debugPrint('Params: $queryParams');

      final response = await _apiClient.get(
        ApiConstants.subCategories,
        queryParameters: queryParams,
      );

      // Log the data type to catch the "List vs Map" error early
      debugPrint('📥 Response Data Type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        debugPrint('✅ SubCategories Fetched Successfully');

        // Safety check similar to what we discussed for Categories
        if (response.data is List) {
          debugPrint('⚠️ Warning: API returned a List, but Model expects a Map.');
          // You might need to wrap this like we did for CategoryService
        }

        return SubCategoryResponse.fromJson(response.data);
      } else {
        debugPrint('⚠️ SubCategory Server Error: ${response.statusCode}');
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      debugPrint('❌ Error in SubCategoryService: $e');
      rethrow;
    }
  }
}