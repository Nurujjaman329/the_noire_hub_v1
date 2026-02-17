import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BeauticianServiceUpdatePostBody {
  final List<File>? images;
  final String? name;
  final String? description;
  final double? price;
  final List<String>? existingImages; // ✅ Tell backend which images to keep
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

    /// ✅ Existing Images - NOT USED
    /// Backend keeps existing images automatically when no image field is sent
    /// Image deletion not supported in this API version

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
          .map((e) => e.toJson()) // ✅ Each variant decides its own format
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
  final bool sendOnlyId; // ✅ Flag to indicate if this variant should only send its ID

  ServiceVariantUpdateBody({
    this.id,
    required this.variantName,
    required this.description,
    required this.subVariants,
    this.sendOnlyId = false,
  });

  // ✅ Modified toJson to check per-variant flag
  Map<String, dynamic> toJson() {
    // If this variant should only send ID (for keeping existing variant without changes)
    if (sendOnlyId && id != null) {
      return {"_id": id};
    }

    // Otherwise, send the full object (for new/edited variants)
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
