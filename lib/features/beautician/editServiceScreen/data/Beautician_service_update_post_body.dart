import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class BeauticianServiceUpdatePostBody {
  final List<File>? images;
  final String? name;
  final double? price;

  final double? discountValue;
  final String? discountType;
  final double? discountMaxAmount;
  final String? description;
  final List<ServiceVariantUpdateBody>? variants;

  BeauticianServiceUpdatePostBody({
    this.images,
    this.name,
    this.description,
    this.price,
    this.discountValue,
    this.discountType,
    this.discountMaxAmount,
    this.variants,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {};

    /// ✅ Name
    if (name != null && name!.trim().isNotEmpty) {
      map['name'] = name!.trim();
    }
    if (description != null && description!.trim().isNotEmpty) {
      map['description'] = description!.trim();
    }


    /// ✅ Price
    if (price != null) {
      map['price'] = price.toString();
    }

    /// ✅ Discount (type + value must come together)
    if (discountType != null || discountValue != null) {
      if (discountType == null || discountValue == null) {
        throw Exception(
            "Both discountType and discountValue must be provided together.");
      }

      map['discount[type]'] = discountType;
      map['discount[value]'] = discountValue.toString();

      if (discountMaxAmount != null && discountMaxAmount! > 0) {
        map['discount[maxAmount]'] =
            discountMaxAmount.toString();
      }
    }

    /// ✅ Images (optional)
    if (images != null && images!.isNotEmpty) {
      map['files'] = await Future.wait(
        images!
            .where((file) => file.path.isNotEmpty)
            .map(
              (file) => MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    /// ✅ Variants (optional)
    if (variants != null && variants!.isNotEmpty) {
      final validVariants = variants!
          .where((v) => v.subVariants.isNotEmpty)
          .map((e) => e.toJson())
          .toList();

      if (validVariants.isNotEmpty) {
        map['variants'] = jsonEncode(validVariants);
      }
    }

    return FormData.fromMap(map);
  }
}

class ServiceVariantUpdateBody {
  final String? id; // null = new variant
  final String variantName;
  final String description;
  final List<ServiceSubVariantUpdateBody> subVariants;

  ServiceVariantUpdateBody({
    this.id,
    required this.variantName,
    required this.description,
    required this.subVariants,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      "variantName": variantName,
      "description": description,
      "subVariants": subVariants.map((e) => e.toJson()).toList(),
    };

    if (id != null && id!.isNotEmpty) {
      map["_id"] = id;
    }

    return map;
  }
}

class ServiceSubVariantUpdateBody {
  final String name;
  final double price;

  ServiceSubVariantUpdateBody({
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
    };
  }
}
