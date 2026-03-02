
class CustomerBookingListResponseModel {
  final int code;
  final String message;
  final BookingData? data;

  CustomerBookingListResponseModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory CustomerBookingListResponseModel.fromJson(Map<String, dynamic> json) => CustomerBookingListResponseModel(
    code: json["code"] ?? 0,
    message: json["message"] ?? "",
    data: json["data"] != null ? BookingData.fromJson(json["data"]) : null,
  );
}

class BookingData {
  final BookingAttributes? attributes;

  BookingData({this.attributes});

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
    attributes: json["attributes"] != null
        ? BookingAttributes.fromJson(json["attributes"])
        : null,
  );
}

class BookingAttributes {
  final List<BookingDoc> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;

  BookingAttributes({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
  });

  factory BookingAttributes.fromJson(Map<String, dynamic> json) => BookingAttributes(
    docs: json["docs"] != null
        ? List<BookingDoc>.from(json["docs"].map((x) => BookingDoc.fromJson(x)))
        : [],
    totalDocs: json["totalDocs"] ?? 0,
    limit: json["limit"] ?? 0,
    page: json["page"] ?? 0,
    totalPages: json["totalPages"] ?? 0,
  );
}

class BookingDoc {
  final String id;
  final BookingUser? user;
  final String beautician;
  final BookingService? service;
  final List<BookingItem> bookingItems;
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

  BookingDoc({
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

  factory BookingDoc.fromJson(Map<String, dynamic> json) => BookingDoc(
    id: json["id"] ?? "",
    user: json["user"] != null ? BookingUser.fromJson(json["user"]) : null,
    beautician: json["beautician"] ?? "",
    service: json["service"] != null ? BookingService.fromJson(json["service"]) : null,
    bookingItems: json["bookingItems"] != null
        ? List<BookingItem>.from(json["bookingItems"].map((x) => BookingItem.fromJson(x)))
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

class BookingUser {
  final String id;
  BookingUser({required this.id});

  factory BookingUser.fromJson(Map<String, dynamic> json) => BookingUser(
    id: json["id"] ?? "",
  );
}

class BookingService {
  final String id;
  final String name;
  final String image;

  BookingService({
    required this.id,
    required this.name,
    required this.image,
  });

  factory BookingService.fromJson(Map<String, dynamic> json) => BookingService(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    image: json["image"] ?? "",
  );
}

class BookingItem {
  final String? variantName;
  final String? subVariantName;
  final double price;
  final String id;

  BookingItem({
    this.variantName,
    this.subVariantName,
    required this.price,
    required this.id,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) => BookingItem(
    variantName: json["variantName"],
    subVariantName: json["subVariantName"],
    price: (json["price"] ?? 0).toDouble(),
    id: json["_id"] ?? "",
  );
}