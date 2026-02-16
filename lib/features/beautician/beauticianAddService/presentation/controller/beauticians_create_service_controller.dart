import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/api/api_exception.dart';
import '../../data/beauticians_create_service.dart';
import '../../data/beauticians_create_service_post_body.dart';


class BeauticiansCreateServiceController extends GetxController {
  final BeauticiansCreateService _service;
  BeauticiansCreateServiceController(this._service);

  var isLoading = false.obs;

  // ✅ MULTI VARIANT SUPPORT (Add-ons)
  final selectedVariants = <ServiceVariantBody>[].obs;

  // ✅ IMAGE SUPPORT
  final selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> addService(BeauticiansCreateServicePostBody serviceBody) async {
    debugPrint('⚙️ Controller: Initializing addService flow...');


    final finalBody = BeauticiansCreateServicePostBody(
      images: selectedImages.toList(), // Use the controller's picked images
      categoryId: serviceBody.categoryId,
      subCategoryId: serviceBody.subCategoryId,
      name: serviceBody.name,
      price: serviceBody.price,
      description: serviceBody.description,
      availableDates: serviceBody.availableDates,
      startTime: serviceBody.startTime,
      endTime: serviceBody.endTime,
      homeService: serviceBody.homeService,
      discountType: serviceBody.discountType,
      discountValue: serviceBody.discountValue,
      discountMaxAmount: serviceBody.discountMaxAmount,
      variants: selectedVariants.toList(), // Also sync variants if they are managed in controller
    );

    isLoading.value = true;

    try {
      final success = await _service.createService(finalBody);

      if (success) {
        debugPrint('✅ Controller: Service created successfully. Resetting state.');

        // ✅ Reset state properly
        selectedVariants.clear();
        selectedImages.clear();

        Get.back();
        Get.snackbar(
          "Success",
          "Service added successfully!",
          backgroundColor: const Color(0xFF1D3826),
          colorText: Colors.white,
        );
      } else {
        debugPrint('⚠️ Controller: Service returned success=false without exception.');
      }
    } on AppException catch (e) {
      debugPrint('❌ Controller Caught Error: ${e.message}');
      Get.snackbar(
        "Error",
        e.message,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      debugPrint('⚙️ Controller: addService flow finished.');
    }
  }

  // 📸 Image picker (Supports multi-select from gallery)
  Future<void> pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile> images = await _picker.pickMultiImage();
        if (images.isNotEmpty) {
          selectedImages.addAll(images.map((x) => File(x.path)));
        }
      } else {
        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          selectedImages.add(File(image.path));
        }
      }
    } catch (e) {
      debugPrint("❌ Error picking image: $e");
    }
  }

  void removeImage(int index) => selectedImages.removeAt(index);
}