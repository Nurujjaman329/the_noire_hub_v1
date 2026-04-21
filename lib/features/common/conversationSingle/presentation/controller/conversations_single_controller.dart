import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/cache_service.dart';
import '../../../../../core/services/socket_service.dart' show SocketService, SocketEvents;
import '../../data/conversations_single_response_model.dart';
import '../../data/conversations_single_service.dart';

class ConversationsSingleController extends GetxController {
  final ConversationsSingleService _service;
  ConversationsSingleController(this._service);

  var isLoading = false.obs;
  var isSending = false.obs;
  var messages = <Message>[].obs;
  var conversation = Rxn<Conversation>();

  final textController = TextEditingController();
  final scrollController = ScrollController();

  String get conversationId => Get.arguments?['conversationId'] ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchConversation();
    _initSocket();
  }

  void _initSocket() {
    SocketService.connect();

    SocketService.on(SocketEvents.message, (data) {
      debugPrint('📩 [Socket] Message Received: $data');
      try {
        final raw = Map<String, dynamic>.from(data);

        // FIX: Extract "newMessage" key from the response as shown in your screenshot
        if (raw.containsKey('newMessage')) {
          final messageData = Map<String, dynamic>.from(raw['newMessage']);
          final msg = Message.fromJson(messageData);

          // Verification: Ensure message belongs to this specific chat room
          if (messageData['conversation']?.toString() == conversationId) {
            // Prevent duplicates (especially if server echoes your own message back)
            if (!messages.any((m) => m.id == msg.id)) {
              messages.add(msg);
              _scrollToBottom();
            }
          }
        }
      } catch (e) {
        debugPrint('⚠️ Socket Error/Parsing Error: $e');
      }
    });
  }

  Future<void> fetchConversation() async {
    isLoading.value = true;
    try {
      final res = await _service.getConversation(conversationId: conversationId);
      conversation.value = res.data.attributes.conversation;
      messages.assignAll(res.data.attributes.messages.results.reversed.toList());
      _scrollToBottom();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    textController.clear();
    isSending.value = true;

    // Optimistic Message with all required fields
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMsg = Message(
      id: tempId,
      text: text,
      type: 'text',
      image: '',
      seenBy: [],
      author: User(id: CacheService.userId, fullName: 'Me', image: '', role: ''),
      createdAt: DateTime.now().toIso8601String(),
    );

    messages.add(tempMsg);
    _scrollToBottom();

    final realMsg = await _service.sendMessage(conversationId: conversationId, text: text);

    if (realMsg != null) {
      int idx = messages.indexWhere((m) => m.id == tempId);
      if (idx != -1) messages[idx] = realMsg;
    } else {
      messages.removeWhere((m) => m.id == tempId);
      Get.snackbar("Error", "Failed to send message");
    }
    isSending.value = false;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    SocketService.off(SocketEvents.message);
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}