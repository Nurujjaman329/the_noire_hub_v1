import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/api/api_client.dart';
import 'customer_deals_promos_response_model.dart';

class CustomerDealsPromosService {
  final ApiClient _apiClient;
  CustomerDealsPromosService(this._apiClient);

  static const String promoCodeEndpoint = "promo-codes";

  /// Fetch all promos optionally filtered by creator ID
  Future<CustomerDealsPromosResponseModel> fetchPromos({String? createdBy}) async {
    try {
      String endpoint = promoCodeEndpoint;
      if (createdBy != null && createdBy.isNotEmpty) {
        endpoint += "?createdBy=$createdBy";
      }

      if (kDebugMode) {
        debugPrint("🔍 Fetching promos from: $endpoint");
      }

      final response = await _apiClient.get(endpoint);

      return CustomerDealsPromosResponseModel.fromJson(response.data);
    } catch (e) {
      debugPrint("❌ DealsPromosService fetchPromos error: $e");
      rethrow;
    }
  }
}