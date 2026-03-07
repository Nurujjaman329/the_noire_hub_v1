
class AverageReviewResponseModel {
  final int code;
  final String message;
  final EvaluationData data;

  AverageReviewResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory AverageReviewResponseModel.fromJson(Map<String, dynamic> json) => AverageReviewResponseModel(
    code: json["code"] ?? 0,
    message: json["message"] ?? "",
    data: EvaluationData.fromJson(json["data"] ?? {}),
  );
}

class EvaluationData {
  final EvaluationAttributes attributes;

  EvaluationData({required this.attributes});

  factory EvaluationData.fromJson(Map<String, dynamic> json) => EvaluationData(
    attributes: EvaluationAttributes.fromJson(json["attributes"] ?? {}),
  );
}

class EvaluationAttributes {
  final List<Evaluation> evaluations;
  final int totalReviews;
  final Map<String, int> ratingCount;
  final double averageRating;

  EvaluationAttributes({
    required this.evaluations,
    required this.totalReviews,
    required this.ratingCount,
    required this.averageRating,
  });

  factory EvaluationAttributes.fromJson(Map<String, dynamic> json) => EvaluationAttributes(
    evaluations: List<Evaluation>.from((json["evaluations"] ?? []).map((x) => Evaluation.fromJson(x))),
    totalReviews: json["totalReviews"] ?? 0,
    // Safely parse the ratingCount map
    ratingCount: Map<String, int>.from(json["ratingCount"] ?? {}),
    // Handle averageRating as double even if API sends int
    averageRating: (json["averageRating"] ?? 0).toDouble(),
  );
}

class Evaluation {
  final EvaluationUser user;
  final EvaluationItem item;
  final int rating;
  final String comment;
  final DateTime? createdAt;

  Evaluation({
    required this.user,
    required this.item,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) => Evaluation(
    user: EvaluationUser.fromJson(json["user"] ?? {}),
    item: EvaluationItem.fromJson(json["item"] ?? {}),
    rating: json["rating"] ?? 0,
    comment: json["comment"] ?? "",
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
  );
}

class EvaluationUser {
  final String fullName;
  final String image;
  final String id;

  EvaluationUser({
    required this.fullName,
    required this.image,
    required this.id,
  });

  factory EvaluationUser.fromJson(Map<String, dynamic> json) => EvaluationUser(
    fullName: json["fullName"] ?? "",
    image: json["image"] ?? "",
    id: json["id"] ?? "",
  );
}

class EvaluationItem {
  final String name;
  final List<String> images;
  final String id;

  EvaluationItem({
    required this.name,
    required this.images,
    required this.id,
  });

  factory EvaluationItem.fromJson(Map<String, dynamic> json) => EvaluationItem(
    name: json["name"] ?? "",
    images: List<String>.from(json["images"] ?? []),
    id: json["id"] ?? "",
  );
}