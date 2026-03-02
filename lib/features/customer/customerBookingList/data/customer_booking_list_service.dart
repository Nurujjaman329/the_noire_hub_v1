import 'package:flutter/material.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'customer_booking_list_response_model.dart';

class CustomerBookingListService {
  final ApiClient _apiClient;
  CustomerBookingListService(this._apiClient);

  Future<CustomerBookingListResponseModel> getCustomerBookings({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
    };

    if (status != null) queryParams['status'] = status;

    // --- DEBUG PRINT: REQUEST ---
    debugPrint('🚀 [GET] Request to: ${ApiConstants.customerBookings}');
    debugPrint('Params: $queryParams');

    try {
      final response = await _apiClient.get(
        ApiConstants.customerBookings,
        queryParameters: queryParams,
      );

      // --- DEBUG PRINT: SUCCESS ---
      debugPrint('✅ [GET] Success: ${ApiConstants.customerBookings}');
      debugPrint('Response Data: ${response.data}');

      return CustomerBookingListResponseModel.fromJson(response.data);
    } catch (e) {
      // --- DEBUG PRINT: ERROR ---
      debugPrint('❌ [GET] Error at: ${ApiConstants.customerBookings}');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }
}