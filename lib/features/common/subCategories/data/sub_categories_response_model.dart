
class SubCategoryResponse {
  final int code;
  final String message;
  final SubCategoryData data;

  SubCategoryResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return SubCategoryResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: SubCategoryData.fromJson(json['data'] ?? {}),
    );
  }
}
class SubCategoryData {
  final SubCategoryAttributes attributes;

  SubCategoryData({required this.attributes});

  factory SubCategoryData.fromJson(Map<String, dynamic> json) {
    return SubCategoryData(
      attributes: SubCategoryAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}
class SubCategoryAttributes {
  final List<SubCategory> results;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  SubCategoryAttributes({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory SubCategoryAttributes.fromJson(Map<String, dynamic> json) {
    return SubCategoryAttributes(
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => SubCategory.fromJson(e))
          .toList(),
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalResults: json['totalResults'] ?? 0,
    );
  }
}
class SubCategory {
  final String id;
  final String name;
  final String image;
  final Category category;
  final String categoryType;
  final bool isActive;
  final User createdBy;
  final DateTime? createdAt;

  SubCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.categoryType,
    required this.isActive,
    required this.createdBy,
    this.createdAt,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
      categoryType: json['categoryType'] ?? '',
      isActive: json['isActive'] ?? false,
      createdBy: User.fromJson(json['createdBy'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
class Category {
  final String id;
  final String name;
  final String image;
  final String categoryType;
  final bool isActive;
  final String createdBy;
  final DateTime? createdAt;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryType,
    required this.isActive,
    required this.createdBy,
    this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      categoryType: json['categoryType'] ?? '',
      isActive: json['isActive'] ?? false,
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
class User {
  final String id;
  final String fullName;
  final String email;
  final String businessName;
  final String image;
  final String role;
  final bool isProfileCompleted;
  final String bio;
  final String shopImage;
  final List<Address> addresses;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.businessName,
    required this.image,
    required this.role,
    required this.isProfileCompleted,
    required this.bio,
    required this.shopImage,
    required this.addresses,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      businessName: json['businessName'] ?? '',
      image: json['image'] ?? '',
      role: json['role'] ?? '',
      isProfileCompleted: json['isProfileCompleted'] ?? false,
      bio: json['bio'] ?? '',
      shopImage: json['shopImage'] ?? '',
      addresses: (json['addresses'] as List<dynamic>? ?? [])
          .map((e) => Address.fromJson(e))
          .toList(),
    );
  }
}
class Address {
  final String id;
  final String type;
  final String street;
  final String city;
  final String state;
  final String country;
  final bool isDefault;
  final Location location;

  Address({
    required this.id,
    required this.type,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.isDefault,
    required this.location,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      isDefault: json['isDefault'] ?? false,
      location: Location.fromJson(json['location'] ?? {}),
    );
  }
}
class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List<dynamic>? ?? [])
          .map((e) => (e as num?)?.toDouble() ?? 0.0)
          .toList(),
    );
  }
}
