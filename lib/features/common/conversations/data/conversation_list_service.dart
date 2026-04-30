import 'package:flutter/material.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'conversation_list_response_model.dart';

class ConversationListService {
  final ApiClient _apiClient;
  ConversationListService(this._apiClient);

  Future<ConversationListResponseModel> getConversations({
    int page = 1,
    int limit = 20,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
    };

    debugPrint('🚀 [GET] Request to: ${ApiConstants.conversations}');
    debugPrint('Params: $queryParams');

    try {
      final response = await _apiClient.get(
        ApiConstants.conversations,
        queryParameters: queryParams,
      );

      debugPrint('✅ [GET] Success: ${ApiConstants.conversations}');
      debugPrint('Response Data: ${response.data}');

      return ConversationListResponseModel.fromJson(response.data);
    } catch (e) {
      debugPrint('❌ [GET] Error at: ${ApiConstants.conversations}');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }

  Future<ConversationDoc?> createConversation({
    required String receiverId,
    String? contextType,
    String? contextId,
    String? contextModel,
  }) async {
    final String url = ApiConstants.conversations;
    final Map<String, dynamic> body = {
      'receiverId': receiverId,
      'contextType': ?contextType,
      'contextId': ?contextId,
      'contextModel': ?contextModel,
    };

    debugPrint('🚀 [POST] Request to: $url');
    debugPrint('Request Body: $body');

    try {
      final response = await _apiClient.postJson(url, data: body);

      debugPrint('✅ [POST] Success: $url');
      debugPrint('Response Data: ${response.data}');

      final data = response.data;
      if (data != null && data["data"] != null && data["data"]["attributes"] != null) {
        return ConversationDoc.fromJson(data["data"]["attributes"]);
      }
      return null;
    } catch (e) {
      debugPrint('❌ [POST] Error at: $url');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }
}
