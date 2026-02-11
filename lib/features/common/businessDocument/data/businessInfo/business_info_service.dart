

import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/constants/api_constants.dart';
import 'business_info_response_model.dart';
import 'categoryUpdate/category_update_post_body.dart';

class BusinessInfoService {
  final ApiClient _apiClient;
  BusinessInfoService(this._apiClient);

  Future<BusinessInfoResponseModel> getBusinessInfo() async {
    try {
      final response = await _apiClient.get(ApiConstants.getBusinessInfo);
      return BusinessInfoResponseModel.fromJson(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> updateCategories(CategoryUpdatePostBody body) async {
    try {
      await _apiClient.patch(
        ApiConstants.categoryUpdate,
        data: body.toJson(),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}