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
  num distance;
  String description;
  List<String> images;
  num rating;
  int totalReviews;
  int stock;
  Weight weight;
  Discount discount;
  Location location;
  Vendor vendor;
  String category;
  String subcategory;
  List<Variant> variants;
  bool isActive;
  String createdAt;

  CustomerService({
    this.id = '',
    this.name = '',
    this.price = 0,
    this.originalPrice = 0,
    this.discountedPrice = 0,
    this.distance = 0,
    this.description = '',
    this.images = const [],
    this.rating = 0,
    this.totalReviews = 0,
    this.stock = 0,
    required this.weight,
    required this.discount,
    required this.location,
    required this.vendor,
    this.category = '',
    this.subcategory = '',
    this.variants = const [],
    this.isActive = false,
    this.createdAt = '',
  });

  factory CustomerService.fromJson(Map<String, dynamic> json) {
    return CustomerService(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      originalPrice: json['originalPrice'] ?? 0,
      discountedPrice: json['discountedPrice'] ?? 0,
      distance: json['distance'] ?? 0,
      description: json['description'] ?? '',
      images: (json['images'] as List?)?.cast<String>() ?? [],
      rating: json['rating'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      stock: json['stock'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      weight: Weight.fromJson(json['weight'] ?? {}),
      vendor: Vendor.fromJson(json['vendor'] ?? {}),
      location: Location.fromJson(json['location'] ?? {}),
      discount: _parseDiscount(json['discount']),
      variants: (json['variants'] as List?)?.map((v) => Variant.fromJson(v)).toList() ?? [],
    );
  }

  static Discount _parseDiscount(dynamic discountJson) {
    if (discountJson == null) return Discount();
    if (discountJson is Map<String, dynamic>) {
      return Discount.fromJson(discountJson);
    }
    // If it's just a number (like 0 in your JSON)
    return Discount(value: (discountJson as num).toDouble(), type: "flat");
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
        coordinates = (json['coordinates'] as List?)?.cast<double>() ?? [];
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