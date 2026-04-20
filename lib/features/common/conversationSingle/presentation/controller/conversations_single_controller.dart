import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/cache_service.dart';
import '../../../../../core/services/socket_service.dart';
import '../../data/conversations_single_response_model.dart';
import '../../data/conversations_single_service.dart';

class ConversationsSingleController extends GetxController {
  final ConversationsSingleService _service;
  ConversationsSingleController(this._service);

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var isSending = false.obs;
  var conversation = Rxn<Conversation>();
  var messages = <Message>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  final textController = TextEditingController();
  final scrollController = ScrollController();

  String get conversationId => Get.arguments?['conversationId'] ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchConversation();
    scrollController.addListener(_onScroll);
    _connectSocket();
  }

  @override
  void onClose() {
    _disconnectSocket();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // ── Socket ──────────────────────────────────────────────

  void _connectSocket() {
    SocketService.connect();
    SocketService.joinRoom(conversationId);

    // Listen for incoming messages in this conversation
    SocketService.on('newMessage', (data) {
      debugPrint('🔌 [Socket] newMessage received: $data');
      try {
        final message = Message.fromJson(Map<String, dynamic>.from(data));
        // Avoid duplicate: skip if same id already in list
        final alreadyExists = messages.any((m) => m.id == message.id);
        if (!alreadyExists) {
          messages.add(message);
          _scrollToBottom();
        }
      } catch (e) {
        debugPrint('🔌 [Socket] newMessage parse error: $e');
      }
    });
  }

  void _disconnectSocket() {
    SocketService.off('newMessage');
    SocketService.leaveRoom(conversationId);
  }

  // ── Data ────────────────────────────────────────────────

  void _onScroll() {
    if (scrollController.position.pixels <= 50 &&
        !isLoadingMore.value &&
        currentPage.value < totalPages.value) {
      loadMoreMessages();
    }
  }

  Future<void> fetchConversation({int page = 1}) async {
    isLoading.value = true;
    try {
      final response = await _service.getConversation(
        conversationId: conversationId,
        page: page,
      );

      final attr = response.data.attributes;
      conversation.value = attr.conversation;

      // API returns newest-first; reverse so oldest is at top
      final reversed = attr.messages.results.reversed.toList();
      messages.assignAll(reversed);

      currentPage.value = attr.messages.page;
      totalPages.value = attr.messages.totalPages;

      _scrollToBottom();
    } catch (e) {
      debugPrint('ConversationsSingleController Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreMessages() async {
    if (currentPage.value >= totalPages.value) return;
    isLoadingMore.value = true;
    try {
      final response = await _service.getConversation(
        conversationId: conversationId,
        page: currentPage.value + 1,
      );

      final attr = response.data.attributes;
      final older = attr.messages.results.reversed.toList();
      messages.insertAll(0, older);

      currentPage.value = attr.messages.page;
      totalPages.value = attr.messages.totalPages;
    } catch (e) {
      debugPrint('ConversationsSingleController loadMore Error: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    // Clear input immediately — optimistic UX
    textController.clear();

    // Add optimistic message so it appears instantly
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final optimistic = Message(
      id: tempId,
      author: User(
        id: CacheService.userId,
        fullName: CacheService.userFullName,
        image: CacheService.userImage,
        role: CacheService.role,
      ),
      text: text,
      image: '',
      type: 'text',
      seenBy: [],
      createdAt: DateTime.now().toIso8601String(),
    );
    messages.add(optimistic);
    _scrollToBottom();

    isSending.value = true;
    try {
      final success = await _service.sendMessage(
        conversationId: conversationId,
        text: text,
      );

      if (!success) {
        // Remove optimistic message if API failed
        messages.removeWhere((m) => m.id == tempId);
        Get.snackbar(
          "Error",
          "Failed to send message. Please try again.",
          backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
      // On success: socket's newMessage event will deliver the real message
      // Replace optimistic with real when it arrives (handled in _connectSocket)
    } catch (e) {
      messages.removeWhere((m) => m.id == tempId);
      Get.snackbar(
        "Error",
        "Failed to send message. Please try again.",
        backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isSending.value = false;
    }
  }

  Future<void> onRefresh() async => fetchConversation();

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
}
