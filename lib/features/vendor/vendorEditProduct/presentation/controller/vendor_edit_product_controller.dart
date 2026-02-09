import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/api/api_exception.dart';
import '../../data/vendor_edit_product_form_body.dart';
import '../../data/vendor_edit_product_service.dart';
import 'package:flutter/material.dart';

class VendorEditProductController extends GetxController {
  final VendorEditProductService _service;
  VendorEditProductController(this._service);

  var isLoading = false.obs;

  // Multi-variant and Image state
  final RxList<EditProductVariantBody> selectedVariants = <EditProductVariantBody>[].obs;
  final RxList<File> selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> updateProduct(String productId, VendorUpdateProductFormBody productBody) async {
    debugPrint('⚙️ Controller: Initializing updateProduct flow for ID: $productId');
    isLoading.value = true;

    try {
      final success = await _service.patchProduct(productId, productBody);

      if (success) {
        debugPrint('✅ Controller: Product updated successfully.');

        // Reset state
        selectedVariants.clear();
        selectedImages.clear();

        Get.back(); // Return to previous screen
        Get.snackbar(
          "Success",
          "Product updated successfully!",
          backgroundColor: const Color(0xFF1D3826),
          colorText: Colors.white,
        );
      }
    } on AppException catch (e) {
      debugPrint('❌ Controller Caught Error: ${e.message}');
      Get.snackbar(
        "Update Error",
        e.message,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      debugPrint('⚙️ Controller: updateProduct flow finished.');
    }
  }

  // --- Image Handling (Reusable) ---
  Future<void> pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile> images = await _picker.pickMultiImage();
        if (images.isNotEmpty) {
          selectedImages.addAll(images.map((x) => File(x.path)));
        }
      } else {
        final XFile? image = await _picker.pickImage(source: source);
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