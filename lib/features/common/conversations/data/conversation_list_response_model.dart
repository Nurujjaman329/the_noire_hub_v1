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
  final List<ConversationDoc> results;
  final int totalResults;
  final int limit;
  final int page;
  final int totalPages;

  ConversationAttributes({
    required this.results,
    required this.totalResults,
    required this.limit,
    required this.page,
    required this.totalPages,
  });

  factory ConversationAttributes.fromJson(Map<String, dynamic> json) =>
      ConversationAttributes(
        results: json["results"] != null
            ? List<ConversationDoc>.from(
                json["results"].map((x) => ConversationDoc.fromJson(x)))
            : [],
        totalResults: json["totalResults"] ?? 0,
        limit: json["limit"] ?? 0,
        page: json["page"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
      );
}

class ConversationDoc {
  final String id;
  final List<ConversationUser> users;
  final String type;
  final String? name;
  final String? image;
  final ConversationLastMessage? lastMessage;
  final String? contextType;
  final ConversationContext? contextId;
  final String? contextModel;
  final List<String> viewedUsers;
  final DateTime? createdAt;

  ConversationDoc({
    required this.id,
    required this.users,
    required this.type,
    this.name,
    this.image,
    this.lastMessage,
    this.contextType,
    this.contextId,
    this.contextModel,
    required this.viewedUsers,
    this.createdAt,
  });

  factory ConversationDoc.fromJson(Map<String, dynamic> json) => ConversationDoc(
        id: json["id"] ?? json["_id"] ?? "",
        users: json["users"] != null
            ? List<ConversationUser>.from(
                json["users"].map((x) => ConversationUser.fromJson(x)))
            : [],
        type: json["type"] ?? "private",
        name: json["name"],
        image: json["image"],
        lastMessage: json["lastMessage"] != null
            ? ConversationLastMessage.fromJson(json["lastMessage"])
            : null,
        contextType: json["contextType"],
        contextId: json["contextId"] != null
            ? ConversationContext.fromJson(json["contextId"])
            : null,
        contextModel: json["contextModel"],
        viewedUsers: json["viewedUsers"] != null
            ? List<String>.from(json["viewedUsers"])
            : [],
        createdAt:
            json["createdAt"] != null ? DateTime.tryParse(json["createdAt"]) : null,
      );

  bool hasUnread(String myUserId) {
    if (lastMessage == null) return false;
    return !lastMessage!.seenBy.contains(myUserId);
  }
}

class ConversationUser {
  final String id;
  final String fullName;
  final String image;
  final String role;

  ConversationUser({
    required this.id,
    required this.fullName,
    required this.image,
    required this.role,
  });

  factory ConversationUser.fromJson(Map<String, dynamic> json) => ConversationUser(
        id: json["id"] ?? json["_id"] ?? "",
        fullName: json["fullName"] ?? "",
        image: json["image"] ?? "",
        role: json["role"] ?? "",
      );
}

class ConversationLastMessage {
  final String id;
  final String text;
  final String? image;
  final String type;
  final MessageAuthor? author;
  final List<String> seenBy;
  final DateTime? createdAt;

  ConversationLastMessage({
    required this.id,
    required this.text,
    this.image,
    required this.type,
    this.author,
    required this.seenBy,
    this.createdAt,
  });

  factory ConversationLastMessage.fromJson(Map<String, dynamic> json) =>
      ConversationLastMessage(
        id: json["id"] ?? json["_id"] ?? "",
        text: json["text"] ?? "",
        image: json["image"],
        type: json["type"] ?? "text",
        author: json["author"] != null ? MessageAuthor.fromJson(json["author"]) : null,
        seenBy: json["seenBy"] != null ? List<String>.from(json["seenBy"]) : [],
        createdAt:
            json["createdAt"] != null ? DateTime.tryParse(json["createdAt"]) : null,
      );
}

class MessageAuthor {
  final String id;
  final String fullName;
  final String image;
  final String role;

  MessageAuthor({
    required this.id,
    required this.fullName,
    required this.image,
    required this.role,
  });

  factory MessageAuthor.fromJson(Map<String, dynamic> json) => MessageAuthor(
        id: json["id"] ?? json["_id"] ?? "",
        fullName: json["fullName"] ?? "",
        image: json["image"] ?? "",
        role: json["role"] ?? "",
      );
}

class ConversationContext {
  final String id;
  final String name;

  ConversationContext({required this.id, required this.name});

  factory ConversationContext.fromJson(Map<String, dynamic> json) => ConversationContext(
        id: json["id"] ?? json["_id"] ?? "",
        name: json["name"] ?? "",
      );
}
