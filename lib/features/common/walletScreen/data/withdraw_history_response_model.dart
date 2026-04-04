
class WithdrawHistoryResponseModel {
  int code;
  String message;
  WithdrawalHistoryData? data;

  WithdrawHistoryResponseModel({
    this.code = 0,
    this.message = '',
    this.data,
  });

  factory WithdrawHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return WithdrawHistoryResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? WithdrawalHistoryData.fromJson(json['data'])
          : null,
    );
  }
}

class WithdrawalHistoryData {
  WithdrawalHistoryAttributes? attributes;

  WithdrawalHistoryData({this.attributes});

  factory WithdrawalHistoryData.fromJson(Map<String, dynamic> json) {
    return WithdrawalHistoryData(
      attributes: json['attributes'] != null
          ? WithdrawalHistoryAttributes.fromJson(json['attributes'])
          : null,
    );
  }
}

class WithdrawalHistoryAttributes {
  List<WithdrawalItem> results;
  int page;
  int limit;
  int totalPages;
  int totalResults;

  WithdrawalHistoryAttributes({
    this.results = const [],
    this.page = 1,
    this.limit = 10,
    this.totalPages = 0,
    this.totalResults = 0,
  });

  factory WithdrawalHistoryAttributes.fromJson(Map<String, dynamic> json) {
    return WithdrawalHistoryAttributes(
      results: (json['results'] as List?)
          ?.map((e) => WithdrawalItem.fromJson(e))
          .toList() ??
          [],
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 0,
      totalResults: json['totalResults'] ?? 0,
    );
  }
}

class WithdrawalItem {
  String user;
  num amount;
  String status;
  String bankAccountLast4;
  String createdAt;
  String id;

  WithdrawalItem({
    this.user = '',
    this.amount = 0,
    this.status = '',
    this.bankAccountLast4 = '',
    this.createdAt = '',
    this.id = '',
  });

  factory WithdrawalItem.fromJson(Map<String, dynamic> json) {
    return WithdrawalItem(
      user: json['user'] ?? '',
      amount: json['amount'] ?? 0,
      status: json['status'] ?? '',
      bankAccountLast4: json['bankAccountLast4'] ?? '',
      createdAt: json['createdAt'] ?? '',
      id: json['id'] ?? '',
    );
  }
}