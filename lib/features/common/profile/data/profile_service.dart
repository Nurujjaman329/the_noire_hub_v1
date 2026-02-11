//
//
//
// import 'package:the_noire_hub_v1/features/common/profile/data/profile_response_model.dart';
//
// import '../../../../core/api/api_client.dart';
// import '../../../../core/api/api_exception.dart';
// import '../../../../core/constants/api_constants.dart';
//
// class ProfileService {
//   final ApiClient _apiClient;
//
//   ProfileService(this._apiClient);
//
//   Future<ProfileResponseModel> getProfile() async {
//     try {
//       final response = await _apiClient.get(ApiConstants.getProfile);
//       return ProfileResponseModel.fromJson(response.data);
//     } on AppException {
//       rethrow;
//     } catch (e) {
//       throw UnknownException(e.toString());
//     }
//   }
// }