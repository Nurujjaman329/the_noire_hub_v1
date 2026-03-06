class ServiceDetailsResponseModel {
  final int code;
  final String message;
  final ServiceData data;

  ServiceDetailsResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ServiceDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsResponseModel(
      code: (json['code'] ?? 0).toDouble().toInt(),
      message: json['message'] ?? '',
      data: ServiceData.fromJson(json['data'] ?? {}),
    );
  }
}

class ServiceData {
  final ServiceAttributes attributes;

  ServiceData({required this.attributes});

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      attributes: ServiceAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class ServiceAttributes {
  final String id;
  final String name;
  final int price;
  final int originalPrice;
  final int discountedPrice;
  final String description;
  final bool isRecurring;
  final bool isActive;
  final bool isDeleted;
  final bool isApproved;
  final bool homeService;
  final double rating; // Changed to double to match your other model and server logic
  final int totalReviews;
  final List<String> images;
  final List<String> availableDates;
  final Discount discount;
  final Location location;
  final Beautician beautician;
  final Category category;
  final Category subcategory;
  final WorkingHours workingHours;
  final List<ServiceVariant> variants;
  final String createdAt;
  final String updatedAt;

  ServiceAttributes({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.discountedPrice,
    required this.description,
    required this.isRecurring,
    required this.isActive,
    required this.isDeleted,
    required this.isApproved,
    required this.homeService,
    required this.rating,
    required this.totalReviews,
    required this.images,
    required this.availableDates,
    required this.discount,
    required this.location,
    required this.beautician,
    required this.category,
    required this.subcategory,
    required this.workingHours,
    required this.variants,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceAttributes.fromJson(Map<String, dynamic> json) {
    return ServiceAttributes(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble().toInt(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble().toInt(),
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble().toInt(),
      description: json['description'] ?? '',
      isRecurring: json['isRecurring'] ?? false,
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      isApproved: json['isApproved'] ?? false,
      homeService: json['homeService'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(), // Safe cast to double
      totalReviews: (json['totalReviews'] ?? 0).toDouble().toInt(),
      images: List<String>.from(json['images'] ?? []),
      availableDates: List<String>.from(json['availableDates'] ?? []),
      discount: Discount.fromJson(json['discount'] ?? {}),
      location: Location.fromJson(json['location'] ?? {}),
      beautician: Beautician.fromJson(json['beautician'] ?? {}),
      category: Category.fromJson(json['category'] ?? {}),
      subcategory: Category.fromJson(json['subcategory'] ?? {}),
      workingHours: WorkingHours.fromJson(json['workingHours'] ?? {}),
      variants: (json['variants'] as List?)
          ?.map((e) => ServiceVariant.fromJson(e))
          .toList() ??
          [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class Discount {
  final int value;
  final String type;
  final int? maxAmount;

  Discount({
    required this.value,
    required this.type,
    this.maxAmount,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      value: (json['value'] ?? 0).toDouble().toInt(),
      type: json['type'] ?? '',
      // Use null check because your log shows maxAmount can be null
      maxAmount: json['maxAmount'] != null
          ? (json['maxAmount'] as num).toDouble().toInt()
          : null,
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
      coordinates: (json['coordinates'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
          [],
    );
  }
}

class Beautician {
  final String id;
  final String fullName;
  final String businessName;
  final String shopImage;
  final String image;

  Beautician({
    required this.id,
    required this.fullName,
    required this.businessName,
    required this.shopImage,
    required this.image,
  });

  factory Beautician.fromJson(Map<String, dynamic> json) {
    return Beautician(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      businessName: json['businessName'] ?? '',
      shopImage: json['shopImage'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class WorkingHours {
  final String startTime;
  final String endTime;
  final String id;

  WorkingHours({
    required this.startTime,
    required this.endTime,
    required this.id,
  });

  factory WorkingHours.fromJson(Map<String, dynamic> json) {
    return WorkingHours(
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}

class ServiceVariant {
  final String id;
  final String variantName;
  final String description;
  final List<SubVariant> subVariants;

  ServiceVariant({
    required this.id,
    required this.variantName,
    required this.description,
    required this.subVariants,
  });

  factory ServiceVariant.fromJson(Map<String, dynamic> json) {
    return ServiceVariant(
      id: json['_id'] ?? '',
      variantName: json['variantName'] ?? '',
      description: json['description'] ?? '',
      subVariants: (json['subVariants'] as List?)
          ?.map((e) => SubVariant.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class SubVariant {
  final String id;
  final String name;
  final int price;

  SubVariant({
    required this.id,
    required this.name,
    required this.price,
  });

  factory SubVariant.fromJson(Map<String, dynamic> json) {
    return SubVariant(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble().toInt(),
    );
  }
}