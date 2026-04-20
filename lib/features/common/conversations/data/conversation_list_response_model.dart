class ConversationListResponseModel {
  final int code;
  final String message;
  final ConversationData? data;

  ConversationListResponseModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory ConversationListResponseModel.fromJson(Map<String, dynamic> json) =>
      ConversationListResponseModel(
        code: json["code"] ?? 0,
        message: json["message"] ?? "",
        data: json["data"] != null ? ConversationData.fromJson(json["data"]) : null,
      );
}

class ConversationData {
  final ConversationAttributes? attributes;

  ConversationData({this.attributes});

  factory ConversationData.fromJson(Map<String, dynamic> json) => ConversationData(
        attributes: json["attributes"] != null
            ? ConversationAttributes.fromJson(json["attributes"])
            : null,
      );
}

class ConversationAttributes {
  final List<ConversationDoc> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;

  ConversationAttributes({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
  });

  factory ConversationAttributes.fromJson(Map<String, dynamic> json) =>
      ConversationAttributes(
        docs: json["docs"] != null
            ? List<ConversationDoc>.from(
                json["docs"].map((x) => ConversationDoc.fromJson(x)))
            : [],
        totalDocs: json["totalDocs"] ?? 0,
        limit: json["limit"] ?? 0,
        page: json["page"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
      );
}

class ConversationDoc {
  final String id;
  final List<ConversationParticipant> participants;
  final LastMessage? lastMessage;
  final int unreadCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ConversationDoc({
    required this.id,
    required this.participants,
    this.lastMessage,
    required this.unreadCount,
    this.createdAt,
    this.updatedAt,
  });

  factory ConversationDoc.fromJson(Map<String, dynamic> json) => ConversationDoc(
        id: json["id"] ?? json["_id"] ?? "",
        participants: json["participants"] != null
            ? List<ConversationParticipant>.from(
                json["participants"].map((x) => ConversationParticipant.fromJson(x)))
            : [],
        lastMessage: json["lastMessage"] != null
            ? LastMessage.fromJson(json["lastMessage"])
            : null,
        unreadCount: json["unreadCount"] ?? 0,
        createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"]) : null,
        updatedAt: json["updatedAt"] != null ? DateTime.tryParse(json["updatedAt"]) : null,
      );
}

class ConversationParticipant {
  final String id;
  final String fullName;
  final String image;
  final String role;

  ConversationParticipant({
    required this.id,
    required this.fullName,
    required this.image,
    required this.role,
  });

  factory ConversationParticipant.fromJson(Map<String, dynamic> json) =>
      ConversationParticipant(
        id: json["id"] ?? json["_id"] ?? "",
        fullName: json["fullName"] ?? "",
        image: json["image"] ?? "",
        role: json["role"] ?? "",
      );
}

class LastMessage {
  final String id;
  final String content;
  final String sender;
  final bool isRead;
  final DateTime? createdAt;

  LastMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.isRead,
    this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json["id"] ?? json["_id"] ?? "",
        content: json["content"] ?? "",
        sender: json["sender"] ?? "",
        isRead: json["isRead"] ?? false,
        createdAt:
            json["createdAt"] != null ? DateTime.tryParse(json["createdAt"]) : null,
      );
}
