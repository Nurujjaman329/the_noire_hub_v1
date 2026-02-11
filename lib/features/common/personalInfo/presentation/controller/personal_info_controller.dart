import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/services/cache_service.dart';
import '../../../../../core/storage/local_storage.dart';
import '../../../../authentication/login/data/login_response_model.dart';
import '../../data/personal_info_response_model.dart';
import '../../data/personal_info_service.dart';


class PersonalInfoController extends GetxController {
  final PersonalInfoService _profileService;
  PersonalInfoController(this._profileService);

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // This still holds the full model for the detailed UI
  var userProfile = Rxn<UserProfileModel>();

  @override
  void onInit() {
    super.onInit();
    // No more mapping from LocalStorage.
    // The UI can grab simple strings from CacheService directly.
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _profileService.getProfile();
      final fetchedUser = response.data.attributes.user;

      // 1. Update the detailed reactive state for this screen
      userProfile.value = fetchedUser;

      // 2. Sync the "Core" strings to CacheService
      // This ensures Dashboard and other screens are up to date
      await CacheService.saveSession(
        token: CacheService.token,
        userId: fetchedUser.id,
        role: fetchedUser.role,
        businessName: fetchedUser.businessName,
        fullName: fetchedUser.fullName,
        phone: fetchedUser.phoneNumber.isEmpty ? '' : fetchedUser.phoneNumber,
        bio: fetchedUser.bio,
        image: fetchedUser.image,
      );


      debugPrint("✅ Core info synced to CacheService");
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