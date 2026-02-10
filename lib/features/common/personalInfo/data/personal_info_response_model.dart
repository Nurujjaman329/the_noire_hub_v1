

class PersonalInfoResponseModel {
  final int code;
  final String message;
  final UserProfileData data;

  PersonalInfoResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory PersonalInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return PersonalInfoResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: UserProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserProfileData {
  final UserProfileAttributes attributes;

  UserProfileData({required this.attributes});

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      attributes: UserProfileAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class UserProfileAttributes {
  final UserProfileModel user;

  UserProfileAttributes({required this.user});

  factory UserProfileAttributes.fromJson(Map<String, dynamic> json) {
    return UserProfileAttributes(
      user: UserProfileModel.fromJson(json['user'] ?? {}),
    );
  }
}




class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String businessName;
  final String shopImage;
  final String bio;
  final String image;
  final String role;
  final String phoneNumber;
  final bool isProfileCompleted;
  final bool isDocumentApprove;
  final DateTime createdAt;
  final List<UserCategory> selectedCategories;
  final List<UserAddress> addresses;

  UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.businessName,
    required this.shopImage,
    required this.bio,
    required this.image,
    required this.role,
    required this.phoneNumber,
    required this.isProfileCompleted,
    required this.isDocumentApprove,
    required this.createdAt,
    required this.selectedCategories,
    required this.addresses,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      businessName: json['businessName'] ?? '',
      shopImage: json['shopImage'] ?? '',
      bio: json['bio'] ?? '',
      image: json['image'] ?? '',
      role: json['role'] ?? '',
      phoneNumber: (json['phoneNumber'] == null ||
          json['phoneNumber'] == 0)
          ? ''
          : json['phoneNumber'].toString(),

      isProfileCompleted: json['isProfileCompleted'] ?? false,
      isDocumentApprove: json['isDocumentApprove'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      selectedCategories:
      (json['selectedCategories'] as List<dynamic>? ?? [])
          .map((e) => UserCategory.fromJson(e))
          .toList(),
      addresses: (json['addresses'] as List<dynamic>? ?? [])
          .map((e) => UserAddress.fromJson(e))
          .toList(),
    );
  }
}

class UserCategory {
  final String id;
  final CategoryModel category;
  final List<SubCategoryModel> subcategories;

  UserCategory({
    required this.id,
    required this.category,
    required this.subcategories,
  });

  factory UserCategory.fromJson(Map<String, dynamic> json) {
    return UserCategory(
      id: json['_id'] ?? '',
      category: CategoryModel.fromJson(json['category'] ?? {}),
      subcategories: (json['subcategories'] as List<dynamic>? ?? [])
          .map((e) => SubCategoryModel.fromJson(e))
          .toList(),
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String categoryType;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryType,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      categoryType: json['categoryType'] ?? '',
    );
  }
}
class SubCategoryModel {
  final String id;
  final String name;
  final String image;
  final String categoryType;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryType,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      categoryType: json['categoryType'] ?? '',
    );
  }
}


class UserAddress {
  final Location location;
  final String city;
  final String country;
  final bool isDefault;
  final String id;

  UserAddress({
    required this.location,
    required this.city,
    required this.country,
    required this.isDefault,
    required this.id,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      location: Location.fromJson(json['location'] ?? {}),
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      isDefault: json['isDefault'] ?? false,
      id: json['_id'] ?? '',
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
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}
