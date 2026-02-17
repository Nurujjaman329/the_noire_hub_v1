import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BeauticianServiceUpdatePostBody {
  final List<File>? images;
  final String? name;
  final String? description;
  final double? price;
  final bool sendVariantsIdOnly;
  final List<String>? existingImages; // ✅ ADD THIS
  final bool? homeService;

  final List<DateTime>? availableDates;

  final String? discountType;        // flat | percentage
  final double? discountValue;
  final double? discountMaxAmount;

  final List<ServiceVariantUpdateBody>? variants;

  BeauticianServiceUpdatePostBody({
    this.images,
    this.name,
    this.description,
    this.price,
    this.availableDates,
    this.discountType,
    this.discountValue,
    this.discountMaxAmount,
    this.existingImages,
    this.homeService,
    this.variants,
    this.sendVariantsIdOnly = false,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {};

    /// ✅ Name
    if (name != null && name!.trim().isNotEmpty) {
      map['name'] = name!.trim();
    }

    /// ✅ Description
    if (description != null && description!.trim().isNotEmpty) {
      map['description'] = description!.trim();
    }

    /// ✅ Price (send as number, not string)
    if (price != null) {
      map['price'] = price;
    }

    if (homeService != null) {
      map['homeService'] = homeService;
    }

    /// ✅ Existing Images (Tell backend which ones to keep)
    if (existingImages != null) {
      for (int i = 0; i < existingImages!.length; i++) {
        map['images[$i]'] = existingImages![i];
      }
    }

    /// ✅ Available Dates
    if (availableDates != null && availableDates!.isNotEmpty) {
      for (int i = 0; i < availableDates!.length; i++) {
        map['availableDates[$i]'] =
            availableDates![i].toIso8601String().split('T').first;
      }
    }

    /// ✅ Discount (must come together)
    if (discountType != null && discountValue != null) {
      map['discount[type]'] = discountType;
      map['discount[value]'] = discountValue;

      if (discountMaxAmount != null && discountMaxAmount! > 0) {
        map['discount[maxAmount]'] = discountMaxAmount;
      }
    } else {
      // If they are missing, we just don't send them in the PATCH request.
      // This allows the backend to keep the existing discount values.
      debugPrint("ℹ️ Discount info not provided, skipping discount update.");
    }

    /// ✅ Images
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

    /// ✅ Variants
    if (variants != null) {
      final List<Map<String, dynamic>> variantList = variants!
          .map((e) => e.toJson(onlyId: sendVariantsIdOnly)) // ✅ Use the flag here
          .toList();

      map['variants'] = jsonEncode(variantList);
    }

    return FormData.fromMap(map);
  }
}


class ServiceVariantUpdateBody {
  final String? id;
  final String variantName;
  final String description;
  final List<ServiceSubVariantUpdateBody> subVariants;

  ServiceVariantUpdateBody({
    this.id,
    required this.variantName,
    required this.description,
    required this.subVariants,
  });

  // ✅ Modified toJson to accept a flag
  Map<String, dynamic> toJson({bool onlyId = false}) {
    // If we only need the ID (for deletion/syncing what stays)
    if (onlyId && id != null) {
      return {"_id": id};
    }

    // Otherwise, send the full object (for Edit/Create)
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
