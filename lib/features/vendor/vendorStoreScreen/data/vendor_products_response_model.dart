class VendorProductsResponseModel {
  final int code;
  final String message;
  final ProductsData data;

  VendorProductsResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory VendorProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return VendorProductsResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: ProductsData.fromJson(json['data'] ?? {}),
    );
  }
}

class ProductsData {
  final ProductAttributes attributes;

  ProductsData({required this.attributes});

  factory ProductsData.fromJson(Map<String, dynamic> json) {
    return ProductsData(
      attributes: ProductAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class ProductAttributes {
  final List<Product> results;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  ProductAttributes({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory ProductAttributes.fromJson(Map<String, dynamic> json) {
    return ProductAttributes(
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => Product.fromJson(e))
          .toList(),
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
      totalResults: json['totalResults'] ?? 0,
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;    // Added
  final double discountedPrice;  // Added
  final String category;
  final String subcategory;
  final String vendor;
  final Weight weight;
  final List<String> images;
  final VendorProductsDiscountModel discount;
  final double rating;
  final int totalReviews;
  final int stock;
  final bool isActive;
  final bool isApproved;
  final List<ProductVariant> variants;
  final Location location;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,    // Added
    required this.discountedPrice,  // Added
    required this.category,
    required this.subcategory,
    required this.vendor,
    required this.weight,
    required this.images,
    required this.discount,
    required this.rating,
    required this.totalReviews,
    required this.stock,
    required this.isActive,
    required this.isApproved,
    required this.variants,
    required this.location,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      // Mapping the new fields from JSON
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      vendor: json['vendor'] ?? '',
      weight: Weight.fromJson(json['weight'] ?? {}),
      images: (json['images'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      discount: VendorProductsDiscountModel.fromJson(json['discount']),
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      stock: json['stock'] ?? 0,
      isActive: json['isActive'] ?? false,
      isApproved: json['isApproved'] ?? false,
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map((e) => ProductVariant.fromJson(e))
          .toList(),
      location: Location.fromJson(json['location'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class VendorProductsDiscountModel {
  final double value;
  final String type;

  VendorProductsDiscountModel({required this.value, required this.type});

  factory VendorProductsDiscountModel.fromJson(dynamic json) {
    // If it's a number (0 or 10)
    if (json is num) {
      return VendorProductsDiscountModel(value: json.toDouble(), type: 'flat');
    }
    // If it's the object {"value": 20, "type": "%"}
    else if (json is Map<String, dynamic>) {
      return VendorProductsDiscountModel(
        value: (json['value'] ?? 0).toDouble(),
        type: json['type'] ?? 'flat',
      );
    }
    // Fallback
    return VendorProductsDiscountModel(value: 0.0, type: 'flat');
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

class ProductVariant {
  final String id;
  final String color;
  final double price;
  final Weight weight;

  ProductVariant({
    required this.id,
    required this.color,
    required this.price,
    required this.weight,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['_id'] ?? '',
      color: json['color'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      weight: Weight.fromJson(json['weight'] ?? {}),
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
      coordinates: ((json['coordinates'] as List<dynamic>? ?? [])
          .map((e) => (e ?? 0).toDouble())
          .toList())
          .cast<double>(),
    );
  }
}
