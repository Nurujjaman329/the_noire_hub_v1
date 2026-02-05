import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import 'edit_profile_response_model.dart';

class EditProfileService {
  final ApiClient _apiClient;
  EditProfileService(this._apiClient);

  Future<EditProfileResponseModel> updateProfile({
    required Map<String, dynamic> body,
    String? imagePath,
  }) async {
    try {
      // Create FormData
      final formData = FormData.fromMap(body);

      // Add image if path is provided
      if (imagePath != null && imagePath.isNotEmpty) {
        formData.files.add(MapEntry(
          'image', // Make sure 'image' matches your backend field name
          await MultipartFile.fromFile(
              imagePath,
              filename: imagePath.split('/').last
          ),
        ));
      }

      // Use the specific FormData helper
      final response = await _apiClient.patchFormData(
        ApiConstants.updateProfile,
        data: formData,
      );

      return EditProfileResponseModel.fromJson(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}