
class BeauticianBookingHistoryResponseModel {
  final int code;
  final String message;
  final BeauticianBookingData? data;

  BeauticianBookingHistoryResponseModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory BeauticianBookingHistoryResponseModel.fromJson(Map<String, dynamic> json) => BeauticianBookingHistoryResponseModel(
    code: json["code"] ?? 0,
    message: json["message"] ?? "",
    data: json["data"] != null ? BeauticianBookingData.fromJson(json["data"]) : null,
  );
}

class BeauticianBookingData {
  final BeauticianBookingAttributes? attributes;

  BeauticianBookingData({this.attributes});

  factory BeauticianBookingData.fromJson(Map<String, dynamic> json) => BeauticianBookingData(
    attributes: json["attributes"] != null
        ? BeauticianBookingAttributes.fromJson(json["attributes"])
        : null,
  );
}

class BeauticianBookingAttributes {
  final List<BeauticianBookingDoc> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;

  BeauticianBookingAttributes({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
  });

  factory BeauticianBookingAttributes.fromJson(Map<String, dynamic> json) => BeauticianBookingAttributes(
    docs: json["docs"] != null
        ? List<BeauticianBookingDoc>.from(json["docs"].map((x) => BeauticianBookingDoc.fromJson(x)))
        : [],
    totalDocs: json["totalDocs"] ?? 0,
    limit: json["limit"] ?? 0,
    page: json["page"] ?? 0,
    totalPages: json["totalPages"] ?? 0,
  );
}

class BeauticianBookingDoc {
  final String id;
  final BeauticianBookingUser? user;
  final String beautician;
  final BeauticianBookingService? service;
  final List<BeauticianBookingItem> bookingItems;
  final DateTime? appointmentDate;
  final String appointmentTime;
  final double totalAmount;
  final double adminCommission;
  final double beauticianAmount;
  final String paymentStatus;
  final String status;
  final String refundStatus;
  final double refundAmount;
  final int refundPercentage;
  final DateTime? createdAt;
  final String stripeSessionId;
  final String stripePaymentIntentId;

  BeauticianBookingDoc({
    required this.id,
    this.user,
    required this.beautician,
    this.service,
    required this.bookingItems,
    this.appointmentDate,
    required this.appointmentTime,
    required this.totalAmount,
    required this.adminCommission,
    required this.beauticianAmount,
    required this.paymentStatus,
    required this.status,
    required this.refundStatus,
    required this.refundAmount,
    required this.refundPercentage,
    this.createdAt,
    required this.stripeSessionId,
    required this.stripePaymentIntentId,
  });

  factory BeauticianBookingDoc.fromJson(Map<String, dynamic> json) => BeauticianBookingDoc(
    id: json["id"] ?? "",
    user: json["user"] != null ? BeauticianBookingUser.fromJson(json["user"]) : null,
    beautician: json["beautician"] ?? "",
    service: json["service"] != null ? BeauticianBookingService.fromJson(json["service"]) : null,
    bookingItems: json["bookingItems"] != null
        ? List<BeauticianBookingItem>.from(json["bookingItems"].map((x) => BeauticianBookingItem.fromJson(x)))
        : [],
    appointmentDate: json["appointmentDate"] != null ? DateTime.tryParse(json["appointmentDate"]) : null,
    appointmentTime: json["appointmentTime"] ?? "",
    totalAmount: (json["totalAmount"] ?? 0).toDouble(),
    adminCommission: (json["adminCommission"] ?? 0).toDouble(),
    beauticianAmount: (json["beauticianAmount"] ?? 0).toDouble(),
    paymentStatus: json["paymentStatus"] ?? "",
    status: json["status"] ?? "",
    refundStatus: json["refundStatus"] ?? "",
    refundAmount: (json["refundAmount"] ?? 0).toDouble(),
    refundPercentage: json["refundPercentage"] ?? 0,
    createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"]) : null,
    stripeSessionId: json["stripeSessionId"] ?? "",
    stripePaymentIntentId: json["stripePaymentIntentId"] ?? "",
  );
}

class BeauticianBookingUser {
  final String id;
  BeauticianBookingUser({required this.id});

  factory BeauticianBookingUser.fromJson(Map<String, dynamic> json) => BeauticianBookingUser(
    id: json["id"] ?? "",
  );
}

class BeauticianBookingService {
  final String id;
  final String name;
  final String image;

  BeauticianBookingService({
    required this.id,
    required this.name,
    required this.image,
  });

  factory BeauticianBookingService.fromJson(Map<String, dynamic> json) => BeauticianBookingService(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    image: json["image"] ?? "",
  );
}

class BeauticianBookingItem {
  final String? variantName;
  final String? subVariantName;
  final double price;
  final String id;

  BeauticianBookingItem({
    this.variantName,
    this.subVariantName,
    required this.price,
    required this.id,
  });

  factory BeauticianBookingItem.fromJson(Map<String, dynamic> json) => BeauticianBookingItem(
    variantName: json["variantName"],
    subVariantName: json["subVariantName"],
    price: (json["price"] ?? 0).toDouble(),
    id: json["_id"] ?? "",
  );
}