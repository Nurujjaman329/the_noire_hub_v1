class VendorProductsResponseModel {
  final int code;
  final String message;
  final ProductData data;

  VendorProductsResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory VendorProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return VendorProductsResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: ProductData.fromJson(json['data']?['attributes'] ?? {}),
    );
  }
}

class ProductData {
  final List<VendorProductModel> results;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  ProductData({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => VendorProductModel.fromJson(e))
          .toList(),
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
      totalResults: json['totalResults'] ?? 0,
    );
  }
}

class VendorProductModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final List<String> images;
  final double price;
  final double discount;
  final double rating;
  final int totalReviews;
  final int stock;
  final bool isApproved;
  final bool isActive;
  final DateTime? createdAt;
  final String category;
  final String subcategory;
  final Vendor vendor;
  final Location location;
  final Weight? weight;
  final List<ProductVariantModel> variants;

  VendorProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.images,
    required this.price,
    required this.discount,
    required this.rating,
    required this.totalReviews,
    required this.stock,
    required this.isApproved,
    required this.isActive,
    this.createdAt,
    required this.category,
    required this.subcategory,
    required this.vendor,
    required this.location,
    this.weight,
    required this.variants,
  });

  factory VendorProductModel.fromJson(Map<String, dynamic> json) {
    return VendorProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      stock: json['stock'] ?? 0,
      isApproved: json['isApproved'] ?? false,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      vendor: Vendor.fromJson(json['vendor'] ?? {}),
      location: Location.fromJson(json['location'] ?? {}),
      weight: json['weight'] != null ? Weight.fromJson(json['weight']) : null,
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map((e) => ProductVariantModel.fromJson(e))
          .toList(),
    );
  }
}

class ProductVariantModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final int quantity;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductVariantModel({
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

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
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

class Weight {
  final double value;
  final String unit;

  Weight({required this.value, required this.unit});

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }
}

class Vendor {
  final String id;

  Vendor({required this.id});

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(id: json['id'] ?? '');
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
