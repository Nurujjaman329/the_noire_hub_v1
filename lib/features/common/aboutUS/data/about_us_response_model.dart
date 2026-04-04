class AboutUsResponseModel {
  int code;
  String message;
  AboutData? data;

  AboutUsResponseModel({
    this.code = 0,
    this.message = '',
    this.data,
  });

  factory AboutUsResponseModel.fromJson(Map<String, dynamic> json) {
    return AboutUsResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? AboutData.fromJson(json['data']) : null,
    );
  }
}

class AboutData {
  AboutAttributes? attributes;

  AboutData({this.attributes});

  factory AboutData.fromJson(Map<String, dynamic> json) {
    return AboutData(
      attributes: json['attributes'] != null
          ? AboutAttributes.fromJson(json['attributes'])
          : null,
    );
  }
}

class AboutAttributes {
  String id;
  String content;
  String createdAt;
  String updatedAt;

  AboutAttributes({
    this.id = '',
    this.content = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory AboutAttributes.fromJson(Map<String, dynamic> json) {
    return AboutAttributes(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}