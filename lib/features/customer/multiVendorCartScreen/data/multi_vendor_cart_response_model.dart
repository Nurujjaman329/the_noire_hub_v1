class MultiVendorCartResponseModel {
  final int code;
  final String message;
  final CartData? data;

  MultiVendorCartResponseModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory MultiVendorCartResponseModel.fromJson(Map<String, dynamic> json) {
    return MultiVendorCartResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? CartData.fromJson(json['data']) : null,
    );
  }
}

class CartData {
  final CartAttributes? attributes;

  CartData({this.attributes});

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      attributes: json['attributes'] != null
          ? CartAttributes.fromJson(json['attributes'])
          : null,
    );
  }
}

class CartAttributes {
  final String cartId;
  final List<CartVendor> vendors;
  final int totalItems;
  final double grandTotal;

  CartAttributes({
    required this.cartId,
    required this.vendors,
    required this.totalItems,
    required this.grandTotal,
  });

  factory CartAttributes.fromJson(Map<String, dynamic> json) {
    return CartAttributes(
      cartId: json['cartId'] ?? '',
      vendors: (json['vendors'] as List? ?? [])
          .map((v) => CartVendor.fromJson(v))
          .toList(),
      totalItems: json['totalItems'] ?? 0,
      grandTotal: (json['grandTotal'] ?? 0).toDouble(),
    );
  }
}

class CartVendor {
  final VendorInfo vendor;
  final List<CartItem> items;
  final double subtotal;
  final int itemCount;

  CartVendor({
    required this.vendor,
    required this.items,
    required this.subtotal,
    required this.itemCount,
  });

  factory CartVendor.fromJson(Map<String, dynamic> json) {
    return CartVendor(
      vendor: VendorInfo.fromJson(json['vendor'] ?? {}),
      items: (json['items'] as List? ?? [])
          .map((i) => CartItem.fromJson(i))
          .toList(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      itemCount: json['itemCount'] ?? 0,
    );
  }
}

class VendorInfo {
  final String id;
  final String fullName;
  final String businessName;
  final String image;

  VendorInfo({
    required this.id,
    required this.fullName,
    required this.businessName,
    required this.image,
  });

  factory VendorInfo.fromJson(Map<String, dynamic> json) {
    return VendorInfo(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      businessName: json['businessName'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class CartItem {
  final String cartItemId;
  final CartProduct product;
  final String? variantId;
  final String? variantColor;
  final String? variantWeight;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  CartItem({
    required this.cartItemId,
    required this.product,
    this.variantId,
    this.variantColor,
    this.variantWeight,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'] ?? '',
      product: CartProduct.fromJson(json['product'] ?? {}),
      variantId: json['variantId'],
      variantColor: json['variantColor'],
      variantWeight: json['variantWeight'],
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }
}

class CartProduct {
  final String id;
  final String name;
  final String image;
  final double originalPrice;
  final double discountedPrice;
  final int stock;

  CartProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.originalPrice,
    required this.discountedPrice,
    required this.stock,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
    );
  }
}