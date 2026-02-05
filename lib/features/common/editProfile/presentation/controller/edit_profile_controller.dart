import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_exception.dart';
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
    final user = LocalStorage.getUserModel();
    if (user != null) {
      fullNameController.text = user.fullName;
      phoneController.text = user.phoneNumber.toString();
      bioController.text = user.bio;
      businessNameController.text = user.businessName;
      // Taking the first address as default for editing
      addressController.text = user.addresses.isNotEmpty ? user.addresses.first.city : "";
    }
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
        // Add other fields as per your API requirements
      };

      final response = await _service.updateProfile(
        body: body,
        imagePath: selectedImagePath.value,
      );

      final userJson = response.data.user.toJson();
      final userModelForStorage = UserModel.fromJson(userJson);
      await LocalStorage.setUserModel(userModelForStorage);

      if (Get.isRegistered<PersonalInfoController>()) {
        Get.find<PersonalInfoController>().userProfile.value = UserProfileModel.fromJson(userJson);
      }

      Get.back();
      AppSnackbar.success("Profile updated successfully");
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } catch (e) {
      const fallback = "Something went wrong. Please try again.";
      errorMessage.value = fallback;
      AppSnackbar.error(fallback);
    } finally {
      isLoading.value = false;
    }
  }
}