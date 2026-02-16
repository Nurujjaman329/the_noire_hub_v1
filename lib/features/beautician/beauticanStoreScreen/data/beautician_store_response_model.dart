class BeauticianStoreResponseModel {
  final int code;
  final String message;
  final ServicesData data;

  BeauticianStoreResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory BeauticianStoreResponseModel.fromJson(Map<String, dynamic> json) {
    return BeauticianStoreResponseModel(
      code: (json['code'] ?? 0).toDouble().toInt(),
      message: json['message'] ?? '',
      data: ServicesData.fromJson(json['data'] ?? {}),
    );
  }
}

class ServicesData {
  final ServicesAttributes attributes;

  ServicesData({
    required this.attributes,
  });

  factory ServicesData.fromJson(Map<String, dynamic> json) {
    return ServicesData(
      attributes: ServicesAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class ServicesAttributes {
  final List<ServiceModel> results;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  ServicesAttributes({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory ServicesAttributes.fromJson(Map<String, dynamic> json) {
    return ServicesAttributes(
      results: (json['results'] as List?)
          ?.map((e) => ServiceModel.fromJson(e))
          .toList() ??
          [],
      page: (json['page'] ?? 0).toDouble().toInt(),
      limit: (json['limit'] ?? 0).toDouble().toInt(),
      totalPages: (json['totalPages'] ?? 0).toDouble().toInt(),
      totalResults: (json['totalResults'] ?? 0).toDouble().toInt(),
    );
  }
}

class ServiceModel {
  final String id;
  final String name;
  final String description;
  final int price;
  final int originalPrice;
  final int discountedPrice;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final bool isDeleted;
  final bool isApproved;
  final bool homeService;
  final bool isRecurring;
  final String category;
  final String subcategory;
  final String createdAt;
  final String updatedAt;

  final DiscountModel discount;
  final LocationModel location;
  final WorkingHoursModel workingHours;
  final List<String> images;
  final List<String> availableDates;
  final List<VariantModel> variants;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.discountedPrice,
    required this.rating,
    required this.totalReviews,
    required this.isActive,
    required this.isDeleted,
    required this.isApproved,
    required this.homeService,
    required this.isRecurring,
    required this.category,
    required this.subcategory,
    required this.createdAt,
    required this.updatedAt,
    required this.discount,
    required this.location,
    required this.workingHours,
    required this.images,
    required this.availableDates,
    required this.variants,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble().toInt(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble().toInt(),
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble().toInt(),
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: (json['totalReviews'] ?? 0).toDouble().toInt(),
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      isApproved: json['isApproved'] ?? false,
      homeService: json['homeService'] ?? false,
      isRecurring: json['isRecurring'] ?? false,
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      discount: DiscountModel.fromJson(json['discount'] ?? {}),
      location: LocationModel.fromJson(json['location'] ?? {}),
      workingHours: WorkingHoursModel.fromJson(json['workingHours'] ?? {}),
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      availableDates: (json['availableDates'] as List?)?.map((e) => e.toString()).toList() ?? [],
      variants: (json['variants'] as List?)?.map((e) => VariantModel.fromJson(e)).toList() ?? [],
    );
  }
}

class DiscountModel {
  final int value;
  final String type;
  final int maxAmount;

  DiscountModel({
    required this.value,
    required this.type,
    required this.maxAmount,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      value: (json['value'] ?? 0).toDouble().toInt(),
      type: json['type'] ?? '',
      maxAmount: (json['maxAmount'] ?? 0).toDouble().toInt(),
    );
  }
}

class LocationModel {
  final String type;
  final double longitude;
  final double latitude;

  LocationModel({
    required this.type,
    required this.longitude,
    required this.latitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'] as List? ?? [];

    return LocationModel(
      type: json['type'] ?? '',
      longitude: coordinates.isNotEmpty ? (coordinates[0] ?? 0).toDouble() : 0.0,
      latitude: coordinates.length > 1 ? (coordinates[1] ?? 0).toDouble() : 0.0,
    );
  }
}

class WorkingHoursModel {
  final String id;
  final String startTime;
  final String endTime;

  WorkingHoursModel({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
      id: json['_id'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }
}

class VariantModel {
  final String id;
  final String variantName;
  final String description;
  final List<SubVariantModel> subVariants;

  VariantModel({
    required this.id,
    required this.variantName,
    required this.description,
    required this.subVariants,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json['_id'] ?? '',
      variantName: json['variantName'] ?? '',
      description: json['description'] ?? '',
      subVariants: (json['subVariants'] as List?)
          ?.map((e) => SubVariantModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class SubVariantModel {
  final String id;
  final String name;
  final int price;

  SubVariantModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory SubVariantModel.fromJson(Map<String, dynamic> json) {
    return SubVariantModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble().toInt(),
    );
  }
}