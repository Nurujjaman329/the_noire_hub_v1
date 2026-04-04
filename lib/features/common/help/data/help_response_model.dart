
class HelpResponseModel {
  int code;
  String message;
  ContentData? data;

  HelpResponseModel({
    this.code = 0,
    this.message = '',
    this.data,
  });

  factory HelpResponseModel.fromJson(Map<String, dynamic> json) {
    return HelpResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? ContentData.fromJson(json['data']) : null,
    );
  }
}

class ContentData {
  ContentAttributes? attributes;

  ContentData({this.attributes});

  factory ContentData.fromJson(Map<String, dynamic> json) {
    return ContentData(
      attributes: json['attributes'] != null
          ? ContentAttributes.fromJson(json['attributes'])
          : null,
    );
  }
}

class ContentAttributes {
  String id;
  String content;
  String createdAt;
  String updatedAt;

  ContentAttributes({
    this.id = '',
    this.content = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory ContentAttributes.fromJson(Map<String, dynamic> json) {
    return ContentAttributes(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}