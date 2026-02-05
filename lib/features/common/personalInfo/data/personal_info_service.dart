


import 'package:the_noire_hub_v1/features/common/personalInfo/data/personal_info_response_model.dart';
import 'package:the_noire_hub_v1/features/common/profile/data/profile_response_model.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/api_constants.dart';

class PersonalInfoService {
  final ApiClient _apiClient;

  PersonalInfoService(this._apiClient);

  Future<PersonalInfoResponseModel> getProfile() async {
    try {
      final response = await _apiClient.get(ApiConstants.getProfile);
      return PersonalInfoResponseModel.fromJson(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}