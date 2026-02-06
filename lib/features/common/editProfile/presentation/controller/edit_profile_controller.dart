import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/services/cache_service.dart';
import '../../../../../core/storage/local_storage.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../../authentication/login/data/login_response_model.dart';
import '../../../personalInfo/data/personal_info_response_model.dart';
import '../../../personalInfo/presentation/controller/personal_info_controller.dart';
import '../../data/edit_profile_service.dart';

import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final EditProfileService _service;
  EditProfileController(this._service);

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final businessNameController = TextEditingController();
  final addressController = TextEditingController();

  var selectedImagePath = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // ✅ COMPLETELY DECOUPLED: Pre-filling from CacheService strings
    fullNameController.text = CacheService.userFullName;
    businessNameController.text = CacheService.businessName;
    phoneController.text = CacheService.phone;
    bioController.text = CacheService.bio;
  }

  // --- Image Picking Logic ---
  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      selectedImagePath.value = image.path;
      Get.back(); // Close bottom sheet
    }
  }

  Future<void> updateProfile() async {
    isLoading.value = true;
    try {
      final body = {
        'fullName': fullNameController.text,
        'phoneNumber': phoneController.text,
        'bio': bioController.text,
        'businessName': businessNameController.text,
      };

      final response = await _service.updateProfile(
        body: body,
        imagePath: selectedImagePath.value,
      );

      final updatedUser = response.data.user;

      // ✅ SYNC CACHE: Store everything back as strings
      await CacheService.saveSession(
        token: CacheService.token,
        userId: updatedUser.id,
        role: updatedUser.role,
        businessName: updatedUser.businessName,
        fullName: updatedUser.fullName,
        phone: updatedUser.phoneNumber,
        bio: updatedUser.bio,
        image: updatedUser.image,
      );

      // We still update the other controller IF it's alive,
      // but the screen isn't dependent on it.
      if (Get.isRegistered<PersonalInfoController>()) {
        Get.find<PersonalInfoController>().userProfile.value = UserProfileModel.fromJson(updatedUser.toJson());
      }

      Get.back();
      AppSnackbar.success("Profile updated successfully");
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } catch (e) {
      AppSnackbar.error("Something went wrong.");
    } finally {
      isLoading.value = false;
    }
  }

}