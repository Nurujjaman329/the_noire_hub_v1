import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/storage/local_storage.dart';
import '../../../../authentication/login/data/login_response_model.dart';
import '../../data/personal_info_response_model.dart';
import '../../data/personal_info_service.dart';

class PersonalInfoController extends GetxController {
  final PersonalInfoService _profileService;
  PersonalInfoController(this._profileService);

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Reactive profile data (Specific to this screen/feature)
  var userProfile = Rxn<UserProfileModel>();

  @override
  void onInit() {
    super.onInit();
    // Pre-fill from LocalStorage if available for instant UI loading
    _loadInitialData();
    fetchProfile();
  }

  void _loadInitialData() {
    final storedUser = LocalStorage.getUserModel();
    if (storedUser != null) {
      // Map the generic UserModel back to the specific UserProfileModel for the UI
      userProfile.value = UserProfileModel.fromJson(storedUser.toJson());
    }
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _profileService.getProfile();
      final fetchedUser = response.data.attributes.user;

      // 1. Update the local reactive state
      userProfile.value = fetchedUser;

      // 2. Map to the main UserModel and save to LocalStorage
      // This bridges the gap between different model classes
      final userJson = fetchedUser.toJson();
      final userModel = UserModel.fromJson(userJson);

      await LocalStorage.setUserModel(userModel);

      debugPrint("✅ Personal Info synced to LocalStorage");
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = "Failed to load profile";
      debugPrint("❌ Profile Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}