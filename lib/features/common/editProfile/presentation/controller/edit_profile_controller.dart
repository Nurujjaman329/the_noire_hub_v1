import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/controllers/profile_controller.dart';
import '../../../../../core/services/cache_service.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../../../core/utils/mixins/map_search_mixin.dart';
import '../../../personalInfo/data/personal_info_response_model.dart';
import '../../../personalInfo/presentation/controller/personal_info_controller.dart';
import '../../data/edit_profile_service.dart';

import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController with MapSearchMixin {
  final EditProfileService _service;
  EditProfileController(this._service);

  // --- Form Controllers ---
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final businessNameController = TextEditingController();
  final addressController = TextEditingController();

  // --- Observables ---
  var selectedImagePath = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    // Prefill from CacheService
    fullNameController.text = CacheService.userFullName;
    businessNameController.text = CacheService.businessName;
    phoneController.text = CacheService.phone;
    bioController.text = CacheService.bio;

    // Prefill address from PersonalInfoController if exists
    if (Get.isRegistered<PersonalInfoController>()) {
      final profile = Get.find<PersonalInfoController>().userProfile.value;
      if (profile != null && profile.addresses.isNotEmpty) {
        final address = profile.addresses.first;
        addressController.text = "${address.city}, ${address.country}";

        // Prefill map info
        selectedLatLng.value = LatLng(
          address.location.coordinates[1], // latitude
          address.location.coordinates[0], // longitude
        );
        selectedCity.value = address.city;
        selectedCountry.value = address.country;
        currentAddressString.value = addressController.text;
      }
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    businessNameController.dispose();
    addressController.dispose();
    disposeMapMixin();
    super.onClose();
  }

  // --- Image Picking ---
  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      selectedImagePath.value = image.path;
      Get.back(); // Close bottom sheet
    }
  }

  // --- Update address when map changes ---
  void setAddressFromMap() {
    addressController.text = currentAddressString.value;
  }

  // --- Update Profile ---
// Inside EditProfileController

  Future<void> updateProfile() async {
    isLoading.value = true;
    try {
      final body = {
        'fullName': fullNameController.text,
        'phoneNumber': phoneController.text,
        'bio': bioController.text,
        'businessName': businessNameController.text,
        'addresses': [
          {
            'city': selectedCity.value,
            'country': selectedCountry.value,
            'location': {
              'type': 'Point',
              'coordinates': [
                selectedLatLng.value.longitude,
                selectedLatLng.value.latitude,
              ]
            },
            'isDefault': true
          }
        ],
      };

      final response = await _service.updateProfile(
        body: body,
        imagePath: selectedImagePath.value,
      );

      final updatedUser = response.user;
      double? newLat;
      double? newLon;
      String? combinedAddress;

      if (updatedUser.addresses.isNotEmpty) {
        final addr = updatedUser.addresses.firstWhere((a) => a.isDefault, orElse: () => updatedUser.addresses.first);
        newLon = addr.location.coordinates[0];
        newLat = addr.location.coordinates[1];
        combinedAddress = "${addr.city}|${addr.country}";
      }

      // --- 2. SYNC CACHE SERVICE ---
      await CacheService.saveSession(
        token: CacheService.token,
        userId: updatedUser.id,
        role: updatedUser.role,
        businessName: updatedUser.businessName,
        fullName: updatedUser.fullName,
        phone: updatedUser.phoneNumber,
        bio: updatedUser.bio,
        image: updatedUser.image,
        address: combinedAddress,
        lat: newLat,
        lon: newLon,
      );

      // --- 3. SYNC PROFILE CONTROLLER (Reactive) ---
      if (Get.isRegistered<ProfileController>()) {
        final profileCtrl = Get.find<ProfileController>();
        profileCtrl.updateProfile(
          image: updatedUser.image,
          fullName: updatedUser.fullName,
          businessName: updatedUser.businessName,
          phone: updatedUser.phoneNumber,
          bio: updatedUser.bio,
          address: combinedAddress,
          lat: newLat,
          lon: newLon,
        );
      }

      // --- 4. SYNC OTHER CONTROLLERS ---
      if (Get.isRegistered<PersonalInfoController>()) {
        Get.find<PersonalInfoController>().userProfile.value =
            UserProfileModel.fromJson(updatedUser.toJson());
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


  @override
  Future<void> selectPrediction(Map<String, dynamic> prediction) async {
    // 1. Set the description into the main address field
    addressController.text = prediction['description'] ?? "";

    // 2. Clear predictions to hide the list
    placePredictions.clear();

    // 3. Call mixin to get Lat/Lon and move map
    await super.selectPrediction(prediction);

    // 4. Force UI to update map position if needed
    updateLocation(selectedLatLng.value);
  }
}
