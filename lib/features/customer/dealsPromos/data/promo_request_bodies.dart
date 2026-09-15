/// Pure builders for booking / promo request contracts.
/// Kept separate so unit tests can verify payloads without Dio.
class PromoRequestBodies {
  PromoRequestBodies._();

  /// POST /promo-codes/validate — field must be `code` (not promoCode).
  static Map<String, dynamic> validate({
    required String code,
    required double subtotal,
    String? vendorId,
    String? beauticianId,
  }) {
    final trimmed = code.trim();
    return {
      'code': trimmed,
      'subtotal': double.parse(subtotal.toStringAsFixed(2)),
      if (vendorId != null && vendorId.isNotEmpty) 'vendorId': vendorId,
      if (beauticianId != null && beauticianId.isNotEmpty)
        'beauticianId': beauticianId,
    };
  }

  /// POST /bookings — attach field must be `promoCode`.
  static Map<String, dynamic> booking({
    required String serviceId,
    required String appointmentDate,
    required String appointmentTime,
    List<Map<String, dynamic>> bookingItems = const [],
    double? tip,
    String? promoCode,
  }) {
    return {
      'serviceId': serviceId,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      if (bookingItems.isNotEmpty) 'bookingItems': bookingItems,
      if (tip != null && tip > 0) 'tip': tip,
      if (promoCode != null && promoCode.trim().isNotEmpty)
        'promoCode': promoCode.trim(),
    };
  }

  /// POST /product-orders — attach field must be `promoCode`.
  static Map<String, dynamic> productOrder({
    required String vendorId,
    required List<Map<String, dynamic>> items,
    required String deliveryMethod,
    required Map<String, dynamic> deliveryAddress,
    String? deliveryInstructions,
    double? tip,
    String? promoCode,
  }) {
    return {
      'vendorId': vendorId,
      'items': items,
      'deliveryMethod': deliveryMethod,
      'deliveryAddress': deliveryAddress,
      if (deliveryInstructions != null && deliveryInstructions.trim().isNotEmpty)
        'deliveryInstructions': deliveryInstructions.trim(),
      if (tip != null && tip > 0) 'tip': tip,
      if (promoCode != null && promoCode.trim().isNotEmpty)
        'promoCode': promoCode.trim(),
    };
  }
}
