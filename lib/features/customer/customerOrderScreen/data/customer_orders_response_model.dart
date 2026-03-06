class CustomerOrdersResponseModel {
  int code;
  String message;
  OrderData? data;

  CustomerOrdersResponseModel({
    this.code = 0,
    this.message = '',
    this.data,
  });

  factory CustomerOrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerOrdersResponseModel(
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
  List<OrderDoc> docs;

  int page;
  int totalPages;
  int totalDocs;
  int limit;

  bool hasNextPage;
  bool hasPrevPage;

  int? nextPage;
  int? prevPage;

  OrderAttributes({
    this.docs = const [],
    this.page = 1,
    this.totalPages = 1,
    this.totalDocs = 0,
    this.limit = 0,
    this.hasNextPage = false,
    this.hasPrevPage = false,
    this.nextPage,
    this.prevPage,
  });

  factory OrderAttributes.fromJson(Map<String, dynamic> json) {
    return OrderAttributes(
      docs: (json['docs'] as List?)
          ?.map((e) => OrderDoc.fromJson(e))
          .toList() ??
          [],

      page: json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalDocs: json['totalDocs'] ?? 0,
      limit: json['limit'] ?? 0,

      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,

      nextPage: json['nextPage'],
      prevPage: json['prevPage'],
    );
  }
}


class OrderDoc {
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
  String? shippingTime;
  bool? isCrossBorder;

  num tip;
  String? promoCode;
  num promoDiscount;

  num subtotal;
  num adminCommission;
  num vendorAmount;
  num totalAmount;

  String paymentStatus;
  String status;

  String refundStatus;
  num refundAmount;
  num refundPercentage;

  String createdAt;

  String? stripeSessionId;
  String? stripePaymentIntentId;

  OrderDoc({
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
    this.shippingTime,
    this.isCrossBorder,
    this.tip = 0,
    this.promoCode,
    this.promoDiscount = 0,
    this.subtotal = 0,
    this.adminCommission = 0,
    this.vendorAmount = 0,
    this.totalAmount = 0,
    this.paymentStatus = '',
    this.status = '',
    this.refundStatus = '',
    this.refundAmount = 0,
    this.refundPercentage = 0,
    this.createdAt = '',
    this.stripeSessionId,
    this.stripePaymentIntentId,
  });

  factory OrderDoc.fromJson(Map<String, dynamic> json) {
    return OrderDoc(
      id: json['id'] ?? '',
      deliveryAddress: json['deliveryAddress'] != null
          ? DeliveryAddress.fromJson(json['deliveryAddress'])
          : null,
      user: json['user'] != null ? OrderUser.fromJson(json['user']) : null,
      vendor: json['vendor'] != null ? OrderVendor.fromJson(json['vendor']) : null,
      items: (json['items'] as List?)
          ?.map((e) => OrderItem.fromJson(e))
          .toList() ??
          [],
      deliveryMethod: json['deliveryMethod'] ?? '',
      deliveryPrice: json['deliveryPrice'] ?? 0,
      deliveryTime: json['deliveryTime'] ?? '',
      deliveryInstructions: json['deliveryInstructions'] ?? '',
      shippingMethod: json['shippingMethod'],
      shippingPrice: json['shippingPrice'] ?? 0,
      shippingTime: json['shippingTime'],
      isCrossBorder: json['isCrossBorder'],
      tip: json['tip'] ?? 0,
      promoCode: json['promoCode'],
      promoDiscount: json['promoDiscount'] ?? 0,
      subtotal: json['subtotal'] ?? 0,
      adminCommission: json['adminCommission'] ?? 0,
      vendorAmount: json['vendorAmount'] ?? 0,
      totalAmount: json['totalAmount'] ?? 0,
      paymentStatus: json['paymentStatus'] ?? '',
      status: json['status'] ?? '',
      refundStatus: json['refundStatus'] ?? '',
      refundAmount: json['refundAmount'] ?? 0,
      refundPercentage: json['refundPercentage'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      stripeSessionId: json['stripeSessionId'],
      stripePaymentIntentId: json['stripePaymentIntentId'],
    );
  }
}

class DeliveryAddress {
  Location? location;
  String street;
  String city;
  String state;
  String country;
  bool isDefault;

  DeliveryAddress({
    this.location,
    this.street = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.isDefault = false,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }
}

class Location {
  String type;
  List<num> coordinates;

  Location({
    this.type = '',
    this.coordinates = const [],
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List?)?.cast<num>() ?? [],
    );
  }
}

class OrderUser {
  String id;
  String fullName;
  String email;
  String image;
  String phoneNumber;

  OrderUser({
    this.id = '',
    this.fullName = '',
    this.email = '',
    this.image = '',
    this.phoneNumber = '',
  });

  factory OrderUser.fromJson(Map<String, dynamic> json) {
    return OrderUser(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}

class OrderVendor {
  String id;
  String fullName;
  String email;
  String businessName;
  String shopImage;
  String image;
  String phoneNumber;

  OrderVendor({
    this.id = '',
    this.fullName = '',
    this.email = '',
    this.businessName = '',
    this.shopImage = '',
    this.image = '',
    this.phoneNumber = '',
  });

  factory OrderVendor.fromJson(Map<String, dynamic> json) {
    return OrderVendor(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      businessName: json['businessName'] ?? '',
      shopImage: json['shopImage'] ?? '',
      image: json['image'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}

class OrderItem {
  String id;
  String product;
  String vendor;
  String productName;
  String productImage;

  VariantWeight? variantWeight;
  String? variantColor;
  String? variantId;

  num unitPrice;
  int quantity;
  num subtotal;

  OrderItem({
    this.id = '',
    this.product = '',
    this.vendor = '',
    this.productName = '',
    this.productImage = '',
    this.variantWeight,
    this.variantColor,
    this.variantId,
    this.unitPrice = 0,
    this.quantity = 0,
    this.subtotal = 0,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['_id'] ?? '',
      product: json['product'] ?? '',
      vendor: json['vendor'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'] ?? '',
      variantWeight: json['variantWeight'] != null
          ? VariantWeight.fromJson(json['variantWeight'])
          : null,
      variantColor: json['variantColor'],
      variantId: json['variantId'],
      unitPrice: json['unitPrice'] ?? 0,
      quantity: json['quantity'] ?? 0,
      subtotal: json['subtotal'] ?? 0,
    );
  }
}

class VariantWeight {
  num value;
  String unit;

  VariantWeight({
    this.value = 0,
    this.unit = '',
  });

  factory VariantWeight.fromJson(Map<String, dynamic> json) {
    return VariantWeight(
      value: json['value'] ?? 0,
      unit: json['unit'] ?? '',
    );
  }
}