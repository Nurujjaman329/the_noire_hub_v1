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
  }) async {
    try {
      // Define your query parameters
      final Map<String, dynamic> queryParams = {
        'page': page,
        'limit': limit,
      };

      if (categoryId != null) {
        queryParams['category'] = categoryId;
      }

      if (categoryType != null) {
        queryParams['categoryType'] = categoryType;
      }

      final response = await _apiClient.get(
        ApiConstants.subCategories,
        queryParameters: queryParams,
      );

      return SubCategoryResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}