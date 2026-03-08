import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';

class ProductRatingService {
  final ApiClient _apiClient;

  ProductRatingService(this._apiClient);

  /// ✅ POST: Submit Service Rating/Review
  Future<bool> submitRating({
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    try {
      final String url = '${ApiConstants.productRating}$bookingId';

      final Map<String, dynamic> body = {
        "rating": rating,
        "comment": comment,
      };

      // ✅ Debug Request Details
      debugPrint('🚀 [POST] Submitting Rating');
      debugPrint('🔗 URL: $url');
      debugPrint('📦 BODY: $body');

      final response = await _apiClient.postJson(
        url,
        data: body,
      );

      // ✅ Debug Success Response
      debugPrint('✅ [SUCCESS] Status: ${response.statusCode}');
      debugPrint('📩 RESPONSE: ${response.data}');

      return response.statusCode == 200 || response.statusCode == 201;
    } on AppException catch (e) {
      // ✅ This catches the processed error from your ApiClient's _handleDioError
      debugPrint("🛑 [AppException] Message: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("❌ [Unexpected Error]: $e");
      throw Exception("Failed to submit rating: $e");
    }
  }
}