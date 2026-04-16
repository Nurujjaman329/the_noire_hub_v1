import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/mixins/map_search_mixin.dart';
import '../../data/registration_post_body_model.dart';
import '../../data/registration_service.dart';
import 'dart:async';


class RegistrationController extends GetxController with MapSearchMixin {
  final RegistrationService _service;
  RegistrationController(this._service);

  // --- UI Controllers ---
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final businessNameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();

  // --- State Variables ---
  var isLoading = false.obs;
  var userRole = 'user'.obs;
  var rememberMe = false.obs;
  var selectedShopImage = Rxn<File>();
  final _picker = ImagePicker();
  var selectedCategories = <SelectedCategoryRequest>[].obs;
  var addresses = <AddressRequest>[].obs;

  @override
  void onClose() {
    for (var c in [fullNameController, emailController, passwordController,
      confirmPasswordController, businessNameController, bioController, phoneController]) {
      c.dispose();
    }
    disposeMapMixin();
    super.onClose();
  }

  // --- Registration Logic ---
  void addAddress(String country, String city, double lat, double lng) {
    addresses.clear();
    addresses.add(AddressRequest(
      country: country,
      city: city,
      location: LocationModel(coordinates: [lng, lat]),
    ));
  }

  Future<void> register() async {
    if (!_validateForm()) return;

    // Always rebuild address payload from the latest selected map state.
    addAddress(
      selectedCountry.value,
      selectedCity.value,
      selectedLatLng.value.latitude,
      selectedLatLng.value.longitude,
    );

    isLoading.value = true;
    try {
      dynamic response = userRole.value == 'user'
          ? await _handleUserRegistration()
          : await _handleVendorRegistration();

      _handleApiResponse(response);
    } catch (e) {
      _handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (fullNameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorSnack("Please fill in all required fields");
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      _showErrorSnack("Please add your phone number");
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _showErrorSnack("Passwords do not match");
      return false;
    }
    if (addresses.isEmpty || currentAddressString.value.trim().isEmpty) {
      _showErrorSnack("Please select your address from map/search before creating account");
      return false;
    }
    if (_hasDefaultDhakaMismatch()) {
      _showErrorSnack(
        "Location mismatch detected. Please reselect address from search/current location.",
      );
      return false;
    }
    return true;
  }

  bool _hasDefaultDhakaMismatch() {
    final city = selectedCity.value.trim().toLowerCase();
    final country = selectedCountry.value.trim().toLowerCase();
    final isDhakaDefault = city == 'dhaka' && country == 'bangladesh';
    if (!isDhakaDefault) return false;

    // Dhaka reference
    const dhakaLat = 23.8103;
    const dhakaLon = 90.4125;
    final lat = selectedLatLng.value.latitude;
    final lon = selectedLatLng.value.longitude;

    // Approx distance in km; mismatch if very far from Dhaka.
    final distanceKm = _haversineKm(lat, lon, dhakaLat, dhakaLon);
    return distanceKm > 50.0;
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371.0;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _degToRad(double deg) => deg * (math.pi / 180.0);

  void _handleApiResponse(dynamic response) {
    if (response.statusCode == 201 || response.statusCode == 200) {
      String msg = response.data['message'] ?? "Account created successfully!";
      Get.snackbar("Success", msg, backgroundColor: Colors.green, colorText: Colors.white);
      Get.toNamed(RouteConstants.otpVerifyScreen, arguments: emailController.text.trim());
    } else {
      _showErrorSnack(response.data['message'] ?? "Something went wrong");
    }
  }

  void _handleException(dynamic e) {
    String error = e is ServerException ? e.message : e.toString().replaceFirst('Exception: ', '');
    _showErrorSnack(error);
  }

  void _showErrorSnack(String msg) {
    Get.snackbar("Error", msg, backgroundColor: Colors.redAccent, colorText: Colors.white);
  }

  Future<dynamic> _handleUserRegistration() async {
    return await _service.registerUser(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      addresses: addresses,
    );
  }

  Future<dynamic> _handleVendorRegistration() async {
    // 1. Get the file from the observable
    final file = selectedShopImage.value;

    // 2. Check if null OR if the file actually exists on the device
    if (file == null || !(await file.exists())) {
      throw "Please select a valid shop image";
    }

    // 3. Pass the role dynamically
    return await _service.registerVendor(
      role: userRole.value, // 'vendor' or 'beautician'
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      businessName: businessNameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      bio: bioController.text.trim(),
      addresses: addresses,
      selectedCategories: selectedCategories,
      shopImage: file, // Use the verified local variable
    );
  }

  Future<void> pickShopImage() async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () async {
                Get.back();
                final pickedFile = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (pickedFile != null) {
                  selectedShopImage.value = File(pickedFile.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () async {
                Get.back();
                final pickedFile = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                if (pickedFile != null) {
                  selectedShopImage.value = File(pickedFile.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }



  // Inside RegistrationController
  void resetFields() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    businessNameController.clear();
    bioController.clear();
    phoneController.clear();

    // Reset observable variables
    selectedShopImage.value = null;
    selectedCategories.clear();
    addresses.clear();
  }
}