class OrderFullFillmentPostBody {
  final ShippingMethodConfig? shippingMethod;
  final DeliveryMethodConfig? deliveryMethod;
  final CostsAndFeesConfig? costsAndFees;

  OrderFullFillmentPostBody({
    this.shippingMethod,
    this.deliveryMethod,
    this.costsAndFees,
  });

  Map<String, dynamic> toJson() => {
    if (shippingMethod != null) 'shippingMethod': shippingMethod!.toJson(),
    if (deliveryMethod != null) 'deliveryMethod': deliveryMethod!.toJson(),
    if (costsAndFees != null) 'costsAndFees': costsAndFees!.toJson(),
  };
}
class ShippingMethodConfig {
  final MethodOption? turbo;
  final MethodOption? standard;
  final MethodOption? basic;

  ShippingMethodConfig({
    this.turbo,
    this.standard,
    this.basic,
  });

  Map<String, dynamic> toJson() => {
    if (turbo != null) 'turbo': turbo!.toJson(),
    if (standard != null) 'standard': standard!.toJson(),
    if (basic != null) 'basic': basic!.toJson(),
  };
}
class DeliveryMethodConfig {
  final MethodOption? turbo;
  final MethodOption? standard;
  final MethodOption? basic;
  final PickupOption? pickup;

  DeliveryMethodConfig({
    this.turbo,
    this.standard,
    this.basic,
    this.pickup,
  });

  Map<String, dynamic> toJson() => {
    if (turbo != null) 'turbo': turbo!.toJson(),
    if (standard != null) 'standard': standard!.toJson(),
    if (basic != null) 'basic': basic!.toJson(),
    if (pickup != null) 'pickup': pickup!.toJson(),
  };
}
class MethodOption {
  final bool? enabled;
  final String? deliveryTime;
  final num? price;

  MethodOption({
    this.enabled,
    this.deliveryTime,
    this.price,
  });

  Map<String, dynamic> toJson() => {
    if (enabled != null) 'enabled': enabled,
    if (deliveryTime != null) 'deliveryTime': deliveryTime,
    if (price != null) 'price': price,
  };
}
class PickupOption {
  final bool? enabled;
  final num? price;

  PickupOption({
    this.enabled,
    this.price,
  });

  Map<String, dynamic> toJson() => {
    if (enabled != null) 'enabled': enabled,
    if (price != null) 'price': price,
  };
}
class CostsAndFeesConfig {
  final FeeOption? handledByVendor;
  final FeeOption? handledByCustomer;
  final ConditionalFreeShipping? conditionalFreeShipping;

  CostsAndFeesConfig({
    this.handledByVendor,
    this.handledByCustomer,
    this.conditionalFreeShipping,
  });

  Map<String, dynamic> toJson() => {
    if (handledByVendor != null)
      'handledByVendor': handledByVendor!.toJson(),
    if (handledByCustomer != null)
      'handledByCustomer': handledByCustomer!.toJson(),
    if (conditionalFreeShipping != null)
      'conditionalFreeShipping': conditionalFreeShipping!.toJson(),
  };
}
class FeeOption {
  final bool? enabled;
  final num? amount;

  FeeOption({
    this.enabled,
    this.amount,
  });

  Map<String, dynamic> toJson() => {
    if (enabled != null) 'enabled': enabled,
    if (amount != null) 'amount': amount,
  };
}
class ConditionalFreeShipping {
  final bool? enabled;
  final num? minOrderAmount;

  ConditionalFreeShipping({
    this.enabled,
    this.minOrderAmount,
  });

  Map<String, dynamic> toJson() => {
    if (enabled != null) 'enabled': enabled,
    if (minOrderAmount != null) 'minOrderAmount': minOrderAmount,
  };
}
