
class DealsPromosResponseModel{
  final int code;
  final String message;
  final PromoData data;

  DealsPromosResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory DealsPromosResponseModel.fromJson(Map<String, dynamic> json) {
    return DealsPromosResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: PromoData.fromJson(json['data'] ?? {}),
    );
  }
}

class PromoData {
  final PromoAttributes attributes;

  PromoData({
    required this.attributes,
  });

  factory PromoData.fromJson(Map<String, dynamic> json) {
    return PromoData(
      attributes: PromoAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}
class PromoAttributes {
  final List<PromoCodeModel> results;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  PromoAttributes({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory PromoAttributes.fromJson(Map<String, dynamic> json) {
    return PromoAttributes(
      results: (json['results'] as List?)
          ?.map((e) => PromoCodeModel.fromJson(e))
          .toList() ??
          [],
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalResults: json['totalResults'] ?? 0,
    );
  }
}
class PromoCodeModel {
  final String id;
  final String createdBy;
  final String code;
  final String title;
  final int discountPercentage;
  final String description;
  final String expiryDate;
  final int minPurchaseAmount;
  final int maxUsageCount;
  final int currentUsageCount;
  final bool isActive;
  final String createdAt;

  PromoCodeModel({
    required this.id,
    required this.createdBy,
    required this.code,
    required this.title,
    required this.discountPercentage,
    required this.description,
    required this.expiryDate,
    required this.minPurchaseAmount,
    required this.maxUsageCount,
    required this.currentUsageCount,
    required this.isActive,
    required this.createdAt,
  });

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    return PromoCodeModel(
      id: json['id'] ?? '',
      createdBy: json['createdBy'] ?? '',
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      discountPercentage: json['discountPercentage'] ?? 0,
      description: json['description'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      minPurchaseAmount: json['minPurchaseAmount'] ?? 0,
      maxUsageCount: json['maxUsageCount'] ?? 0,
      currentUsageCount: json['currentUsageCount'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
    );
  }
}
