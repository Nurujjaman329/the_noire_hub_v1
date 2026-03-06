import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class VendorUpdateProductFormBody {
  final List<File>? newImages;
  final String? name;
  final double? price;
  final double? discount;
  final String? description;
  final String? subcategory;
  final double? weightValue;
  final String? weightUnit;
  final double? discountValue;
  final String? discountType;
  final double? discountMaxAmount;
  final int? stock;
  final bool? isActive;
  final List<EditProductVariantBody>? variants;

  VendorUpdateProductFormBody({
    this.newImages,
    this.name,
    this.price,
    this.discount,
    this.description,
    this.subcategory,
    this.weightValue,
    this.weightUnit,
    this.discountValue,
    this.discountType,
    this.discountMaxAmount,
    this.stock,
    this.isActive,
    this.variants,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> dataMap = {};

    // Standard fields
    if (name != null) dataMap['name'] = name;
    if (price != null) dataMap['price'] = price.toString();
    if (description != null) dataMap['description'] = description;
    if (subcategory != null) dataMap['subcategory'] = subcategory;
    if (stock != null) dataMap['stock'] = stock.toString();
    if (isActive != null) dataMap['isActive'] = isActive.toString();

    if (weightValue != null) dataMap['weight[value]'] = weightValue.toString();
    if (weightUnit != null) dataMap['weight[unit]'] = weightUnit;

    if (variants != null && variants!.isNotEmpty) {
      dataMap['variants'] = jsonEncode(variants!.map((v) => v.toJson()).toList());
    }

    // ✅ Corrected Discount Logic for Update
    // Only send discount info if a valid value AND type are provided
    if (discountValue != null && discountValue! > 0 && discountType != null) {
      dataMap['discount[value]'] = discountValue.toString();
      dataMap['discount[type]'] = discountType;

      // Only send maxAmount if it exists and is valid
      if (discountMaxAmount != null && discountMaxAmount! > 0) {
        dataMap['discount[maxAmount]'] = discountMaxAmount.toString();
      }
    }

    if (newImages != null && newImages!.isNotEmpty) {
      dataMap['images'] = await Future.wait(
        newImages!.map(
              (file) => MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    return FormData.fromMap(dataMap);
  }

}

class EditProductVariantBody {
  final String? id;
  final String color;
  final double price;
  final double weightValue;
  final String weightUnit;

  EditProductVariantBody({
    this.id,
    required this.color,
    required this.price,
    required this.weightValue,
    required this.weightUnit,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {
      "color": color,
      "price": price,
      "weight": {
        "value": weightValue,
        "unit": weightUnit,
      }
    };
    
    // Only include the ID if it exists (for existing variants)
    if (id != null) {
      result["_id"] = id;
    }
    
    return result;
  }
}
