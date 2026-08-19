class CustomerServicesResponseModel {
  int code;
  String message;
  CustomerServiceData? data;

  CustomerServicesResponseModel({
    this.code = 0,
    this.message = '',
    this.data,
  });

  CustomerServicesResponseModel.fromJson(Map<String, dynamic> json)
      : code = json['code'] ?? 0,
        message = json['message'] ?? '',
        data = json['data'] != null ? CustomerServiceData.fromJson(json['data']) : null;
}

class CustomerServiceData {
  CustomerServiceAttributes? attributes;

  CustomerServiceData({this.attributes});

  CustomerServiceData.fromJson(Map<String, dynamic> json)
      : attributes = json['attributes'] != null
      ? CustomerServiceAttributes.fromJson(json['attributes'])
      : null;
}

class CustomerServiceAttributes {
  List<CustomerService> results;
  int page;
  int limit;
  int totalPages;
  int totalResults;

  CustomerServiceAttributes({
    this.results = const [],
    this.page = 1,
    this.limit = 10,
    this.totalPages = 0,
    this.totalResults = 0,
  });

  CustomerServiceAttributes.fromJson(Map<String, dynamic> json)
      : results = (json['results'] as List?)?.map((v) => CustomerService.fromJson(v)).toList() ?? [],
        page = json['page'] ?? 1,
        limit = json['limit'] ?? 10,
        totalPages = json['totalPages'] ?? 0,
        totalResults = json['totalResults'] ?? 0;
}

class CustomerService {
  String id;
  String name;
  num price;
  num originalPrice;
  num discountedPrice;
  String description;
  List<String> images;

  Discount discount;
  Location location;

  Beautician beautician;

  String category;
  String subcategory;

  List<String> availableDates;
  bool isRecurring;

  List<WorkingSlot> workingSlots;

  List<ServiceVariant> variants;

  num rating;
  int totalReviews;

  bool isActive;
  bool isDeleted;
  bool isApproved;
  bool homeService;
  bool isFavorite;

  String createdAt;
  String updatedAt;

  CustomerService({
    this.id = '',
    this.name = '',
    this.price = 0,
    this.originalPrice = 0,
    this.discountedPrice = 0,
    this.description = '',
    this.images = const [],
    required this.discount,
    required this.location,
    required this.beautician,
    this.category = '',
    this.subcategory = '',
    this.availableDates = const [],
    this.isRecurring = false,
    this.workingSlots = const [],
    this.variants = const [],
    this.rating = 0,
    this.totalReviews = 0,
    this.isActive = false,
    this.isDeleted = false,
    this.isApproved = false,
    this.homeService = false,
    this.isFavorite = false,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory CustomerService.fromJson(Map<String, dynamic> json) {
    return CustomerService(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      originalPrice: json['originalPrice'] ?? 0,
      discountedPrice: json['discountedPrice'] ?? 0,
      description: json['description'] ?? '',
      images: (json['images'] as List?)?.cast<String>() ?? [],
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      availableDates:
      (json['availableDates'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      isRecurring: json['isRecurring'] ?? false,
      workingSlots: (json['workingSlots'] as List?)
          ?.map((v) => WorkingSlot.fromJson(v))
          .toList() ??
          [],
      variants: (json['variants'] as List?)
          ?.map((v) => ServiceVariant.fromJson(v))
          .toList() ??
          [],
      rating: json['rating'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      isApproved: json['isApproved'] ?? false,
      homeService: json['homeService'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      discount: Discount.fromJson(json['discount'] ?? {}),
      location: Location.fromJson(json['location'] ?? {}),
      beautician: Beautician.fromJson(json['beautician'] ?? {}),
    );
  }
}

class Beautician {
  String id;

  Beautician({this.id = ''});

  factory Beautician.fromJson(Map<String, dynamic> json) {
    return Beautician(
      id: json['_id'] ?? '',
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
          ?.map((v) => SubVariant.fromJson(v))
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


class Weight {
  num value;
  String unit;

  Weight({this.value = 0, this.unit = ''});

  Weight.fromJson(Map<String, dynamic> json)
      : value = json['value'] ?? 0,
        unit = json['unit'] ?? '';
}

class Discount {
  num value;
  String type;
  num maxAmount;

  Discount({this.value = 0, this.type = '', this.maxAmount = 0});

  Discount.fromJson(Map<String, dynamic> json)
      : value = json['value'] ?? 0,
        type = json['type'] ?? '',
        maxAmount = json['maxAmount'] ?? 0;
}

class Location {
  String type;
  List<double> coordinates;

  Location({this.type = '', this.coordinates = const []});

  Location.fromJson(Map<String, dynamic> json)
      : type = json['type'] ?? '',
        coordinates = _parseCoordinates(json['coordinates']);

  static List<double> _parseCoordinates(dynamic raw) {
    if (raw is! List) return const [];

    return raw.map((entry) {
      if (entry is num) return entry.toDouble();
      if (entry is String) return double.tryParse(entry) ?? 0.0;
      return 0.0;
    }).toList();
  }
}

class Vendor {
  String id;

  Vendor({this.id = ''});

  Vendor.fromJson(Map<String, dynamic> json) : id = json['_id'] ?? '';
}

class Variant {
  String id;
  Weight weight;
  String color;
  num price;

  Variant({
    this.id = '',
    required this.weight,
    this.color = '',
    this.price = 0,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['_id'] ?? '',
      weight: Weight.fromJson(json['weight'] ?? {}),
      color: json['color'] ?? '',
      price: json['price'] ?? 0,
    );
  }
}