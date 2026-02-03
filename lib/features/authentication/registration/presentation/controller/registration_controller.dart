import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../data/registration_post_body_model.dart';
import '../../data/registration_service.dart';
import 'dart:async';
import 'package:dio/dio.dart' as dio_instance;

class RegistrationController extends GetxController {
  final RegistrationService _service;
  RegistrationController(this._service);

  // --- UI Controllers ---
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final businessNameController = TextEditingController();
  final bioController = TextEditingController();
  final searchController = TextEditingController();
  final phoneController = TextEditingController();


  // --- State Variables ---
  var isLoading = false.obs;
  var userRole = 'user'.obs;
  var rememberMe = false.obs;

  // --- Image State ---
  var selectedShopImage = Rxn<File>();
  final _picker = ImagePicker();

  // --- Google Maps & Location State ---
  GoogleMapController? mapController;
  var selectedLatLng = const LatLng(23.8311, 90.4243).obs; // Default Dhaka
  var currentAddressString = ''.obs;
  var selectedCity = 'Dhaka'.obs;
  var selectedCountry = 'Bangladesh'.obs;

  // --- Search & Suggestions State ---
  var placePredictions = <Map<String, dynamic>>[].obs;
  Timer? _debounce;
  final String googleApiKey = "AIzaSyCrmEOP4JyFCozu7n85BIZqn_8LarJq_iI";

  // --- Data Lists ---
  var selectedCategories = <SelectedCategoryRequest>[].obs;
  var addresses = <AddressRequest>[].obs;

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    businessNameController.dispose();
    bioController.dispose();
    searchController.dispose();
    phoneController.dispose();
    _debounce?.cancel();

    super.onClose();
  }

  // --- 1. Places Autocomplete Logic (Flutter 3 Compatible) ---
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      getSuggestions(query);
    });
  }

  Future<void> getSuggestions(String query) async {
    if (query.isEmpty) {
      placePredictions.clear();
      return;
    }

    try {
      final url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleApiKey";
      final response = await dio_instance.Dio().get(url);

      if (response.statusCode == 200) {
        final List predictions = response.data['predictions'];
        placePredictions.assignAll(predictions.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      debugPrint("Autocomplete Error: $e");
    }
  }

  // --- 2. Select Suggestion & Update Map ---
  Future<void> selectPrediction(Map<String, dynamic> prediction) async {
    String placeId = prediction['place_id'];
    searchController.text = prediction['description'] ?? "";
    placePredictions.clear();

    try {
      final detailUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey";
      final response = await dio_instance.Dio().get(detailUrl);

      if (response.statusCode == 200) {
        final location = response.data['result']['geometry']['location'];
        updateLocation(LatLng(location['lat'], location['lng']));
        FocusManager.instance.primaryFocus?.unfocus();
      }
    } catch (e) {
      debugPrint("Place Details Error: $e");
    }
  }

  // --- 3. Location Logic ---
  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    updateLocation(LatLng(position.latitude, position.longitude));
  }

  Future<void> updateLocation(LatLng latLng) async {
    selectedLatLng.value = latLng;
    mapController?.animateCamera(CameraUpdate.newLatLng(latLng));

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        selectedCity.value = place.locality ?? '';
        selectedCountry.value = place.country ?? '';
        currentAddressString.value = "${place.street}, ${place.locality}, ${place.country}";
      }
    } catch (e) {
      debugPrint("Reverse Geocoding Error: $e");
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // --- 4. Registration Logic ---
  void addAddress(String country, String city, double lat, double lng) {
    addresses.clear(); // Ensure we only have one primary address
    addresses.add(AddressRequest(
      country: country,
      city: city,
      location: LocationModel(coordinates: [lng, lat]),
    ));
  }

  Future<void> register() async {
    // 1. Validation
    if (fullNameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill in all required fields",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Passwords do not match",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      dynamic response;

      if (userRole.value == 'user') {
        response = await _handleUserRegistration();
      } else {
        response = await _handleVendorRegistration();
      }

      // --- Debug Logging the API Response ---
      debugPrint('📩 [API Response Status]: ${response.statusCode}');
      debugPrint('📩 [API Response Body]: ${response.data}');

      // 2. Handle Success (Status Code 201 or 200)
      if (response.statusCode == 201 || response.statusCode == 200) {
        String successMsg = response.data['message'] ?? "Account created successfully!";

        debugPrint('✅ [Success Message]: $successMsg');

        Get.snackbar("Success", successMsg,
            backgroundColor: Colors.green, colorText: Colors.white);

        // Navigate to OTP page - passing email as argument for the next screen
        Get.toNamed(RouteConstants.otpVerifyScreen, arguments: emailController.text.trim());
      }
      // Note: With your ApiClient setup, non-200/201 codes usually go to the catch block.
      // But we keep this else for safety if validateStatus is modified.
      else {
        String errorMsg = response.data['message'] ?? "Something went wrong";
        Get.snackbar("Registration Failed", errorMsg,
            backgroundColor: Colors.orange, colorText: Colors.white);
      }

    } catch (e) {
      // 4. Handle Network or API errors properly
      debugPrint('🆘 [Exception Caught]: $e');

      String displayError;

      // Check if the error is one of our custom exceptions from ApiClient
      if (e is ServerException) {
        displayError = e.message; // "Email already taken"
      } else if (e is NoInternetException) {
        displayError = "No internet connection. Please try again.";
      } else if (e is TimeoutException) {
        displayError = "Connection timed out. Server is busy.";
      } else {
        // Fallback for unexpected errors
        displayError = e.toString().replaceFirst('Exception: ', '');
      }

      debugPrint('❌ [Display Error]: $displayError');

      Get.snackbar("Registration Failed", displayError,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);

    } finally {
      isLoading.value = false;
    }
  }

// Update handlers to return the response object
  Future<dynamic> _handleUserRegistration() async {
    return await _service.registerUser(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      phoneNumber : phoneController.text.trim(),
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
}