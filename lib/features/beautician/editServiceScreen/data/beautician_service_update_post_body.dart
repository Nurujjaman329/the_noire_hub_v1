import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';


class BeauticianServiceUpdatePostBody {
  final List<File>? images;
  final String? name;
  final String? description;
  final double? price;
  final List<String>? existingImages;
  final bool? homeService;
  final List<DateTime>? availableDates;
  final String? discountType;
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

  /// Inside your Model class (e.g., Product or Service Model)
  Future<FormData> toFormData() async {
    final Map<String, dynamic> dataMap = {};

    // --- 1. Basic Text Fields ---
    if (name != null) dataMap['name'] = name!.trim();
    if (description != null) dataMap['description'] = description!.trim();
    if (price != null) dataMap['price'] = price.toString();
    if (homeService != null) dataMap['homeService'] = homeService.toString();

    // --- 2. The Image Gallery (Unified Logic) ---
    // Most modern APIs prefer a single key if you are "syncing" the gallery.
    List<dynamic> combinedImages = [];

    // Add existing remote URLs (Strings)
    if (existingImages != null && existingImages!.isNotEmpty) {
      combinedImages.addAll(existingImages!);
    }

    // Add new local Files (MultipartFile)
    if (images != null && images!.isNotEmpty) {
      for (var file in images!) {
        if (await file.exists()) {
          String fileName = file.path.split('/').last;
          combinedImages.add(
            await MultipartFile.fromFile(
              file.path,
              filename: fileName,
            ),
          );
        }
      }
    }

    if (combinedImages.isNotEmpty) {
      // Note: Use 'images' or 'images[]' depending on your backend requirements
      dataMap['images'] = combinedImages;
    }

    // --- 3. Indexed Arrays (Dates) ---
    // Sending as availableDates[0], availableDates[1]...
    if (availableDates != null) {
      for (int i = 0; i < availableDates!.length; i++) {
        dataMap['availableDates[$i]'] =
            availableDates![i].toIso8601String().split('T').first;
      }
    }

    // --- 4. Nested Map Objects (Discount) ---
    if (discountType != null) {
      dataMap['discount[type]'] = discountType;
      dataMap['discount[value]'] = discountValue.toString();
      if (discountMaxAmount != null) {
        dataMap['discount[maxAmount]'] = discountMaxAmount.toString();
      }
    }

    // --- 5. Complex Lists (Variants) ---
    // Variants are usually best sent as a JSON string within Form-Data
    if (variants != null && variants!.isNotEmpty) {
      dataMap['variants'] = jsonEncode(variants!.map((v) => v.toJson()).toList());
    }

    // --- 6. Final Construction ---
    // Dio automatically handles the boundary and content-type
    return FormData.fromMap(dataMap);
  }
}

class ServiceVariantUpdateBody {
  final String? id;
  final String variantName;
  final String description;
  final List<ServiceSubVariantUpdateBody> subVariants;
  final bool sendOnlyId;

  ServiceVariantUpdateBody({
    this.id,
    required this.variantName,
    required this.description,
    required this.subVariants,
    this.sendOnlyId = false,
  });

  Map<String, dynamic> toJson() {
    if (sendOnlyId && id != null) {
      return {"_id": id};
    }

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