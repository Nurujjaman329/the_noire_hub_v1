import '../../../../../core/utils/json_parse_utils.dart';

class CategoryResponse {
  final int code;
  final String message;
  final CategoryData data;

  CategoryResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: CategoryData.fromJson(json['data'] ?? {}),
    );
  }
}
class CategoryData {
  final CategoryAttributes attributes;

  CategoryData({
    required this.attributes,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      attributes: CategoryAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}
class CategoryAttributes {
  final List<Category> results;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  CategoryAttributes({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory CategoryAttributes.fromJson(Map<String, dynamic> json) {
    return CategoryAttributes(
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => Category.fromJson(e))
          .toList(),
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 0,
      totalResults: json['totalResults'] ?? 0,
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
