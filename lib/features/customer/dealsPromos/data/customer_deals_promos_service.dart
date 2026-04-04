import 'package:flutter/foundation.dart';
import 'package:the_noire_hub_v1/core/constants/api_constants.dart';

import '../../../../core/api/api_client.dart';
import 'customer_deals_promos_response_model.dart';

class CustomerDealsPromosService {
  final ApiClient _apiClient;
  CustomerDealsPromosService(this._apiClient);

  Future<CustomerDealsPromosResponseModel> fetchPromos({String? createdBy}) async {
    try {
      String endpoint = ApiConstants.promoCodeCustomer;
      // example: promo-codes/all

      if (createdBy != null && createdBy.isNotEmpty) {
        endpoint = "$endpoint?createdBy=$createdBy";
      }

      if (kDebugMode) {
        debugPrint("🔍 Fetching promos from: $endpoint");
      }

      final response = await _apiClient.get(endpoint);

      return CustomerDealsPromosResponseModel.fromJson(response.data);
    } catch (e) {
      debugPrint("❌ CustomerDealsPromosService error: $e");
      rethrow;
    }
  }
}