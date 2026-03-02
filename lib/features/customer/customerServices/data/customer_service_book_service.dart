import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'package:flutter/material.dart';

import '../../serviceBookingScreen/data/service_booking_details_response_model.dart';
import 'customer_services_response_model.dart';

class CustomerServiceBookService {
  final ApiClient _apiClient;

  CustomerServiceBookService(this._apiClient);

  Future<CustomerServicesResponseModel> getCustomerService({
    int page = 1,
    int limit = 10,
    double? latitude,
    double? longitude,
    String? name,
    String? category,
    String? subcategory,
    int? maxDistance,
    double? minRating,
    double? minPrice,
    double? maxPrice,
    bool? hasOffer,
    bool? homeService,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
    };

    if (latitude != null) queryParams['latitude'] = latitude;
    if (longitude != null) queryParams['longitude'] = longitude;
    if (name != null && name.isNotEmpty) queryParams['name'] = name;
    if (category != null && category.isNotEmpty)
      queryParams['category'] = category;
    if (subcategory != null && subcategory.isNotEmpty)
      queryParams['subcategory'] = subcategory;
    if (maxDistance != null) queryParams['maxDistance'] = maxDistance;
    if (minRating != null) queryParams['minRating'] = minRating;
    if (minPrice != null) queryParams['minPrice'] = minPrice;
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
    if (hasOffer != null) queryParams['hasOffer'] = hasOffer;
    if (homeService != null) queryParams['homeService'] = homeService;
    // --- DEBUG PRINT: REQUEST ---
    debugPrint('🚀 [GET] Request to: ${ApiConstants.customerServices}');
    debugPrint('Params: $queryParams');

    try {
      final response = await _apiClient.get(
        ApiConstants.customerServices,
        queryParameters: queryParams,
      );

      // --- DEBUG PRINT: SUCCESS ---
      debugPrint('✅ [GET] Success: ${ApiConstants.customerServices}');
      debugPrint('Response Data: ${response.data}');

      return CustomerServicesResponseModel.fromJson(response.data);
    } catch (e) {
      // --- DEBUG PRINT: ERROR ---
      debugPrint('❌ [GET] Error at: ${ApiConstants.customerServices}');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }

  Future<ServiceBookingDetailsResponseModel> getServiceDetails(
      String serviceId) async {
    debugPrint(
        '🚀 [GET] Request to: ${ApiConstants.customerServices}/$serviceId');

    try {
      final response = await _apiClient.get(
        "${ApiConstants.customerServices}/$serviceId",
      );

      debugPrint('✅ [GET] Success Details: ${response.data}');
      return ServiceBookingDetailsResponseModel.fromJson(response.data);
    } catch (e) {
      debugPrint('❌ [GET] Error at Details: $e');
      rethrow;
    }
  }


  Future<dynamic> bookService({
    required String serviceId,
    required List<Map<String, dynamic>> bookingItems,
    required String appointmentDate,
    required String appointmentTime,
  }) async {
    final Map<String, dynamic> body = {
      "serviceId": serviceId,
      "bookingItems": bookingItems,
      "appointmentDate": appointmentDate,
      "appointmentTime": appointmentTime,
    };

    debugPrint('🚀 [POST] Request to: ${ApiConstants.customerBookings}');
    debugPrint('Body: $body');

    try {
      final response = await _apiClient.postJson(
        ApiConstants.customerBookings,
        data: body,
      );

      debugPrint('✅ [POST] Success Booking: ${response.data}');
      return response.data;
    } catch (e) {
      debugPrint('❌ [POST] Error at Booking: $e');
      rethrow;
    }
  }
}