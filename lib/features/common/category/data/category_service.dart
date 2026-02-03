import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'category_response_model.dart';

class CategoryService {
  final ApiClient _apiClient;

  CategoryService(this._apiClient);

  Future<CategoryResponse> getCategories({
    int page = 1,
    int limit = 10,
    String? categoryType,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      
      if (categoryType != null) {
        queryParams['categoryType'] = categoryType;
      }

      final response = await _apiClient.get(
        ApiConstants.categories,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return CategoryResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load categories: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load categories: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<Category> getCategoryById(String id) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.categories}/$id',
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        return Category.fromJson(responseData['data']['attributes']);
      } else {
        throw Exception('Failed to load category: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load category: $e');
    }
  }
}