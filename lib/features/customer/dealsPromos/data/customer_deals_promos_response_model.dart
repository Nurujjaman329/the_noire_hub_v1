class CustomerDealsPromosResponseModel {
  int code;
  String message;
  DealsPromosData? data;

  CustomerDealsPromosResponseModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory CustomerDealsPromosResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerDealsPromosResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? DealsPromosData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };
}

class DealsPromosData {
  DealsPromosAttributes? attributes;

  DealsPromosData({this.attributes});

  factory DealsPromosData.fromJson(Map<String, dynamic> json) {
    return DealsPromosData(
      attributes: json['attributes'] != null
          ? DealsPromosAttributes.fromJson(json['attributes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "attributes": attributes?.toJson(),
  };
}

class DealsPromosAttributes {
  List<CustomerPromoCodeModel> results;
  int page;
  int limit;
  int totalPages;
  int totalResults;

  DealsPromosAttributes({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory DealsPromosAttributes.fromJson(Map<String, dynamic> json) {
    return DealsPromosAttributes(
      results: json['results'] != null
          ? List<CustomerPromoCodeModel>.from(
          (json['results'] as List).map((x) => CustomerPromoCodeModel.fromJson(x)))
          : [],
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
      totalResults: json['totalResults'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "results": results.map((x) => x.toJson()).toList(),
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
    "totalResults": totalResults,
  };
}

class CustomerPromoCodeModel {
  CreatedByModel? createdBy;
  List<String> usedBy;

  String code;
  String title;
  int discountPercentage;
  String description;
  String expiryDate;
  String applicableFor;
  int minPurchaseAmount;
  int maxUsageCount;
  int currentUsageCount;
  bool isActive;
  String createdAt;
  String id;

  CustomerPromoCodeModel({
    this.createdBy,
    required this.usedBy,
    required this.code,
    required this.title,
    required this.discountPercentage,
    required this.description,
    required this.expiryDate,
    required this.applicableFor,
    required this.minPurchaseAmount,
    required this.maxUsageCount,
    required this.currentUsageCount,
    required this.isActive,
    required this.createdAt,
    required this.id,
  });

  factory CustomerPromoCodeModel.fromJson(Map<String, dynamic> json) {
    return CustomerPromoCodeModel(
      createdBy: json['createdBy'] != null
          ? CreatedByModel.fromJson(json['createdBy'])
          : null,

      usedBy: json['usedBy'] != null
          ? List<String>.from(json['usedBy'])
          : [],

      code: json['code'] ?? '',
      title: json['title'] ?? '',
      discountPercentage: json['discountPercentage'] ?? 0,
      description: json['description'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      applicableFor: json['applicableFor'] ?? '',
      minPurchaseAmount: json['minPurchaseAmount'] ?? 0,
      maxUsageCount: json['maxUsageCount'] ?? 0,
      currentUsageCount: json['currentUsageCount'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "createdBy": createdBy?.toJson(),
    "usedBy": usedBy,
    "code": code,
    "title": title,
    "discountPercentage": discountPercentage,
    "description": description,
    "expiryDate": expiryDate,
    "applicableFor": applicableFor,
    "minPurchaseAmount": minPurchaseAmount,
    "maxUsageCount": maxUsageCount,
    "currentUsageCount": currentUsageCount,
    "isActive": isActive,
    "createdAt": createdAt,
    "id": id,
  };
}

class CreatedByModel {
  String fullName;
  String businessName;
  String phoneNumber;
  String id;
  String role;

  CreatedByModel({
    required this.fullName,
    required this.businessName,
    required this.phoneNumber,
    required this.id,
    this.role = '',
  });

  factory CreatedByModel.fromJson(Map<String, dynamic> json) {
    return CreatedByModel(
      fullName: json['fullName'] ?? '',
      businessName: json['businessName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      id: json['id'] ?? json['_id'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "businessName": businessName,
    "phoneNumber": phoneNumber,
    "id": id,
    "role": role,
  };
}