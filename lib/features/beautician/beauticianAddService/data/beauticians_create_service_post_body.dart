import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class WorkingSlot {
  final String startTime;
  final String endTime;

  WorkingSlot({required this.startTime, required this.endTime});

  Map<String, String> toJson() => {
    "startTime": startTime,
    "endTime": endTime,
  };
}

class BeauticiansCreateServicePostBody {
  final List<File> images;
  final String categoryId;
  final String subCategoryId;
  final String name;
  final double price;
  final String description;
  final List<String> availableDates;
  final List<WorkingSlot> workingSlots; // ✅ Replaced startTime/endTime
  final bool homeService;

  final double? discountValue;
  final String? discountType;
  final double? discountMaxAmount;
  final List<ServiceVariantBody>? variants;

  BeauticiansCreateServicePostBody({
    required this.images,
    required this.categoryId,
    required this.subCategoryId,
    required this.name,
    required this.price,
    required this.description,
    required this.availableDates,
    required this.workingSlots, // ✅ Updated
    required this.homeService,
    this.discountValue,
    this.discountType,
    this.discountMaxAmount,
    this.variants,
  });

  Future<FormData> toFormData() async {
    List<MultipartFile> multipartFiles = [];
    for (var file in images) {
      if (await file.exists()) {
        multipartFiles.add(await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: DioMediaType('image', 'jpeg'),
        ));
      }
    }

    final Map<String, dynamic> dataMap = {
      'images': multipartFiles,
      'category': categoryId,
      'subcategory': subCategoryId,
      'name': name,
      'price': price.toString(),
      'description': description,
      'homeService': homeService.toString(),
      'variants': jsonEncode(variants?.map((v) => v.toJson()).toList() ?? []),
      'discount[type]': discountType ?? 'flat',
      'discount[value]': discountValue?.toString() ?? '0',
      'discount[maxAmount]': discountMaxAmount?.toString() ?? '0',
    };

    // ✅ Dynamic Dates
    for (int i = 0; i < availableDates.length; i++) {
      dataMap['availableDates[$i]'] = availableDates[i];
    }

    // ✅ Dynamic Working Slots (Formats as workingSlots[0][startTime], etc.)
    for (int i = 0; i < workingSlots.length; i++) {
      dataMap['workingSlots[$i][startTime]'] = workingSlots[i].startTime;
      dataMap['workingSlots[$i][endTime]'] = workingSlots[i].endTime;
    }

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
