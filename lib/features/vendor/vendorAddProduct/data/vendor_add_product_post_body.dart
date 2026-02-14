import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class VendorAddProductPostBody {
  final List<File> images;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String subCategoryId;
  final double weightValue;
  final String weightUnit;
  final int? stock;
  final double? discountValue;
  final String? discountType;
  final double? discountMaxAmount;

  // ✅ Support multiple variants
  final List<ProductVariantBody>? variants;

  VendorAddProductPostBody({
    required this.images,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.subCategoryId,
    required this.weightValue,
    required this.weightUnit,
     this.discountValue,
     this.discountType,
    this.discountMaxAmount,
    this.stock,
    this.variants,
  });

  /// Convert to FormData (Dio)
  Future<FormData> toFormData() async {
    // Start with mandatory fields
    final Map<String, dynamic> map = {
      'name': name,
      'description': description,
      'price': price.toString(),
      'category': categoryId,
      'subcategory': subCategoryId,
      'weight[value]': weightValue.toString(), // Flattened for FormData
      'weight[unit]': weightUnit,
    };

    // ✅ Only add stock if it's not null
    if (stock != null) {
      map['stock'] = stock.toString();
    }

    // ✅ Conditional Discount Object
    // Only create the discount object if a value and type exist
    if (discountValue != null && discountValue! > 0 && discountType != null) {
      map['discount[value]'] = discountValue.toString();
      map['discount[type]'] = discountType;

      // Only add maxAmount if it's actually provided
      if (discountMaxAmount != null && discountMaxAmount! > 0) {
        map['discount[maxAmount]'] = discountMaxAmount.toString();
      }
    }

    // ✅ Images
    if (images.isNotEmpty) {
      map['images'] = await Future.wait(
        images.map(
              (file) => MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    // ✅ Variants
    if (variants != null && variants!.isNotEmpty) {
      map['variants'] = jsonEncode(
        variants!.map((v) => v.toJson()).toList(),
      );
    }

    return FormData.fromMap(map);
  }
}

class ProductVariantBody {
  final String color;
  final double price;
  final double weight;
  final String unit;

  ProductVariantBody({
    required this.color,
    required this.price,
    required this.weight,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'price': price,
      'weight': {
        'value': weight,
        'unit': unit,
      },
    };
  }
}
