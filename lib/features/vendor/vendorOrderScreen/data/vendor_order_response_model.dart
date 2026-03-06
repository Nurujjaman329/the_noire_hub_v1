
class VendorOrderResponseModel {
  int code;
  String message;
  OrderData? data;

  VendorOrderResponseModel({
    this.code = 0,
    this.message = '',
    this.data,
  });

  factory VendorOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return VendorOrderResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }
}

class OrderData {
  OrderAttributes? attributes;

  OrderData({this.attributes});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      attributes: json['attributes'] != null
          ? OrderAttributes.fromJson(json['attributes'])
          : null,
    );
  }
}

class OrderAttributes {
  List<VendorOrderDoc> docs;
  int totalDocs;
  int limit;
  int page;
  int totalPages;
  bool hasNextPage;
  bool hasPrevPage;

  OrderAttributes({
    this.docs = const [],
    this.totalDocs = 0,
    this.limit = 10,
    this.page = 1,
    this.totalPages = 1,
    this.hasNextPage = false,
    this.hasPrevPage = false,
  });

  factory OrderAttributes.fromJson(Map<String, dynamic> json) {
    return OrderAttributes(
      docs: (json['docs'] as List?)?.map((v) => VendorOrderDoc.fromJson(v)).toList() ?? [],
      totalDocs: json['totalDocs'] ?? 0,
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}

class VendorOrderDoc {
  String id;
  DeliveryAddress? deliveryAddress;
  OrderUser? user;
  OrderVendor? vendor;
  List<OrderItem> items;
  String deliveryMethod;
  num deliveryPrice;
  String deliveryTime;
  String deliveryInstructions;
  String? shippingMethod;
  num shippingPrice;
  num tip;
  String? promoCode;
  num promoDiscount;
  num subtotal;
  num totalAmount;
  String paymentStatus;
  String status;
  String refundStatus;
  num refundAmount;
  String createdAt;
  String? stripeSessionId;
  String? cancellationReason;
  String? cancelledAt;
  String? cancelledBy;

  VendorOrderDoc({
    this.id = '',
    this.deliveryAddress,
    this.user,
    this.vendor,
    this.items = const [],
    this.deliveryMethod = '',
    this.deliveryPrice = 0,
    this.deliveryTime = '',
    this.deliveryInstructions = '',
    this.shippingMethod,
    this.shippingPrice = 0,
    this.tip = 0,
    this.promoCode,
    this.promoDiscount = 0,
    this.subtotal = 0,
    this.totalAmount = 0,
    this.paymentStatus = '',
    this.status = '',
    this.refundStatus = '',
    this.refundAmount = 0,
    this.createdAt = '',
    this.stripeSessionId,
    this.cancellationReason,
    this.cancelledAt,
    this.cancelledBy,
  });

  factory VendorOrderDoc.fromJson(Map<String, dynamic> json) {
    return VendorOrderDoc(
      id: json['id'] ?? '',
      deliveryAddress: json['deliveryAddress'] != null ? DeliveryAddress.fromJson(json['deliveryAddress']) : null,
      user: json['user'] != null ? OrderUser.fromJson(json['user']) : null,
      vendor: json['vendor'] != null ? OrderVendor.fromJson(json['vendor']) : null,
      items: (json['items'] as List?)?.map((v) => OrderItem.fromJson(v)).toList() ?? [],
      deliveryMethod: json['deliveryMethod'] ?? '',
      deliveryPrice: json['deliveryPrice'] ?? 0,
      deliveryTime: json['deliveryTime'] ?? '',
      deliveryInstructions: json['deliveryInstructions'] ?? '',
      shippingMethod: json['shippingMethod'],
      shippingPrice: json['shippingPrice'] ?? 0,
      tip: json['tip'] ?? 0,
      promoCode: json['promoCode'],
      promoDiscount: json['promoDiscount'] ?? 0,
      subtotal: json['subtotal'] ?? 0,
      totalAmount: json['totalAmount'] ?? 0,
      paymentStatus: json['paymentStatus'] ?? '',
      status: json['status'] ?? '',
      refundStatus: json['refundStatus'] ?? '',
      refundAmount: json['refundAmount'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      stripeSessionId: json['stripeSessionId'],
      cancellationReason: json['cancellationReason'],
      cancelledAt: json['cancelledAt'],
      cancelledBy: json['cancelledBy'],
    );
  }
}

class DeliveryAddress {
  String fullName;
  String phone;
  String addressLine;
  String city;
  String country;
  String postalCode;

  DeliveryAddress({
    this.fullName = '',
    this.phone = '',
    this.addressLine = '',
    this.city = '',
    this.country = '',
    this.postalCode = '',
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      addressLine: json['addressLine'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postalCode'] ?? '',
    );
  }
}

class OrderUser {
  String id;
  String fullName;
  String email;
  String image;

  OrderUser({this.id = '', this.fullName = '', this.email = '', this.image = ''});

  factory OrderUser.fromJson(Map<String, dynamic> json) {
    return OrderUser(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class OrderVendor {
  String id;
  String fullName;
  String businessName;
  String shopImage;
  String image;

  OrderVendor({
    this.id = '',
    this.fullName = '',
    this.businessName = '',
    this.shopImage = '',
    this.image = '',
  });

  factory OrderVendor.fromJson(Map<String, dynamic> json) {
    return OrderVendor(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      businessName: json['businessName'] ?? '',
      shopImage: json['shopImage'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class OrderItem {
  String id;
  String product;
  String productName;
  String productImage;
  num unitPrice;
  int quantity;
  num subtotal;
  String? variantWeight;
  String? variantColor;

  OrderItem({
    this.id = '',
    this.product = '',
    this.productName = '',
    this.productImage = '',
    this.unitPrice = 0,
    this.quantity = 0,
    this.subtotal = 0,
    this.variantWeight,
    this.variantColor,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['_id'] ?? '',
      product: json['product'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'] ?? '',
      unitPrice: json['unitPrice'] ?? 0,
      quantity: json['quantity'] ?? 0,
      subtotal: json['subtotal'] ?? 0,
      variantWeight: json['variantWeight'],
      variantColor: json['variantColor'],
    );
  }
}