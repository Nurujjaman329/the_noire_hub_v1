import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BeauticiansCreateServicePostBody {
  final List<File> images;
  final String categoryId;
  final String subCategoryId;
  final String name;
  final double price;
  final String description;
  final List<String> availableDates;
  final String startTime;
  final String endTime;
  final bool homeService;

  final double? discountValue;
  final String? discountType;
  final double? discountMaxAmount;

  /// ✅ Optional Variants
  final List<ServiceVariantBody>? variants;

  BeauticiansCreateServicePostBody({
    required this.images,
    required this.categoryId,
    required this.subCategoryId,
    required this.name,
    required this.price,
    required this.description,
    required this.availableDates,
    required this.startTime,
    required this.endTime,
    required this.homeService,
    this.discountValue,
    this.discountType,
    this.discountMaxAmount,
    this.variants,
  });

  Future<FormData> toFormData() async {
    // 1. Prepare your files list (Multiple Images)
    List<MultipartFile> multipartFiles = [];
    for (var file in images) {
      if (await file.exists()) {
        multipartFiles.add(
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
            contentType: DioMediaType('image', 'jpeg'),
          ),
        );
      }
    }

    // 2. Create the base Map with standard fields
    final Map<String, dynamic> dataMap = {
      'images': multipartFiles, // Use 'images' or 'files' based on your Postman success
      'category': categoryId,
      'subcategory': subCategoryId,
      'name': name,
      'price': price.toString(),
      'description': description,
      'workingHours[startTime]': startTime,
      'workingHours[endTime]': endTime,
      'homeService': homeService.toString(),
      'variants': jsonEncode(variants?.map((v) => v.toJson()).toList() ?? []),
      'discount[type]': discountType ?? 'flat',
      'discount[value]': discountValue?.toString() ?? '0',
      'discount[maxAmount]': discountMaxAmount?.toString() ?? '0',
    };

    // 3. ✅ DYNAMIC DATES: Loop through availableDates and add to Map
    for (int i = 0; i < availableDates.length; i++) {
      dataMap['availableDates[$i]'] = availableDates[i];
    }

    // 4. Return the FormData from the constructed Map
    return FormData.fromMap(dataMap);
  }
}

class ServiceSubVariantBody {
  final String name;
  final double price;

  ServiceSubVariantBody({
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
class ServiceVariantBody {
  final String variantName;
  final String description;
  final List<ServiceSubVariantBody> subVariants;

  ServiceVariantBody({
    required this.variantName,
    required this.description,
    required this.subVariants,
  });

  Map<String, dynamic> toJson() {
    return {
      "variantName": variantName,
      "description": description,
      "subVariants": subVariants.map((e) => e.toJson()).toList(),
    };
  }
}
