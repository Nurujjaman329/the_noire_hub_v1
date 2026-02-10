import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_noire_hub_v1/core/utils/app_snackbar.dart';

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

        // Instead of just clearing, you could optionally refresh the product list here
        // if you have a Home/List controller.

        Get.back(result: true); // Pass 'true' back so the previous screen knows to refresh
        AppSnackbar.success("Product updated successfully!");

        // Cleanup happens automatically if this controller is deleted on Get.back()
        // If it's a permanent controller, clearing here is fine.
        selectedImages.clear();
      }
    } on AppException catch (e) {
      debugPrint('❌ Controller Caught Error: ${e.message}');
      AppSnackbar.error(e.message);
    } finally {
      isLoading.value = false;
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