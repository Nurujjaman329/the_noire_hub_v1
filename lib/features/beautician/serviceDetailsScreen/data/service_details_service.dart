import 'package:get/get.dart';
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
      debugPrint('🚀 [GET] Fetching Service Details: $serviceId');

      final response = await _apiClient.get(
        "${ApiConstants.serviceRoute}/$serviceId",
      );

      return ServiceDetailsResponseModel.fromJson(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}