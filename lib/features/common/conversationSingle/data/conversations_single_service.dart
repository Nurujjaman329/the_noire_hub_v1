import 'package:flutter/material.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'conversations_single_response_model.dart';

class ConversationsSingleService {
  final ApiClient _apiClient;
  ConversationsSingleService(this._apiClient);

  Future<ConversationsSingleResponseModel> getConversation({
    required String conversationId,
    int page = 1,
    int limit = 20,
  }) async {
    final String url = '${ApiConstants.conversations}/$conversationId';
    final Map<String, dynamic> queryParams = {'page': page, 'limit': limit};

    debugPrint('🚀 [GET] Request to: $url');
    debugPrint('Params: $queryParams');

    try {
      final response = await _apiClient.get(url, queryParameters: queryParams);

      debugPrint('✅ [GET] Success: $url');
      debugPrint('Response Data: ${response.data}');

      return ConversationsSingleResponseModel.fromJson(response.data);
    } catch (e) {
      debugPrint('❌ [GET] Error at: $url');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }

  Future<bool> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    final String url = '${ApiConstants.conversations}/$conversationId/messages';
    final Map<String, dynamic> body = {'text': text, 'type': 'text'};

    debugPrint('🚀 [POST] Request to: $url');
    debugPrint('Request Body: $body');

    try {
      final response = await _apiClient.postJson(url, data: body);

      debugPrint('✅ [POST] Success: $url');
      debugPrint('Response Data: ${response.data}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('❌ [POST] Error at: $url');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }
}
