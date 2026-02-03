import 'dart:io';
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
    if (passwordController.text != confirmPasswordController.text) {
      _showErrorSnack("Passwords do not match");
      return false;
    }
    return true;
  }

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
    if (selectedShopImage.value == null) throw "Please select a shop image";
    return await _service.registerVendor(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      businessName: businessNameController.text.trim(),
      bio: bioController.text.trim(),
      addresses: addresses,
      selectedCategories: selectedCategories,
      shopImage: selectedShopImage.value!,
    );
  }

  Future<void> pickShopImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) selectedShopImage.value = File(pickedFile.path);
  }
}