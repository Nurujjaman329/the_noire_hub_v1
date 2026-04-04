
import 'package:flutter/material.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'beautician_booking_history_response_model.dart';

class BeauticianBookingHistoryService {
  final ApiClient _apiClient;
  BeauticianBookingHistoryService(this._apiClient);

  Future<BeauticianBookingHistoryResponseModel> getCustomerBookings({
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

      return BeauticianBookingHistoryResponseModel.fromJson(response.data);
    } catch (e) {
      // --- DEBUG PRINT: ERROR ---
      debugPrint('❌ [GET] Error at: ${ApiConstants.customerBookings}');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }

  Future<bool> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    final String url = "${ApiConstants.customerBookings}/$bookingId/cancel";
    final Map<String, dynamic> body = {
      "cancellationReason": reason,
    };

    // --- DEBUG PRINT: REQUEST ---
    debugPrint('🚀 [PATCH] Request to: $url');
    debugPrint('Request Body: $body');

    try {
      final response = await _apiClient.postJson(
        url,
        data: body,
      );

      // --- DEBUG PRINT: SUCCESS ---
      debugPrint('✅ [CANCEL] Success Status: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // --- DEBUG PRINT: ERROR ---
      debugPrint('❌ [CANCEL] Error at: $url');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }

  Future<bool> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    final String url = "${ApiConstants.customerBookings}/$bookingId/status";
    final Map<String, dynamic> body = {
      "status": status,
    };

    // --- DEBUG PRINT: REQUEST ---
    debugPrint('🚀 [PATCH] Status Update to: $url');
    debugPrint('Request Body: $body');

    try {
      final response = await _apiClient.patch(
        url,
        data: body,
      );

      // --- DEBUG PRINT: SUCCESS ---
      debugPrint('✅ [STATUS UPDATE] Success Status: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // --- DEBUG PRINT: ERROR ---
      debugPrint('❌ [STATUS UPDATE] Error at: $url');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }
}