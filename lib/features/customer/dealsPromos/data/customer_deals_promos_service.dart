import 'package:flutter/foundation.dart';
import 'package:the_noire_hub_v1/core/constants/api_constants.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import 'customer_deals_promos_response_model.dart';
import 'promo_request_bodies.dart';
import 'promo_validate_response_model.dart';

class CustomerDealsPromosService {
  final ApiClient _apiClient;
  CustomerDealsPromosService(this._apiClient);

  Future<CustomerDealsPromosResponseModel> fetchPromos({
    String? createdBy,
  }) async {
    try {
      // Backend currently allows only `createdBy` on GET /promo-codes/all.
      // `applicableFor` query is rejected (400: not allowed) — filter client-side.
      String endpoint = ApiConstants.promoCodeCustomer;
      if (createdBy != null && createdBy.isNotEmpty) {
        endpoint = "$endpoint?createdBy=$createdBy";
      }

      if (kDebugMode) {
        debugPrint("🔍 Fetching promos from: $endpoint");
      }

      final response = await _apiClient.get(endpoint);
      return CustomerDealsPromosResponseModel.fromJson(response.data);
    } catch (e) {
      debugPrint("❌ CustomerDealsPromosService fetchPromos error: $e");
      rethrow;
    }
  }

  /// Preview-only check. Does NOT burn usage.
  /// Use body field `code` (not `promoCode`).
  Future<PromoValidateResponseModel> validatePromo({
    required String code,
    required double subtotal,
    String? vendorId,
    String? beauticianId,
  }) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) {
      throw ServerException('Please enter a promo code');
    }
    if (subtotal <= 0) {
      throw ServerException('Cart or booking total is invalid for this promo');
    }
    if ((vendorId == null || vendorId.isEmpty) &&
        (beauticianId == null || beauticianId.isEmpty)) {
      throw ServerException('Missing store or beautician context for promo');
    }

    final body = PromoRequestBodies.validate(
      code: trimmed,
      subtotal: subtotal,
      vendorId: vendorId,
      beauticianId: beauticianId,
    );

    if (kDebugMode) {
      debugPrint('🔍 Validate promo: $body');
    }

    try {
      final response = await _apiClient.postJson(
        ApiConstants.promoCodeValidate,
        data: body,
      );
      return PromoValidateResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('❌ CustomerDealsPromosService validatePromo error: $e');
      rethrow;
    }
  }
}
