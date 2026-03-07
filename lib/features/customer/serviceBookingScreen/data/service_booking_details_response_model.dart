class ServiceBookingDetailsResponseModel {
  int code;
  String message;
  ServiceDetailsData? data;

  ServiceBookingDetailsResponseModel({
    this.code = 0,
    this.message = '',
    this.data,
  });

  factory ServiceBookingDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiceBookingDetailsResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? ServiceDetailsData.fromJson(json['data']) : null,
    );
  }
}

class ServiceDetailsData {
  ServiceDetailsAttributes? attributes;

  ServiceDetailsData({this.attributes});

  factory ServiceDetailsData.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsData(
      attributes: json['attributes'] != null
          ? ServiceDetailsAttributes.fromJson(json['attributes'])
          : null,
    );
  }
}

class ServiceDetailsAttributes {
  String id;
  String name;
  num price;
  num originalPrice;
  num discountedPrice;
  String description;
  List<String> images;
  List<String> availableDates;
  bool isRecurring;
  bool isActive;
  bool isDeleted;
  bool isApproved;
  bool homeService;
  num rating;
  int totalReviews;
  String createdAt;
  String updatedAt;

  Discount? discount;
  Location? location;
  Beautician? beautician;
  Category? category;
  Subcategory? subcategory;

  /// UPDATED HERE
  List<WorkingSlot> workingSlots;

  List<ServiceVariant> variants;

  ServiceDetailsAttributes({
    this.id = '',
    this.name = '',
    this.price = 0,
    this.originalPrice = 0,
    this.discountedPrice = 0,
    this.description = '',
    this.images = const [],
    this.availableDates = const [],
    this.isRecurring = false,
    this.isActive = false,
    this.isDeleted = false,
    this.isApproved = false,
    this.homeService = false,
    this.rating = 0,
    this.totalReviews = 0,
    this.createdAt = '',
    this.updatedAt = '',
    this.discount,
    this.location,
    this.beautician,
    this.category,
    this.subcategory,
    this.workingSlots = const [],
    this.variants = const [],
  });

  factory ServiceDetailsAttributes.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsAttributes(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      originalPrice: json['originalPrice'] ?? 0,
      discountedPrice: json['discountedPrice'] ?? 0,
      description: json['description'] ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      availableDates: (json['availableDates'] as List?)?.map((e) => e.toString()).toList() ?? [],
      isRecurring: json['isRecurring'] ?? false,
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      isApproved: json['isApproved'] ?? false,
      homeService: json['homeService'] ?? false,
      rating: json['rating'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      discount: json['discount'] != null ? Discount.fromJson(json['discount']) : null,
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      beautician: json['beautician'] != null ? Beautician.fromJson(json['beautician']) : null,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      subcategory: json['subcategory'] != null ? Subcategory.fromJson(json['subcategory']) : null,

      /// UPDATED HERE
      workingSlots: (json['workingSlots'] as List?)
          ?.map((e) => WorkingSlot.fromJson(e))
          .toList() ??
          [],

      variants: (json['variants'] as List?)
          ?.map((e) => ServiceVariant.fromJson(e))
          .toList() ??
          [],
    );
  }
}


class WorkingSlot {
  String id;
  String startTime;
  String endTime;

  WorkingSlot({
    this.id = '',
    this.startTime = '',
    this.endTime = '',
  });

  factory WorkingSlot.fromJson(Map<String, dynamic> json) {
    return WorkingSlot(
      id: json['_id'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }
}

class ServiceVariant {
  String id;
  String variantName;
  String description;
  List<SubVariant> subVariants;

  ServiceVariant({
    this.id = '',
    this.variantName = '',
    this.description = '',
    this.subVariants = const [],
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
  String id;
  String name;
  num price;

  SubVariant({
    this.id = '',
    this.name = '',
    this.price = 0,
  });

  factory SubVariant.fromJson(Map<String, dynamic> json) {
    return SubVariant(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
    );
  }
}

class Beautician {
  String id;
  String fullName;
  String businessName;
  String shopImage;
  String image;

  Beautician({
    this.id = '',
    this.fullName = '',
    this.businessName = '',
    this.shopImage = '',
    this.image = '',
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
  String id;
  String name;
  Category({this.id = '', this.name = ''});
  factory Category.fromJson(Map<String, dynamic> json) => Category(id: json['_id'] ?? '', name: json['name'] ?? '');
}

class Subcategory {
  String id;
  String name;
  Subcategory({this.id = '', this.name = ''});
  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(id: json['_id'] ?? '', name: json['name'] ?? '');
}

class Location {
  String type;
  List<double> coordinates;
  Location({this.type = '', this.coordinates = const []});
  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json['type'] ?? '',
    // Use .toDouble() to handle cases where the API sends an integer
    coordinates: (json['coordinates'] as List?)?.map((e) => (e as num).toDouble()).toList() ?? [],
  );
}

class Discount {
  num? maxAmount;
  num value;
  String type;
  Discount({this.maxAmount, this.value = 0, this.type = ''});
  factory Discount.fromJson(dynamic json) {
    if (json == null) return Discount();
    if (json is num) return Discount(value: json, type: 'flat');
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