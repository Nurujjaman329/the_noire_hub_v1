
class TermsOfServiceResponseModel {
  int code;
  String message;
  TermsData? data;

  TermsOfServiceResponseModel({
    this.code = 0,
    this.message = '',
    this.data,
  });

  factory TermsOfServiceResponseModel.fromJson(Map<String, dynamic> json) {
    return TermsOfServiceResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? TermsData.fromJson(json['data']) : null,
    );
  }
}

class TermsData {
  TermsAttributes? attributes;

  TermsData({this.attributes});

  factory TermsData.fromJson(Map<String, dynamic> json) {
    return TermsData(
      attributes: json['attributes'] != null
          ? TermsAttributes.fromJson(json['attributes'])
          : null,
    );
  }
}

class TermsAttributes {
  String id;
  String content;
  String createdAt;
  String updatedAt;

  TermsAttributes({
    this.id = '',
    this.content = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory TermsAttributes.fromJson(Map<String, dynamic> json) {
    return TermsAttributes(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}