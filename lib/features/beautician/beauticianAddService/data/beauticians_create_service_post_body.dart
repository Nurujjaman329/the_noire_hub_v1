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
    // Use a Map<String, dynamic> to collect everything
    final Map<String, dynamic> map = {
      'category': categoryId,
      'subcategory': subCategoryId,
      'name': name,
      'price': price.toString(),
      'description': description,
      'homeService': homeService.toString(),
      'workingHours[startTime]': startTime,
      'workingHours[endTime]': endTime,
    };

    // Add dates
    for (int i = 0; i < availableDates.length; i++) {
      map['availableDates[$i]'] = availableDates[i];
    }

    // ✅ FIX: Attach Images correctly
    if (images.isNotEmpty) {
      List<MultipartFile> files = [];
      for (var file in images) {
        if (await file.exists()) {
          files.add(await MultipartFile.fromFile(
            file.path,
            filename: file.path
                .split('/')
                .last,
          ));
        }
      }
      // Most backends expect the key to be "images" for multiple files
      map['images'] = files;
    }

    // Add variants
    if (variants != null && variants!.isNotEmpty) {
      map['variants'] = jsonEncode(variants!.map((v) => v.toJson()).toList());
    }

    // Convert the whole map to FormData
    return FormData.fromMap(map);
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
