
class InviteFriendsResponseModel {
  final bool success;
  final String message;
  final AppLinkData? data;

  InviteFriendsResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory InviteFriendsResponseModel.fromJson(Map<String, dynamic> json) {
    return InviteFriendsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AppLinkData.fromJson(json['data']) : null,
    );
  }
}

class AppLinkData {
  final String appUrl;
  final String shareMessage;

  AppLinkData({
    required this.appUrl,
    required this.shareMessage,
  });

  factory AppLinkData.fromJson(Map<String, dynamic> json) {
    return AppLinkData(
      appUrl: json['appUrl'] ?? '',
      shareMessage: json['shareMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "appUrl": appUrl,
    "shareMessage": shareMessage,
  };
}