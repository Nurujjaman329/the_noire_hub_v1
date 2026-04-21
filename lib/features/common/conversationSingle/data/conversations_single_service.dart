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
  }) async {
    final response = await _apiClient.get(
      '${ApiConstants.conversations}/$conversationId',
      queryParameters: {'page': page, 'limit': 20},
    );
    return ConversationsSingleResponseModel.fromJson(response.data);
  }

  Future<Message?> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    try {
      final response = await _apiClient.postJson(
        '${ApiConstants.conversations}/$conversationId/messages',
        data: {'text': text},
      );
      return Message.fromJson(response.data['data']['attributes']);
    } catch (e) {
      debugPrint('❌ sendMessage Error: $e');
      return null;
    }
  }
}