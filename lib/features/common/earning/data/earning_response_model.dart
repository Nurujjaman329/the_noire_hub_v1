class EarningResponseModel {
  final int code;
  final String message;
  final EarningsData data;

  EarningResponseModel({required this.code, required this.message, required this.data});

  factory EarningResponseModel.fromJson(Map<String, dynamic> json) {
    return EarningResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? EarningsData.fromJson(json['data']) : EarningsData.empty(),
    );
  }
}

class EarningsData {
  final EarningsAttributes attributes;

  EarningsData({required this.attributes});

  factory EarningsData.fromJson(Map<String, dynamic> json) {
    return EarningsData(
      attributes: json['attributes'] != null
          ? EarningsAttributes.fromJson(json['attributes'])
          : EarningsAttributes.empty(),
    );
  }

  factory EarningsData.empty() => EarningsData(attributes: EarningsAttributes.empty());
}

class EarningsAttributes {
  final Wallet wallet;
  final List<ChartData> chart;
  final List<Transaction> recentTransactions;

  EarningsAttributes({
    required this.wallet,
    required this.chart,
    required this.recentTransactions
  });

  factory EarningsAttributes.fromJson(Map<String, dynamic> json) {
    return EarningsAttributes(
      wallet: json['wallet'] != null ? Wallet.fromJson(json['wallet']) : Wallet.empty(),
      chart: (json['chart'] as List?)
          ?.map((e) => ChartData.fromJson(e))
          .toList() ?? [],
      recentTransactions: (json['recentTransactions'] as List?)
          ?.map((e) => Transaction.fromJson(e))
          .toList() ?? [],
    );
  }

  factory EarningsAttributes.empty() => EarningsAttributes(
    wallet: Wallet.empty(),
    chart: [],
    recentTransactions: [],
  );
}

class Wallet {
  final num available;
  final num pendingBalance;
  final num totalEarned;
  final num totalWithdrawn;
  final num thisMonth;

  Wallet({
    required this.available,
    required this.pendingBalance,
    required this.totalEarned,
    required this.totalWithdrawn,
    required this.thisMonth,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      available: json['available'] ?? 0,
      pendingBalance: json['pendingBalance'] ?? 0,
      totalEarned: json['totalEarned'] ?? 0,
      totalWithdrawn: json['totalWithdrawn'] ?? 0,
      thisMonth: json['thisMonth'] ?? 0,
    );
  }

  factory Wallet.empty() => Wallet(
      available: 0, pendingBalance: 0, totalEarned: 0, totalWithdrawn: 0, thisMonth: 0
  );
}

class ChartData {
  final String label;
  final String date;
  final num amount;

  ChartData({required this.label, required this.date, required this.amount});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      label: json['label'] ?? '',
      date: json['date'] ?? '',
      amount: json['amount'] ?? 0,
    );
  }
}

class Transaction {
  final String id;
  final String user;
  final String type;
  final num amount;
  final num balanceBefore;
  final num balanceAfter;
  final String status;
  final String description;
  final String stripeTransactionId;
  final String createdAt;
  final TransactionMetadata metadata;

  Transaction({
    required this.id,
    required this.user,
    required this.type,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.status,
    required this.description,
    required this.stripeTransactionId,
    required this.createdAt,
    required this.metadata,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      user: json['user'] ?? '',
      type: json['type'] ?? '',
      amount: json['amount'] ?? 0,
      balanceBefore: json['balanceBefore'] ?? 0,
      balanceAfter: json['balanceAfter'] ?? 0,
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      stripeTransactionId: json['stripeTransactionId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      metadata: json['metadata'] != null
          ? TransactionMetadata.fromJson(json['metadata'])
          : TransactionMetadata.empty(),
    );
  }
}

class TransactionMetadata {
  final String orderId;
  final String orderType;

  TransactionMetadata({required this.orderId, required this.orderType});

  factory TransactionMetadata.fromJson(Map<String, dynamic> json) {
    return TransactionMetadata(
      orderId: json['orderId'] ?? '',
      orderType: json['orderType'] ?? '',
    );
  }

  factory TransactionMetadata.empty() => TransactionMetadata(orderId: '', orderType: '');
}