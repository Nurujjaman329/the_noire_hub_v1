class PromoValidateResponseModel {
  final int code;
  final String message;
  final String? status;
  final PromoValidateData? data;

  PromoValidateResponseModel({
    required this.code,
    required this.message,
    this.status,
    this.data,
  });

  factory PromoValidateResponseModel.fromJson(Map<String, dynamic> json) {
    return PromoValidateResponseModel(
      code: json['code'] ?? 0,
      message: json['message']?.toString() ?? '',
      status: json['status']?.toString(),
      data: json['data'] != null
          ? PromoValidateData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  PromoValidateAttributes? get attributes => data?.attributes;
}

class PromoValidateData {
  final PromoValidateAttributes? attributes;

  PromoValidateData({this.attributes});

  factory PromoValidateData.fromJson(Map<String, dynamic> json) {
    if (json['attributes'] != null) {
      return PromoValidateData(
        attributes: PromoValidateAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>,
        ),
      );
    }
    // Flat payload fallback (no attributes wrapper)
    if (json.containsKey('valid') ||
        json.containsKey('discountAmount') ||
        json.containsKey('code')) {
      return PromoValidateData(
        attributes: PromoValidateAttributes.fromJson(json),
      );
    }
    return PromoValidateData();
  }
}

class PromoValidateAttributes {
  final bool valid;
  final String code;
  final String? promoId;
  final double discountPercentage;
  final double discountAmount;
  final double finalSubtotal;
  final String? applicableFor;
  final double minPurchaseAmount;
  final String? reason;

  PromoValidateAttributes({
    required this.valid,
    required this.code,
    this.promoId,
    this.discountPercentage = 0,
    this.discountAmount = 0,
    this.finalSubtotal = 0,
    this.applicableFor,
    this.minPurchaseAmount = 0,
    this.reason,
  });

  factory PromoValidateAttributes.fromJson(Map<String, dynamic> json) {
    final discountAmount = _toDouble(json['discountAmount']);
    final discountPercentage = _toDouble(json['discountPercentage']);
    final code = json['code']?.toString() ?? '';
    final explicitValid = json['valid'];
    // Some backends omit `valid` on 200 — treat discount + code as success.
    final inferredValid = explicitValid == null &&
        code.isNotEmpty &&
        (discountAmount > 0 || discountPercentage > 0);

    return PromoValidateAttributes(
      valid: explicitValid == true || inferredValid,
      code: code,
      promoId: json['promoId']?.toString(),
      discountPercentage: discountPercentage,
      discountAmount: discountAmount,
      finalSubtotal: _toDouble(
        json['finalSubtotal'] ?? json['finalAmount'],
      ),
      applicableFor: json['applicableFor']?.toString(),
      minPurchaseAmount: _toDouble(json['minPurchaseAmount']),
      reason: json['reason']?.toString(),
    );
  }
}

/// UI-friendly result after a successful validate call.
class AppliedPromoResult {
  final String code;
  final double discountPercentage;
  final double discountAmount;
  final double finalSubtotal;

  const AppliedPromoResult({
    required this.code,
    required this.discountPercentage,
    required this.discountAmount,
    required this.finalSubtotal,
  });

  String get successLabel =>
      '✓ $code · −\$${discountAmount.toStringAsFixed(2)}';
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
