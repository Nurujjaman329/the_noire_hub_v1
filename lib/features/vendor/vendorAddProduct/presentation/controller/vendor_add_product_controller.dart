import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/api/api_exception.dart';
import '../../data/vendor_add_product_post_body.dart';
import '../../data/vendor_add_product_service.dart';

class VendorAddProductController extends GetxController {
  final VendorAddProductService _service;

  VendorAddProductController(this._service);

  var isLoading = false.obs;

  // ✅ MULTI VARIANT SUPPORT
  final List<ProductVariantBody> selectedVariants = [];

  final selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> addProduct(VendorAddProductPostBody productBody) async {
    debugPrint('⚙️ Controller: Initializing addProduct flow...');
    isLoading.value = true;

    try {
      final success = await _service.createProduct(productBody);

      if (success) {
        debugPrint('✅ Controller: Product created successfully. Resetting state.');

        // ✅ Reset state properly
        selectedVariants.clear();
        selectedImages.clear();

        Get.back();
        Get.snackbar(
          "Success",
          "Product added successfully!",
          backgroundColor: const Color(0xFF1D3826),
          colorText: Colors.white,
        );
      } else {
        debugPrint(
          '⚠️ Controller: Service returned success=false without exception.',
        );
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
      debugPrint('⚙️ Controller: addProduct flow finished.');
    }
  }

  // 📸 Image picker
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
