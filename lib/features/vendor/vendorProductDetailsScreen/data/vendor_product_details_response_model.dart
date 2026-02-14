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
  final List<String> images;
  final double price;
  final double originalPrice;    // Added
  final double discountedPrice;  // Added
  final VendorProductsDetailsDiscountModel discount; // Updated type from double
  final int stock;
  final bool isApproved;
  final bool isActive;
  final DateTime? createdAt;
  final Location location;
  final Category category;
  final Subcategory subcategory;
  final Vendor vendor;
  final Ratings ratings;
  final Weight weight;
  final List<VariantModel> variants;

  ProductDetailData({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discount,
    required this.stock,
    required this.isApproved,
    required this.isActive,
    required this.createdAt,
    required this.location,
    required this.category,
    required this.subcategory,
    required this.vendor,
    required this.ratings,
    required this.weight,
    required this.variants,
  });

  factory ProductDetailData.fromJson(Map<String, dynamic> json) {
    return ProductDetailData(
      id: json['_id'] ?? '', // Updated to match API _id
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: (json['images'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(), // Mapped
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(), // Mapped
      // Using the specialized DiscountModel to handle both object and number cases
      discount: VendorProductsDetailsDiscountModel.fromJson(json['discount']),
      stock: json['stock'] ?? 0,
      isApproved: json['isApproved'] ?? false,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      location: Location.fromJson(json['location'] ?? {}),
      category: Category.fromJson(json['category'] ?? {}),
      subcategory: Subcategory.fromJson(json['subcategory'] ?? {}),
      vendor: Vendor.fromJson(json['vendor'] ?? {}),
      ratings: Ratings.fromJson(json['ratings'] ?? {}),
      weight: Weight.fromJson(json['weight'] ?? {}),
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map((e) => VariantModel.fromJson(e))
          .toList(),
    );
  }
}
class VendorProductsDetailsDiscountModel {
  final double value;
  final String type;

  VendorProductsDetailsDiscountModel({required this.value, required this.type});

  factory VendorProductsDetailsDiscountModel.fromJson(dynamic json) {
    // If it's a number (0 or 10)
    if (json is num) {
      return VendorProductsDetailsDiscountModel(value: json.toDouble(), type: 'flat');
    }
    // If it's the object {"value": 20, "type": "%"}
    else if (json is Map<String, dynamic>) {
      return VendorProductsDetailsDiscountModel(
        value: (json['value'] ?? 0).toDouble(),
        type: json['type'] ?? 'flat',
      );
    }
    // Fallback
    return VendorProductsDetailsDiscountModel(value: 0.0, type: 'flat');
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
          (json['coordinates'] as List<dynamic>? ?? []).map((e) => (e as num).toDouble())
      ),
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

class Category {
  final String id;
  final String name;
  Category({required this.id, required this.name});
  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
  );
}


class Subcategory {
  final String id;
  final String name;
  Subcategory({required this.id, required this.name});
  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
  );
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
      id: json['_id'] ?? '', // Updated to _id
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
  final Weight? weight;
  final String? color;
  final double price;

  VariantModel({
    required this.id,
    this.weight,
    this.color,
    required this.price,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json['_id'] ?? '',
      weight: json['weight'] != null ? Weight.fromJson(json['weight']) : null,
      color: json['color'],
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
