
class FavoritesResponseModel {
  final int code;
  final String message;
  final FavoriteData? data;

  FavoritesResponseModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory FavoritesResponseModel.fromJson(Map<String, dynamic> json) => FavoritesResponseModel(
    code: json["code"] ?? 0,
    message: json["message"] ?? '',
    data: json["data"] != null ? FavoriteData.fromJson(json["data"]) : null,
  );
}

class FavoriteData {
  final FavoriteAttributes? attributes;

  FavoriteData({this.attributes});

  factory FavoriteData.fromJson(Map<String, dynamic> json) => FavoriteData(
    attributes: json["attributes"] != null ? FavoriteAttributes.fromJson(json["attributes"]) : null,
  );
}

class FavoriteAttributes {
  final List<FavoriteItem> results;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  FavoriteAttributes({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory FavoriteAttributes.fromJson(Map<String, dynamic> json) => FavoriteAttributes(
    results: json["results"] != null
        ? List<FavoriteItem>.from(json["results"].map((x) => FavoriteItem.fromJson(x)))
        : [],
    page: json["page"] ?? 1,
    limit: json["limit"] ?? 10,
    totalPages: json["totalPages"] ?? 1,
    totalResults: json["totalResults"] ?? 0,
  );
}

class FavoriteItem {
  final String user;
  final ItemDetails? item;
  final String itemType;
  final DateTime? createdAt;
  final String id;

  FavoriteItem({
    required this.user,
    this.item,
    required this.itemType,
    this.createdAt,
    required this.id,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => FavoriteItem(
    user: json["user"] ?? '',
    item: json["item"] != null ? ItemDetails.fromJson(json["item"]) : null,
    itemType: json["itemType"] ?? '',
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    id: json["id"] ?? '',
  );
}

class ItemDetails {
  final Weight? weight;
  final num discount;
  final GeoLocation? location;
  final String vendor;
  final String subcategory;
  final String category;
  final String name;
  final num price;
  final List<String> images;
  final String description;
  final num rating;
  final int totalReviews;
  final int stock;
  final bool isActive;
  final bool isApproved;
  final List<dynamic> variants;
  final DateTime? createdAt;
  final String id;

  ItemDetails({
    this.weight,
    required this.discount,
    this.location,
    required this.vendor,
    required this.subcategory,
    required this.category,
    required this.name,
    required this.price,
    required this.images,
    required this.description,
    required this.rating,
    required this.totalReviews,
    required this.stock,
    required this.isActive,
    required this.isApproved,
    required this.variants,
    this.createdAt,
    required this.id,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) => ItemDetails(
    weight: json["weight"] != null ? Weight.fromJson(json["weight"]) : null,
    discount: json["discount"] ?? 0,
    location: json["location"] != null ? GeoLocation.fromJson(json["location"]) : null,
    vendor: json["vendor"] ?? '',
    subcategory: json["subcategory"] ?? '',
    category: json["category"] ?? '',
    name: json["name"] ?? 'Unknown Item',
    price: json["price"] ?? 0,
    images: json["images"] != null ? List<String>.from(json["images"].map((x) => x)) : [],
    description: json["description"] ?? '',
    rating: json["rating"] ?? 0.0,
    totalReviews: json["totalReviews"] ?? 0,
    stock: json["stock"] ?? 0,
    isActive: json["isActive"] ?? false,
    isApproved: json["isApproved"] ?? false,
    variants: json["variants"] != null ? List<dynamic>.from(json["variants"].map((x) => x)) : [],
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    id: json["id"] ?? '',
  );
}

class Weight {
  final int value;
  final String unit;

  Weight({required this.value, required this.unit});

  factory Weight.fromJson(Map<String, dynamic> json) => Weight(
    value: json["value"] ?? 0,
    unit: json["unit"] ?? '',
  );
}

class GeoLocation {
  final String type;
  final List<double> coordinates;

  GeoLocation({required this.type, required this.coordinates});

  factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
    type: json["type"] ?? 'Point',
    coordinates: json["coordinates"] != null
        ? List<double>.from(json["coordinates"].map((x) => x.toDouble()))
        : [],
  );
}