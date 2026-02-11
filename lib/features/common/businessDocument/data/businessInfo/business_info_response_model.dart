
class BusinessInfoResponseModel {
  final int code;
  final String message;
  final BusinessData data;

  BusinessInfoResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory BusinessInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return BusinessInfoResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: BusinessData.fromJson(json['data'] ?? {}),
    );
  }
}

class BusinessData {
  final String businessName;
  final String bio;
  final int phoneNumber;
  final BusinessAddress address;
  final List<BusinessCategory> categories;
  final double rating;
  final bool documentApproved;
  final String joinDate;
  final String annualDocumentApproveDate;
  final int totalProducts;
  final int completedOrders;
  final String mostPopularItem;
  final String leastPopularItem;

  BusinessData({
    required this.businessName,
    required this.bio,
    required this.phoneNumber,
    required this.address,
    required this.categories,
    required this.rating,
    required this.documentApproved,
    required this.joinDate,
    required this.annualDocumentApproveDate,
    required this.totalProducts,
    required this.completedOrders,
    required this.mostPopularItem,
    required this.leastPopularItem,
  });

  factory BusinessData.fromJson(Map<String, dynamic> json) {
    return BusinessData(
      businessName: json['businessName'] ?? '',
      bio: json['bio'] ?? '',
      phoneNumber: json['phoneNumber'] ?? 0,
      address: BusinessAddress.fromJson(json['address'] ?? {}),
      categories: (json['categories'] as List?)
          ?.map((e) => BusinessCategory.fromJson(e))
          .toList() ??
          [],
      rating: (json['rating'] ?? 0).toDouble(),
      documentApproved: json['documentApproved'] ?? false,
      joinDate: json['joinDate'] ?? '',
      annualDocumentApproveDate:
      json['annualDocumentApproveDate'] ?? '',
      totalProducts: json['totalProducts'] ?? 0,
      completedOrders: json['completedOrders'] ?? 0,
      mostPopularItem: json['mostPopularItem'] ?? '',
      leastPopularItem: json['leastPopularItem'] ?? '',
    );
  }
}

class BusinessAddress {
  final String city;
  final String country;
  final double longitude;
  final double latitude;

  BusinessAddress({
    required this.city,
    required this.country,
    required this.longitude,
    required this.latitude,
  });

  factory BusinessAddress.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'] as List? ?? [];

    return BusinessAddress(
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      longitude: coordinates.isNotEmpty
          ? (coordinates[0] ?? 0).toDouble()
          : 0.0,
      latitude: coordinates.length > 1
          ? (coordinates[1] ?? 0).toDouble()
          : 0.0,
    );
  }
}

class BusinessCategory {
  final String category;
  final List<String> subcategories;

  BusinessCategory({
    required this.category,
    required this.subcategories,
  });

  factory BusinessCategory.fromJson(Map<String, dynamic> json) {
    return BusinessCategory(
      category: json['category'] ?? '',
      subcategories:
      (json['subcategories'] as List?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }
}
