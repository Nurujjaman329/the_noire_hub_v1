import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/cache_service.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../data/conversations_single_response_model.dart';
import '../controller/conversations_single_controller.dart';

class ConversationsSingleScreen extends StatelessWidget {
  const ConversationsSingleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConversationsSingleController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: _buildAppBar(controller),
      body: Obx(() {
        if (controller.isLoading.value && controller.messages.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryDark));
        }
        return Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.messages.isEmpty) {
                  return Center(child: CustomText(text: "No messages yet.", color: AppColors.geryColor));
                }
                return ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    final isMe = msg.author.id == CacheService.userId;
                    final showDate = index == 0 || _isDifferentDay(controller.messages[index - 1].createdAt, msg.createdAt);

                    return Column(
                      children: [
                        if (showDate) _buildDateSeparator(msg.createdAt),
                        _MessageBubble(message: msg, isMe: isMe),
                      ],
                    );
                  },
                );
              }),
            ),
            _buildInputBar(controller),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(ConversationsSingleController controller) {
    return AppBar(
      backgroundColor: AppColors.primaryDark,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), onPressed: () => Get.back()),
      title: Obx(() {
        final conv = controller.conversation.value;
        final users = conv?.users ?? [];
        final otherUser = users.isEmpty
            ? null
            : users.firstWhere(
                (u) => u.id != CacheService.userId,
                orElse: () => users.first,
              );
        final imagePath = otherUser?.image.trim() ?? '';
        final imageUrl = imagePath.isNotEmpty
            ? '${ApiConstants.baseImageUrl}$imagePath'
            : '';

        return Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.primaryContainer,
              backgroundImage: imageUrl.isNotEmpty
                  ? CachedNetworkImageProvider(imageUrl)
                  : null,
              child: imageUrl.isEmpty
                  ? Icon(Icons.person, size: 18.sp, color: AppColors.primaryDark)
                  : null,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: (otherUser?.fullName.isNotEmpty ?? false)
                        ? otherUser!.fullName
                        : 'User',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (conv != null && conv.contextId.name.isNotEmpty)
                    CustomText(
                      text: conv.contextId.name,
                      fontSize: 10.sp,
                      color: AppColors.primary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInputBar(ConversationsSingleController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 28.h),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              decoration: InputDecoration(hintText: 'Type a message...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.r))),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: controller.sendMessage,
            child: CircleAvatar(backgroundColor: AppColors.primaryDark, child: const Icon(Icons.send, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(String date) {
    return Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 8.h), child: CustomText(text: date.split('T')[0], fontSize: 11.sp, color: AppColors.geryColor)));
  }

  bool _isDifferentDay(String a, String b) => a.split('T')[0] != b.split('T')[0];
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4.h),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primaryDark : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            message.text,
            style: TextStyle(color: isMe ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
