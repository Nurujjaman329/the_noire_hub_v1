class CreateBookingResponseModel {
  final int? code;
  final String? message;
  final CreateBookingData? data;

  CreateBookingResponseModel({
    this.code,
    this.message,
    this.data,
  });

  factory CreateBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateBookingResponseModel(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? CreateBookingData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CreateBookingData {
  final CreateBookingAttributes? attributes;

  CreateBookingData({this.attributes});

  factory CreateBookingData.fromJson(Map<String, dynamic> json) {
    return CreateBookingData(
      attributes: json['attributes'] != null
          ? CreateBookingAttributes.fromJson(
              json['attributes'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class CreateBookingAttributes {
  final CreatedBooking? booking;
  final String? checkoutUrl;
  final String? sessionId;
  final BookingPriceBreakdown? priceBreakdown;

  CreateBookingAttributes({
    this.booking,
    this.checkoutUrl,
    this.sessionId,
    this.priceBreakdown,
  });

  factory CreateBookingAttributes.fromJson(Map<String, dynamic> json) {
    return CreateBookingAttributes(
      booking: json['booking'] != null
          ? CreatedBooking.fromJson(json['booking'] as Map<String, dynamic>)
          : null,
      checkoutUrl: json['checkoutUrl'] as String?,
      sessionId: json['sessionId'] as String?,
      priceBreakdown: json['priceBreakdown'] != null
          ? BookingPriceBreakdown.fromJson(
              json['priceBreakdown'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class CreatedBooking {
  final String? id;
  final String? user;
  final String? beautician;
  final String? service;
  final List<CreatedBookingItem> bookingItems;
  final String? appointmentDate;
  final String? appointmentTime;
  final double serviceBasePrice;
  final double variantsTotal;
  final double serviceDiscount;
  final double subtotal;
  final double serviceFee;
  final double tax;
  final double tip;
  final String? promoCode;
  final double promoDiscount;
  final double totalAmount;
  final double adminCommission;
  final double beauticianAmount;
  final String? paymentStatus;
  final String? status;
  final String? stripeSessionId;

  CreatedBooking({
    this.id,
    this.user,
    this.beautician,
    this.service,
    this.bookingItems = const [],
    this.appointmentDate,
    this.appointmentTime,
    this.serviceBasePrice = 0,
    this.variantsTotal = 0,
    this.serviceDiscount = 0,
    this.subtotal = 0,
    this.serviceFee = 0,
    this.tax = 0,
    this.tip = 0,
    this.promoCode,
    this.promoDiscount = 0,
    this.totalAmount = 0,
    this.adminCommission = 0,
    this.beauticianAmount = 0,
    this.paymentStatus,
    this.status,
    this.stripeSessionId,
  });

  factory CreatedBooking.fromJson(Map<String, dynamic> json) {
    return CreatedBooking(
      id: json['id']?.toString(),
      user: json['user']?.toString(),
      beautician: json['beautician']?.toString(),
      service: json['service']?.toString(),
      bookingItems: (json['bookingItems'] as List?)
              ?.map((e) => CreatedBookingItem.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          const [],
      appointmentDate: json['appointmentDate']?.toString(),
      appointmentTime: json['appointmentTime']?.toString(),
      serviceBasePrice: _toDouble(json['serviceBasePrice']),
      variantsTotal: _toDouble(json['variantsTotal']),
      serviceDiscount: _toDouble(json['serviceDiscount']),
      subtotal: _toDouble(json['subtotal']),
      serviceFee: _toDouble(json['serviceFee']),
      tax: _toDouble(json['tax']),
      tip: _toDouble(json['tip']),
      promoCode: json['promoCode']?.toString(),
      promoDiscount: _toDouble(json['promoDiscount']),
      totalAmount: _toDouble(json['totalAmount']),
      adminCommission: _toDouble(json['adminCommission']),
      beauticianAmount: _toDouble(json['beauticianAmount']),
      paymentStatus: json['paymentStatus']?.toString(),
      status: json['status']?.toString(),
      stripeSessionId: json['stripeSessionId']?.toString(),
    );
  }
}

class CreatedBookingItem {
  final String? id;
  final String? variantName;
  final String? subVariantName;
  final double price;

  CreatedBookingItem({
    this.id,
    this.variantName,
    this.subVariantName,
    this.price = 0,
  });

  factory CreatedBookingItem.fromJson(Map<String, dynamic> json) {
    return CreatedBookingItem(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      variantName: json['variantName']?.toString(),
      subVariantName: json['subVariantName']?.toString(),
      price: _toDouble(json['price']),
    );
  }
}

class BookingPriceBreakdown {
  final double serviceBasePrice;
  final double variantsTotal;
  final double serviceDiscount;
  final double subtotal;
  final double serviceFee;
  final double tax;
  final double tip;
  final String? promoCode;
  final double promoDiscount;
  final double totalAmount;

  BookingPriceBreakdown({
    this.serviceBasePrice = 0,
    this.variantsTotal = 0,
    this.serviceDiscount = 0,
    this.subtotal = 0,
    this.serviceFee = 0,
    this.tax = 0,
    this.tip = 0,
    this.promoCode,
    this.promoDiscount = 0,
    this.totalAmount = 0,
  });

  factory BookingPriceBreakdown.fromJson(Map<String, dynamic> json) {
    return BookingPriceBreakdown(
      serviceBasePrice: _toDouble(json['serviceBasePrice']),
      variantsTotal: _toDouble(json['variantsTotal']),
      serviceDiscount: _toDouble(json['serviceDiscount']),
      subtotal: _toDouble(json['subtotal']),
      serviceFee: _toDouble(json['serviceFee']),
      tax: _toDouble(json['tax']),
      tip: _toDouble(json['tip']),
      promoCode: json['promoCode']?.toString(),
      promoDiscount: _toDouble(json['promoDiscount']),
      totalAmount: _toDouble(json['totalAmount']),
    );
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
