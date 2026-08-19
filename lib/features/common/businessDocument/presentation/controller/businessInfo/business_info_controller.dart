import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/api/api_exception.dart';
import '../../../../../../core/utils/app_snackbar.dart';
import '../../../../../../core/utils/mixins/map_search_mixin.dart';
import '../../../data/businessInfo/business_info_response_model.dart';
import '../../../data/businessInfo/business_info_service.dart';
import '../../../data/businessInfo/business_info_update_form_body.dart';
import '../../../data/businessInfo/categoryUpdate/category_update_post_body.dart';

class BusinessInfoController extends GetxController with MapSearchMixin {
  final BusinessInfoService _service;
  BusinessInfoController(this._service);

  var isLoading = false.obs;
  var isUpdating = false.obs;
  var businessData = Rxn<BusinessData>();

  var isEditingBio = false.obs;
  var isEditingPhone = false.obs;
  var isEditingName = false.obs;

  var isEditingAddress = false.obs;
  final addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  var selectedImagePath = ''.obs;
  late TextEditingController nameEditController;


  late TextEditingController bioEditController;
  late TextEditingController phoneEditController;

  @override
  void onInit() {
    super.onInit();
    nameEditController = TextEditingController();
    bioEditController = TextEditingController();
    phoneEditController = TextEditingController();
    fetchBusinessInfo();
  }


  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
          source: source,
          imageQuality: 70
      );

      if (image != null) {
        // 1. Show local preview instantly
        selectedImagePath.value = image.path;

        // 2. Upload to server
        await updateSingleField(imagePath: image.path);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    } finally {
      // 3. Reset preview (The fetchBusinessInfo inside updateSingleField handles the new URL)
      selectedImagePath.value = "";
    }
  }

  void prepareAddressEdit(BusinessData data) {
    addressController.text = "${data.address.city}, ${data.address.country}";
    selectedLatLng.value = LatLng(data.address.latitude, data.address.longitude);
    selectedCity.value = data.address.city;
    selectedCountry.value = data.address.country;
    isEditingAddress.value = true;
  }

  // Helper to sync controllers when data arrives
  void syncControllers() {
    if (businessData.value != null) {
      bioEditController.text = businessData.value!.bio;
      phoneEditController.text = businessData.value!.phoneNumber.toString();
    }
  }
  Future<void> fetchBusinessInfo() async {
    isLoading.value = true;
    try {
      final response = await _service.getBusinessInfo();
      businessData.value = response.data;
    } on AppException catch (e) {
      debugPrint("Error fetching business info: ${e.message}");
    } finally {
      isLoading.value = false;
    }
  }

  /// New Method: Update General Profile Information
  Future<void> updateProfile(BusinessInfoUpdateFormBody body) async {
    isUpdating.value = true;
    try {
      await _service.updateBusinessInfo(body);
      AppSnackbar.success("Profile updated successfully!");

      // Refresh the data to show updated name/image in UI
      await fetchBusinessInfo();
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isUpdating.value = false;
    }
  }


  Future<void> updateSingleField({String? bio, String? phone, String? name, String? imagePath}) async {
    isUpdating.value = true;
    try {
      final body = BusinessInfoUpdateFormBody(
        bio: bio,
        phoneNumber: phone,
        businessName: name,
        imagePath: imagePath,
      );

      await _service.updateBusinessInfo(body);
      await fetchBusinessInfo();

      // Reset states
      isEditingBio.value = false;
      isEditingPhone.value = false;
      isEditingName.value = false;
      selectedImagePath.value = '';

      AppSnackbar.success("Updated successfully!");
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isUpdating.value = false;
    }
  }


  Future<void> updateAddressField() async {
    isUpdating.value = true;
    try {
      final body = BusinessInfoUpdateFormBody(
        addresses: [
          BusinessAddressBody(
            city: selectedCity.value,
            country: selectedCountry.value,
            longitude: selectedLatLng.value.longitude,
            latitude: selectedLatLng.value.latitude,
          )
        ],
      );

      await _service.updateBusinessInfo(body);
      await fetchBusinessInfo();
      isEditingAddress.value = false;
      AppSnackbar.success("Address updated successfully!");
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  Future<void> selectPrediction(Map<String, dynamic> prediction) async {
    addressController.text = prediction['description'] ?? "";
    placePredictions.clear();
    await super.selectPrediction(prediction);
    updateLocation(selectedLatLng.value);
  }

  Future<bool> updateBusinessCategories(CategoryUpdatePostBody body) async {
    isUpdating.value = true;
    try {
      await _service.updateCategories(body);
      AppSnackbar.success("Categories updated successfully!");
      await fetchBusinessInfo();
      return true;
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
      return false;
    } finally {
      isUpdating.value = false;
    }
  }
}