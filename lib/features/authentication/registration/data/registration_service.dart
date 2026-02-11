
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:the_noire_hub_v1/features/authentication/registration/data/registration_post_body_model.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class RegistrationService {
  final ApiClient _apiClient;
  RegistrationService(this._apiClient);

  // --- USER REGISTRATION (JSON) ---
  Future<Response> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required List<AddressRequest> addresses,
  }) async {
    final Map<String, dynamic> body = {
      "fullName": fullName,
      "email": email,
      "password": password,
      "phoneNumber":phoneNumber,
      "role": "user",
      "addresses": addresses.map((e) => e.toJson()).toList(),
    };

    // Printing the JSON body clearly
    debugPrint('🚀 [User Registration Body]: ${jsonEncode(body)}');

    return await _apiClient.postJson(ApiConstants.registration, data: body);
  }

  // --- VENDOR REGISTRATION (FormData) ---
  Future<Response> registerVendor({
    required String fullName,
    required String email,
    required String password,
    required String businessName,
    required String phoneNumber,
    required String bio,
    required List<AddressRequest> addresses,
    required List<SelectedCategoryRequest> selectedCategories,
    required File shopImage,
  }) async {

    // 1. Prepare data
    final addressJson = jsonEncode(addresses.map((e) => e.toJson()).toList());
    final categoryJson = jsonEncode(selectedCategories.map((e) => e.toJson()).toList());

    // 2. Create FormData
    FormData formData = FormData.fromMap({
      "fullName": fullName,
      "email": email,
      "password": password,
      "role": "vendor",
      "businessName": businessName,
      "phoneNumber" : phoneNumber,
      "bio": bio,
      "addresses": addressJson,           // Send as Stringified JSON
      "selectedCategories": categoryJson, // Send as Stringified JSON
      "shopImage": await MultipartFile.fromFile(
        shopImage.path,
        filename: shopImage.path.split('/').last,
      ),
    });

    // 3. Debug Printing FormData
    // Note: FormData cannot be printed directly as JSON, so we print fields manually
    debugPrint('📂 [Vendor Registration Form Fields]:');
    debugPrint('fullName: $fullName');
    debugPrint('email: $email');
    debugPrint('role: vendor');
    debugPrint('businessName: $businessName');
    debugPrint('📂 [Encoded Vendor Form Fields]:');
    debugPrint('addresses: $addressJson');
    debugPrint('categories: $categoryJson');
    debugPrint('imagePath: ${shopImage.path}');

    return await _apiClient.postFormData(ApiConstants.registration, data: formData);
  }
}