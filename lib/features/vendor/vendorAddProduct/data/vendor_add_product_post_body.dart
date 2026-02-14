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
    this.stock,
    this.variants,
  });

  /// Convert to FormData (Dio)
  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      'name': name,
      'description': description,
      'price': price.toString(),
      'category': categoryId,
      'subcategory': subCategoryId,
      'stock': stock?.toString(),

      // ✅ Nested weight object
      'weight': {
        'value': weightValue,
        'unit': weightUnit,
      },

      'discount': {
        'value': discountValue,
        'type': discountType,
      },
    };

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

    // ✅ Variants: array of objects
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
