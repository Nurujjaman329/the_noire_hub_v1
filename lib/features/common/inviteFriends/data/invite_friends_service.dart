

import 'package:the_noire_hub_v1/core/constants/api_constants.dart';
import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import 'invite_friends_response_model.dart';

class InviteFriendsService {
  final ApiClient _apiClient;
  InviteFriendsService(this._apiClient);


  Future<InviteFriendsResponseModel> fetchInviteLink() async {
    final uri = ApiConstants.inviteLink;
    try {
      // Using your ApiClient's get method
      final response = await _apiClient.get(uri);

      if (response.statusCode == 200) {
        return InviteFriendsResponseModel.fromJson(response.data);
      } else {
        throw Exception("Server returned ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ InviteService Error: $e");
      rethrow;
    }
  }
}