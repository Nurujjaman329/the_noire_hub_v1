class WalletInfoResponseModel {
  int code;
  String message;
  WalletData? data;

  WalletInfoResponseModel({
    this.code = 0,
    this.message = '',
    this.data,
  });

  factory WalletInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletInfoResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? WalletData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class WalletData {
  WalletAttributes? attributes;

  WalletData({this.attributes});

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      attributes: json['attributes'] != null
          ? WalletAttributes.fromJson(json['attributes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attributes': attributes?.toJson(),
    };
  }
}

class WalletAttributes {
  String user;
  int balance;
  int pendingBalance;
  int totalEarnings;
  int totalWithdrawn;
  String stripeAccountStatus;
  String createdAt;
  String stripeAccountId;
  String id;

  WalletAttributes({
    this.user = '',
    this.balance = 0,
    this.pendingBalance = 0,
    this.totalEarnings = 0,
    this.totalWithdrawn = 0,
    this.stripeAccountStatus = '',
    this.createdAt = '',
    this.stripeAccountId = '',
    this.id = '',
  });

  factory WalletAttributes.fromJson(Map<String, dynamic> json) {
    return WalletAttributes(
      user: json['user'] ?? '',
      balance: json['balance'] ?? 0,
      pendingBalance: json['pendingBalance'] ?? 0,
      totalEarnings: json['totalEarnings'] ?? 0,
      totalWithdrawn: json['totalWithdrawn'] ?? 0,
      stripeAccountStatus: json['stripeAccountStatus'] ?? '',
      createdAt: json['createdAt'] ?? '',
      stripeAccountId: json['stripeAccountId'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'balance': balance,
      'pendingBalance': pendingBalance,
      'totalEarnings': totalEarnings,
      'totalWithdrawn': totalWithdrawn,
      'stripeAccountStatus': stripeAccountStatus,
      'createdAt': createdAt,
      'stripeAccountId': stripeAccountId,
      'id': id,
    };
  }
}