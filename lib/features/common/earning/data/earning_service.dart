import 'package:flutter/material.dart';
import 'package:the_noire_hub_v1/core/api/api_exception.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'earning_response_model.dart';

class EarningService {
  final ApiClient _apiClient;

  EarningService(this._apiClient);

  Future<EarningResponseModel> getEarnings() async {
    try {
      // --- DEBUG LOGS ---
      debugPrint('🚀 [GET] Earnings: ${ApiConstants.totalEarning}');

      final response = await _apiClient.get(
        ApiConstants.totalEarning,
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Earnings Loaded Successfully');
        return EarningResponseModel.fromJson(response.data);
      } else {
        debugPrint('⚠️ Earnings Server Error: ${response.statusCode}');
        throw Exception('Failed to load earnings: ${response.statusMessage}');
      }
    } on AppException catch (e) {
      debugPrint('❌ Dio Error in getEarnings: ${e.message}');
      throw Exception('Failed to load earnings: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected Error in getEarnings: $e');
      throw Exception('Failed to load earnings: $e');
    }
  }
}