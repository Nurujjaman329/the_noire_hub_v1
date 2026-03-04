import 'package:the_noire_hub_v1/features/beautician/serviceDetailsScreen/data/service_details_response_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';


class ServiceDetailsService {
  final ApiClient _apiClient;
  ServiceDetailsService(this._apiClient);

  Future<ServiceDetailsResponseModel> getServiceDetails(String serviceId) async {
    try {
      debugPrint('🚀 [GET] Fetching Service Details for ID: $serviceId');
      debugPrint('🔗 URL: ${ApiConstants.serviceRoute}/$serviceId');

      final response = await _apiClient.get(
        "${ApiConstants.serviceRoute}/$serviceId",
      );

      // Log the raw data to see exactly what the server returned
      // (Useful for catching "double vs int" issues)
      debugPrint('📥 RAW RESPONSE DATA: ${response.data}');

      final model = ServiceDetailsResponseModel.fromJson(response.data);

      debugPrint('✅ Successfully parsed ServiceDetailsResponseModel');
      return model;

    } on AppException catch (e) {
      debugPrint('❌ API Error in getServiceDetails: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('💥 Unexpected Error in getServiceDetails: $e');
      throw UnknownException(e.toString());
    }
  }
}