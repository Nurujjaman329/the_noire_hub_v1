import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'category_response_model.dart';

class CategoryService {
  final ApiClient _apiClient;

  CategoryService(this._apiClient);

  Future<CategoryResponse> getCategories({
    int page = 1,
    int limit = 10,
    String? id,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (id != null && id.isNotEmpty) {
        queryParams['id'] = id;
      }

      // --- DEBUG LOGS ---
      debugPrint('🚀 [GET] Categories: ${ApiConstants.categories}');
      debugPrint('Params: $queryParams');

      final response = await _apiClient.get(
        ApiConstants.categories,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Categories Loaded Successfully');
        return CategoryResponse.fromJson(response.data);
      } else {
        debugPrint('⚠️ Category Server Error: ${response.statusCode}');
        throw Exception('Failed to load categories: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('❌ Dio Error in getCategories: ${e.response?.data ?? e.message}');
      throw Exception('Failed to load categories: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected Error in getCategories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<Category> getCategoryById(String id) async {
    try {
      debugPrint('🚀 [GET] Category Detail: ${ApiConstants.categories}/$id');

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
      debugPrint('❌ Dio Error in getCategoryById: ${e.message}');
      throw Exception('Failed to load category: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected Error: $e');
      throw Exception('Failed to load category: $e');
    }
  }
}