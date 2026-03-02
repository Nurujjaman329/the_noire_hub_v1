import 'package:flutter/material.dart';

class ProductDetailsResponseModel {
  int code;
  String message;
  ProductDetailsData? data;

  ProductDetailsResponseModel({
    this.code = 0,
    this.message = '',
    this.data,
  });

  factory ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProductDetailsData.fromJson(json['data']) : null,
    );
  }
}

class ProductDetailsData {
  DetailsProductAttributes? attributes;

  ProductDetailsData({this.attributes});

  factory ProductDetailsData.fromJson(Map<String, dynamic> json) {
    return ProductDetailsData(
      attributes: json['attributes'] != null
          ? DetailsProductAttributes.fromJson(json['attributes'])
          : null,
    );
  }
}

class DetailsProductAttributes {
  String id;
  String name;
  num price;
  num originalPrice;
  num discountedPrice;
  String description;
  List<String> images;
  num rating;
  int totalReviews;
  int stock;
  bool isActive;
  bool isDeleted;
  bool isApproved;
  String createdAt;
  String updatedAt;
  Weight weight;
  Discount discount;
  Location location;
  Vendor vendor;
  Category category;
  SubCategory subcategory;
  List<DetailsVariant> variants;

  DetailsProductAttributes({
    this.id = '',
    this.name = '',
    this.price = 0,
    this.originalPrice = 0,
    this.discountedPrice = 0,
    this.description = '',
    this.images = const [],
    this.rating = 0,
    this.totalReviews = 0,
    this.stock = 0,
    this.isActive = false,
    this.isDeleted = false,
    this.isApproved = false,
    this.createdAt = '',
    this.updatedAt = '',
    required this.weight,
    required this.discount,
    required this.location,
    required this.vendor,
    required this.category,
    required this.subcategory,
    this.variants = const [],
  });

  factory DetailsProductAttributes.fromJson(Map<String, dynamic> json) {
    return DetailsProductAttributes(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      originalPrice: json['originalPrice'] ?? 0,
      discountedPrice: json['discountedPrice'] ?? 0,
      description: json['description'] ?? '',
      images: (json['images'] as List?)?.cast<String>() ?? [],
      rating: json['rating'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      stock: json['stock'] ?? 0,
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      isApproved: json['isApproved'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      weight: Weight.fromJson(json['weight'] ?? {}),
      // --- CRITICAL CHANGE: Pass dynamic 'json' to handle both int and Map ---
      discount: Discount.fromJson(json['discount']),
      location: Location.fromJson(json['location'] ?? {}),
      vendor: Vendor.fromJson(json['vendor'] ?? {}),
      category: Category.fromJson(json['category'] ?? {}),
      subcategory: SubCategory.fromJson(json['subcategory'] ?? {}),
      variants: (json['variants'] as List?)
          ?.map((v) => DetailsVariant.fromJson(v))
          .toList() ??
          [],
    );
  }
}

class Weight {
  num value;
  String unit;

  Weight({this.value = 0, this.unit = ''});

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      value: json['value'] ?? 0,
      unit: json['unit'] ?? '',
    );
  }
}

class Discount {
  num? maxAmount;
  num value;
  String type;

  Discount({this.maxAmount, this.value = 0, this.type = ''});

  // Updated factory to handle both Map and num
  factory Discount.fromJson(dynamic json) {
    if (json == null) return Discount();

    // If it's a number (Sample 1: discount: 0)
    if (json is num) {
      return Discount(value: json, type: 'flat');
    }

    // If it's a Map (Sample 2: discount: { ... })
    if (json is Map<String, dynamic>) {
      return Discount(
        maxAmount: json['maxAmount'],
        value: json['value'] ?? 0,
        type: json['type'] ?? '',
      );
    }

    return Discount();
  }
}

class Location {
  String type;
  List<double> coordinates;

  Location({this.type = '', this.coordinates = const []});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List?)?.cast<double>() ?? [],
    );
  }
}

class Vendor {
  String id;
  String fullName;
  String businessName;
  String shopImage;
  String image;

  Vendor({
    this.id = '',
    this.fullName = '',
    this.businessName = '',
    this.shopImage = '',
    this.image = '',
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      businessName: json['businessName'] ?? '',
      shopImage: json['shopImage'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class Category {
  String id;
  String name;

  Category({this.id = '', this.name = ''});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class SubCategory {
  String id;
  String name;

  SubCategory({this.id = '', this.name = ''});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class DetailsVariant {
  String id;
  Weight weight;
  String colorCode;
  num price;

  DetailsVariant({
    this.id = '',
    required this.weight,
    this.colorCode = '',
    this.price = 0,
  });

  // Helper to convert hex string "0XFF..." to Flutter Color
  Color get colorValue {
    if (colorCode.isEmpty) return Colors.transparent;
    try {
      String formattedHex = colorCode.toUpperCase().replaceAll('0X', '0xFF');
      return Color(int.parse(formattedHex));
    } catch (e) {
      return Colors.transparent;
    }
  }

  factory DetailsVariant.fromJson(Map<String, dynamic> json) {
    return DetailsVariant(
      id: json['_id'] ?? '',
      weight: Weight.fromJson(json['weight'] ?? {}),
      colorCode: json['color'] ?? '',
      price: json['price'] ?? 0,
    );
  }
}