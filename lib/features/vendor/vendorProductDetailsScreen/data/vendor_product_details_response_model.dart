class VendorProductDetailsResponseModel {
  final int code;
  final String message;
  final ProductDetailData data;

  VendorProductDetailsResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory VendorProductDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return VendorProductDetailsResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: ProductDetailData.fromJson(json['data']?['attributes'] ?? {}),
    );
  }
}

class ProductDetailData {
  final String id;
  final String name;
  final String description;
  final String image;
  final List<String> images;
  final double price;
  final double discount;
  final int totalQuantity;
  final bool isApproved;
  final bool isActive;
  final DateTime? createdAt;
  final Location location;
  final Category category;
  final Subcategory subcategory;
  final Vendor vendor;
  final Ratings ratings;
  final List<VariantModel> variants;

  ProductDetailData({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.images,
    required this.price,
    required this.discount,
    required this.totalQuantity,
    required this.isApproved,
    required this.isActive,
    required this.createdAt,
    required this.location,
    required this.category,
    required this.subcategory,
    required this.vendor,
    required this.ratings,
    required this.variants,
  });

  factory ProductDetailData.fromJson(Map<String, dynamic> json) {
    return ProductDetailData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      totalQuantity: json['totalQuantity'] ?? 0,
      isApproved: json['isApproved'] ?? false,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      location: Location.fromJson(json['location'] ?? {}),
      category: Category.fromJson(json['category'] ?? {}),
      subcategory: Subcategory.fromJson(json['subcategory'] ?? {}),
      vendor: Vendor.fromJson(json['vendor'] ?? {}),
      ratings: Ratings.fromJson(json['ratings'] ?? {}),
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map((e) => VariantModel.fromJson(e))
          .toList(),
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: List<double>.from(
          (json['coordinates'] as List<dynamic>? ?? [])
              .map((e) => (e as num).toDouble())),
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Subcategory {
  final String id;
  final String name;

  Subcategory({required this.id, required this.name});

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Vendor {
  final String id;
  final String fullName;
  final String businessName;
  final String image;
  final String shopImage;

  Vendor({
    required this.id,
    required this.fullName,
    required this.businessName,
    required this.image,
    required this.shopImage,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      businessName: json['businessName'] ?? '',
      image: json['image'] ?? '',
      shopImage: json['shopImage'] ?? '',
    );
  }
}

class Ratings {
  final double average;
  final int count;

  Ratings({required this.average, required this.count});

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      average: (json['average'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
    );
  }
}

class VariantModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final int quantity;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VariantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.quantity,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}
