
import '../../../../core/utils/json_parse_utils.dart';

class SubCategoryResponse {
  final int code;
  final String message;
  final SubCategoryData data;

  SubCategoryResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return SubCategoryResponse(
      code: JsonParseUtils.asInt(json['code']),
      message: JsonParseUtils.asString(json['message']),
      data: SubCategoryData.fromJson(json['data'] ?? {}),
    );
  }
}

class SubCategoryData {
  final SubCategoryAttributes attributes;

  SubCategoryData({required this.attributes});

  factory SubCategoryData.fromJson(Map<String, dynamic> json) {
    return SubCategoryData(
      attributes: SubCategoryAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class SubCategoryAttributes {
  final List<SubCategoryItem> results;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  SubCategoryAttributes({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory SubCategoryAttributes.fromJson(Map<String, dynamic> json) {
    return SubCategoryAttributes(
      results: (json['results'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(SubCategoryItem.fromJson)
          .toList(),
      page: JsonParseUtils.asInt(json['page']),
      limit: JsonParseUtils.asInt(json['limit']),
      totalPages: JsonParseUtils.asInt(json['totalPages']),
      totalResults: JsonParseUtils.asInt(json['totalResults']),
    );
  }
}

class SubCategoryItem {
  final String id;
  final String name;
  final String image;
  final Category category;
  final String categoryType;
  final bool isActive;
  final DateTime? createdAt;

  SubCategoryItem({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.categoryType,
    required this.isActive,
    this.createdAt,
  });

  factory SubCategoryItem.fromJson(Map<String, dynamic> json) {
    return SubCategoryItem(
      id: JsonParseUtils.asId(json),
      name: JsonParseUtils.asString(json['name']),
      image: JsonParseUtils.asString(json['image']),
      category: Category.fromJson(json['category'] ?? {}),
      categoryType: JsonParseUtils.asString(json['categoryType']),
      isActive: JsonParseUtils.asBool(json['isActive']),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}

class Category {
  final String id;
  final String name;
  final String image;
  final String categoryType;
  final bool isActive;
  final String createdBy;
  final DateTime? createdAt;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryType,
    required this.isActive,
    required this.createdBy,
    this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final createdByRaw = json['createdBy'];
    return Category(
      id: JsonParseUtils.asId(json),
      name: JsonParseUtils.asString(json['name']),
      image: JsonParseUtils.asString(json['image']),
      categoryType: JsonParseUtils.asString(json['categoryType']),
      isActive: JsonParseUtils.asBool(json['isActive']),
      createdBy: createdByRaw is Map
          ? JsonParseUtils.asId(Map<String, dynamic>.from(createdByRaw))
          : JsonParseUtils.asString(createdByRaw),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
