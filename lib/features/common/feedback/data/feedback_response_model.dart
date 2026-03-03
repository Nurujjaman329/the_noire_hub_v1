
class FeedbackResponseModel {
  final int code;
  final String message;
  final FeedbackData? data;

  FeedbackResponseModel({required this.code, required this.message, this.data});

  factory FeedbackResponseModel.fromJson(Map<String, dynamic> json) => FeedbackResponseModel(
    code: json["code"] ?? 0,
    message: json["message"] ?? '',
    data: json["data"] != null ? FeedbackData.fromJson(json["data"]) : null,
  );
}

class FeedbackData {
  final List<FeedbackItem> results;
  final int totalPages;
  final int totalResults;

  FeedbackData({
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory FeedbackData.fromJson(Map<String, dynamic> json) {
    var attr = json["attributes"];
    return FeedbackData(
      results: attr != null && attr["results"] != null
          ? List<FeedbackItem>.from(attr["results"].map((x) => FeedbackItem.fromJson(x)))
          : [],
      totalPages: attr?["totalPages"] ?? 1,
      totalResults: attr?["totalResults"] ?? 0,
    );
  }
}

class FeedbackItem {
  final String id;
  final String subject;
  final String message;
  final String status;
  final String adminNote;
  final bool isRead;
  final DateTime? createdAt;

  FeedbackItem({
    required this.id,
    required this.subject,
    required this.message,
    required this.status,
    required this.adminNote,
    required this.isRead,
    this.createdAt,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) => FeedbackItem(
    id: json["id"] ?? '',
    subject: json["subject"] ?? '',
    message: json["message"] ?? '',
    status: json["status"] ?? 'pending',
    adminNote: json["adminNote"] ?? '',
    isRead: json["isRead"] ?? false,
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
  );
}