import '../../../../../core/utils/json_parse_utils.dart';

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
  final String phoneNumber;
  final String shopImage;
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
    required this.shopImage,
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
      phoneNumber: json['phoneNumber'] ?? "",
        shopImage: json['shopImage'] ?? '',
      address: BusinessAddress.fromJson(json['address'] ?? {}),
      categories: (json['categories'] as List?)
          ?.map((e) => BusinessCategory.fromJson(e))
          .toList() ??
          [],
      rating: JsonParseUtils.asDouble(json['rating']),
      documentApproved: JsonParseUtils.asBool(json['documentApproved']),
      joinDate: JsonParseUtils.asString(json['joinDate']),
      annualDocumentApproveDate:
          JsonParseUtils.asString(json['annualDocumentApproveDate']),
      totalProducts: JsonParseUtils.asInt(json['totalProducts']),
      completedOrders: JsonParseUtils.asInt(json['completedOrders']),
      mostPopularItem: JsonParseUtils.asString(json['mostPopularItem'], 'N/A'),
      leastPopularItem: JsonParseUtils.asString(json['leastPopularItem'], 'N/A'),
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
    final coordinates = JsonParseUtils.asCoordinateList(json['coordinates']);

    return BusinessAddress(
      city: JsonParseUtils.asString(json['city']),
      country: JsonParseUtils.asString(json['country']),
      longitude: coordinates.isNotEmpty ? coordinates[0] : 0.0,
      latitude: coordinates.length > 1 ? coordinates[1] : 0.0,
    );
  }
}

class BusinessCategory {
  final CategoryModel category;
  final List<SubcategoryModel> subcategories;

  BusinessCategory({
    required this.category,
    required this.subcategories,
  });

  factory BusinessCategory.fromJson(Map<String, dynamic> json) {
    return BusinessCategory(
      category: CategoryModel.fromJson(json['category'] ?? {}),
      subcategories: (json['subcategories'] as List?)
          ?.map((e) => SubcategoryModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String categoryType;
  final String image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.categoryType,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: JsonParseUtils.asId(json),
      name: JsonParseUtils.asString(json['name']),
      categoryType: JsonParseUtils.asString(json['categoryType']),
      image: JsonParseUtils.asString(json['image']),
    );
  }
}
class SubcategoryModel {
  final String id;
  final String name;
  final String categoryType;
  final String image;

  SubcategoryModel({
    required this.id,
    required this.name,
    required this.categoryType,
    required this.image,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: JsonParseUtils.asId(json),
      name: JsonParseUtils.asString(json['name']),
      categoryType: JsonParseUtils.asString(json['categoryType']),
      image: JsonParseUtils.asString(json['image']),
    );
  }
}

