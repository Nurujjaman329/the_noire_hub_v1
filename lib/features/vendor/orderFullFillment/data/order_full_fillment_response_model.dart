class OrderFullFillmentResponseModel {
  final int code;
  final String message;
  final GetOrderFulfillmentData data;

  OrderFullFillmentResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory OrderFullFillmentResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderFullFillmentResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: GetOrderFulfillmentData.fromJson(json['data'] ?? {}),
    );
  }
}
class GetOrderFulfillmentData {
  final GetOrderFulfillmentAttributes attributes;

  GetOrderFulfillmentData({required this.attributes});

  factory GetOrderFulfillmentData.fromJson(Map<String, dynamic> json) {
    return GetOrderFulfillmentData(
      attributes:
      GetOrderFulfillmentAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}
class GetOrderFulfillmentAttributes {
  final String id;
  final String vendor;
  final VendorCountry vendorCountry;
  final GetShippingMethodConfig shippingMethod;
  final GetDeliveryMethodConfig deliveryMethod;
  final GetCostsAndFeesConfig costsAndFees;
  final GetRestrictedCountries restrictedCountries;
  final bool isActive;
  final DateTime createdAt;

  GetOrderFulfillmentAttributes({
    required this.id,
    required this.vendor,
    required this.vendorCountry,
    required this.shippingMethod,
    required this.deliveryMethod,
    required this.costsAndFees,
    required this.restrictedCountries,
    required this.isActive,
    required this.createdAt,
  });

  factory GetOrderFulfillmentAttributes.fromJson(Map<String, dynamic> json) {
    return GetOrderFulfillmentAttributes(
      id: json['id'] ?? '',
      vendor: json['vendor'] ?? '',
      vendorCountry: json['vendorCountry'] is Map
          ? VendorCountry.fromJson(json['vendorCountry'])
          : VendorCountry(city: '', country: json['vendorCountry'] ?? ''),
      shippingMethod:
      GetShippingMethodConfig.fromJson(json['shippingMethod'] ?? {}),
      deliveryMethod:
      GetDeliveryMethodConfig.fromJson(json['deliveryMethod'] ?? {}),
      costsAndFees:
      GetCostsAndFeesConfig.fromJson(json['costsAndFees'] ?? {}),
      restrictedCountries:
      GetRestrictedCountries.fromJson(json['restrictedCountries'] ?? {}),
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}


class VendorCountry {
  final String city;
  final String country;

  VendorCountry({
    required this.city,
    required this.country,
  });

  factory VendorCountry.fromJson(Map<String, dynamic> json) {
    return VendorCountry(
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }
}


class GetRestrictedCountries {
  final bool enabled;
  final List<String> countries;

  GetRestrictedCountries({
    required this.enabled,
    required this.countries,
  });

  factory GetRestrictedCountries.fromJson(Map<String, dynamic> json) {
    return GetRestrictedCountries(
      enabled: json['enabled'] ?? false,
      countries: json['countries'] != null
          ? List<String>.from(json['countries'])
          : [],
    );
  }
}


class GetShippingMethodConfig {
  final String id;
  final GetMethodOption turbo;
  final GetMethodOption standard;
  final GetMethodOption basic;

  GetShippingMethodConfig({
    required this.id,
    required this.turbo,
    required this.standard,
    required this.basic,
  });

  factory GetShippingMethodConfig.fromJson(Map<String, dynamic> json) {
    return GetShippingMethodConfig(
      id: json['_id'] ?? '',
      turbo: GetMethodOption.fromJson(json['turbo'] ?? {}),
      standard: GetMethodOption.fromJson(json['standard'] ?? {}),
      basic: GetMethodOption.fromJson(json['basic'] ?? {}),
    );
  }
}

class GetDeliveryMethodConfig {
  final String id;
  final GetMethodOption turbo;
  final GetMethodOption standard;
  final GetMethodOption basic;
  final GetPickupOption pickup;
  final GetMethodOption city; // ✅ ADD THIS

  GetDeliveryMethodConfig({
    required this.id,
    required this.turbo,
    required this.standard,
    required this.basic,
    required this.pickup,
    required this.city, // ✅ ADD
  });

  factory GetDeliveryMethodConfig.fromJson(Map<String, dynamic> json) {
    return GetDeliveryMethodConfig(
      id: json['_id'] ?? '',
      turbo: GetMethodOption.fromJson(json['turbo'] ?? {}),
      standard: GetMethodOption.fromJson(json['standard'] ?? {}),
      basic: GetMethodOption.fromJson(json['basic'] ?? {}),
      pickup: GetPickupOption.fromJson(json['pickup'] ?? {}),
      city: GetMethodOption.fromJson(json['city'] ?? {}), // ✅ ADD
    );
  }
}

class GetMethodOption {
  final bool enabled;
  final String deliveryTime;
  final num price;

  GetMethodOption({
    required this.enabled,
    required this.deliveryTime,
    required this.price,
  });

  factory GetMethodOption.fromJson(Map<String, dynamic> json) {
    return GetMethodOption(
      enabled: json['enabled'] ?? false,
      deliveryTime: json['deliveryTime'] ?? '',
      price: json['price'] ?? 0,
    );
  }
}
class GetPickupOption {
  final bool enabled;
  final num price;

  GetPickupOption({
    required this.enabled,
    required this.price,
  });

  factory GetPickupOption.fromJson(Map<String, dynamic> json) {
    return GetPickupOption(
      enabled: json['enabled'] ?? false,
      price: json['price'] ?? 0,
    );
  }
}
class GetCostsAndFeesConfig {
  final String id;
  final GetFeeOption handledByVendor;
  final GetFeeOption handledByCustomer;
  final GetConditionalFreeShipping conditionalFreeShipping;

  GetCostsAndFeesConfig({
    required this.id,
    required this.handledByVendor,
    required this.handledByCustomer,
    required this.conditionalFreeShipping,
  });

  factory GetCostsAndFeesConfig.fromJson(Map<String, dynamic> json) {
    return GetCostsAndFeesConfig(
      id: json['_id'] ?? '',
      handledByVendor:
      GetFeeOption.fromJson(json['handledByVendor'] ?? {}),
      handledByCustomer:
      GetFeeOption.fromJson(json['handledByCustomer'] ?? {}),
      conditionalFreeShipping: GetConditionalFreeShipping.fromJson(
          json['conditionalFreeShipping'] ?? {}),
    );
  }
}
class GetFeeOption {
  final bool enabled;
  final num amount;

  GetFeeOption({
    required this.enabled,
    required this.amount,
  });

  factory GetFeeOption.fromJson(Map<String, dynamic> json) {
    return GetFeeOption(
      enabled: json['enabled'] ?? false,
      amount: json['amount'] ?? 0,
    );
  }
}
class GetConditionalFreeShipping {
  final bool enabled;
  final num minOrderAmount;

  GetConditionalFreeShipping({
    required this.enabled,
    required this.minOrderAmount,
  });

  factory GetConditionalFreeShipping.fromJson(Map<String, dynamic> json) {
    return GetConditionalFreeShipping(
      enabled: json['enabled'] ?? false,
      minOrderAmount: json['minOrderAmount'] ?? 0,
    );
  }
}
