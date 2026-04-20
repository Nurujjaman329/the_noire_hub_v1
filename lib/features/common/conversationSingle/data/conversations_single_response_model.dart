class ConversationsSingleResponseModel {
  final int code;
  final String message;
  final SingleConversationData data;

  ConversationsSingleResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ConversationsSingleResponseModel.fromJson(Map<String, dynamic> json) {
    return ConversationsSingleResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? "",
      data: SingleConversationData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class SingleConversationData {
  final ConversationAttributes attributes;

  SingleConversationData({required this.attributes});

  factory SingleConversationData.fromJson(Map<String, dynamic> json) {
    return SingleConversationData(
      attributes: ConversationAttributes.fromJson(json['attributes'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attributes': attributes.toJson(),
    };
  }
}

class ConversationAttributes {
  final Conversation conversation;
  final MessagePagination messages;

  ConversationAttributes({
    required this.conversation,
    required this.messages,
  });

  factory ConversationAttributes.fromJson(Map<String, dynamic> json) {
    return ConversationAttributes(
      conversation: Conversation.fromJson(json['conversation'] ?? {}),
      messages: MessagePagination.fromJson(json['messages'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation': conversation.toJson(),
      'messages': messages.toJson(),
    };
  }
}

class Conversation {
  final List<User> users;
  final String type;
  final String name;
  final String image;
  final String lastMessage;
  final String contextType;
  final ContextId contextId;
  final String contextModel;
  final List<String> viewedUsers;
  final String blockedBy;
  final String createdAt;
  final String id;

  Conversation({
    required this.users,
    required this.type,
    required this.name,
    required this.image,
    required this.lastMessage,
    required this.contextType,
    required this.contextId,
    required this.contextModel,
    required this.viewedUsers,
    required this.blockedBy,
    required this.createdAt,
    required this.id,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      users: (json['users'] as List? ?? [])
          .map((e) => User.fromJson(e ?? {}))
          .toList(),
      type: json['type'] ?? "",
      name: json['name'] ?? "",
      image: json['image'] ?? "",
      lastMessage: json['lastMessage'] ?? "",
      contextType: json['contextType'] ?? "",
      contextId: ContextId.fromJson(json['contextId'] ?? {}),
      contextModel: json['contextModel'] ?? "",
      viewedUsers: (json['viewedUsers'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      blockedBy: json['blockedBy'] ?? "",
      createdAt: json['createdAt'] ?? "",
      id: json['id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users.map((e) => e.toJson()).toList(),
      'type': type,
      'name': name,
      'image': image,
      'lastMessage': lastMessage,
      'contextType': contextType,
      'contextId': contextId.toJson(),
      'contextModel': contextModel,
      'viewedUsers': viewedUsers,
      'blockedBy': blockedBy,
      'createdAt': createdAt,
      'id': id,
    };
  }
}

class MessagePagination {
  final List<Message> results;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  MessagePagination({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory MessagePagination.fromJson(Map<String, dynamic> json) {
    return MessagePagination(
      results: (json['results'] as List? ?? [])
          .map((e) => Message.fromJson(e ?? {}))
          .toList(),
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalResults: json['totalResults'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((e) => e.toJson()).toList(),
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
      'totalResults': totalResults,
    };
  }
}

class Message {
  final User author;
  final String text;
  final String image;
  final String type;
  final List<String> seenBy;
  final String createdAt;
  final String id;

  Message({
    required this.author,
    required this.text,
    required this.image,
    required this.type,
    required this.seenBy,
    required this.createdAt,
    required this.id,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      author: User.fromJson(json['author'] ?? {}),
      text: json['text'] ?? "",
      image: json['image'] ?? "",
      type: json['type'] ?? "",
      seenBy: (json['seenBy'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      createdAt: json['createdAt'] ?? "",
      id: json['id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author.toJson(),
      'text': text,
      'image': image,
      'type': type,
      'seenBy': seenBy,
      'createdAt': createdAt,
      'id': id,
    };
  }
}

class User {
  final String fullName;
  final String image;
  final String role;
  final String id;

  User({
    required this.fullName,
    required this.image,
    required this.role,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'] ?? "",
      image: json['image'] ?? "",
      role: json['role'] ?? "",
      id: json['id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'image': image,
      'role': role,
      'id': id,
    };
  }
}

class ContextId {
  final String name;
  final String id;

  ContextId({
    required this.name,
    required this.id,
  });

  factory ContextId.fromJson(Map<String, dynamic> json) {
    return ContextId(
      name: json['name'] ?? "",
      id: json['id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}