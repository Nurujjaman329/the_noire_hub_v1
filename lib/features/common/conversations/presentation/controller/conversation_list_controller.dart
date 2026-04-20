import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/conversation_list_response_model.dart';
import '../../data/conversation_list_service.dart';

class ConversationController extends GetxController {
  final ConversationListService _service;
  ConversationController(this._service);

  var isLoading = false.obs;
  var isCreating = false.obs;
  var conversations = <ConversationDoc>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  Future<void> fetchConversations({int page = 1}) async {
    isLoading.value = true;
    try {
      final response = await _service.getConversations(page: page);

      if (response.data?.attributes != null) {
        final attr = response.data!.attributes!;
        if (page == 1) {
          conversations.assignAll(attr.results);
        } else {
          conversations.addAll(attr.results);
        }
        currentPage.value = attr.page;
        totalPages.value = attr.totalPages;
      }
    } catch (e) {
      debugPrint("ConversationController Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<ConversationDoc?> startConversation({
    required String receiverId,
    String? contextType,
    String? contextId,
    String? contextModel,
  }) async {
    isCreating.value = true;
    try {
      final conversation = await _service.createConversation(
        receiverId: receiverId,
        contextType: contextType,
        contextId: contextId,
        contextModel: contextModel,
      );
      if (conversation != null) {
        final exists = conversations.any((c) => c.id == conversation.id);
        if (!exists) conversations.insert(0, conversation);
      }
      return conversation;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not start conversation. Please try again.",
        backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return null;
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> onRefresh() async => fetchConversations(page: 1);
}
