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
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryDark),
          );
        }
        return Column(
          children: [
            // Load more indicator
            Obx(() => controller.isLoadingMore.value
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryDark,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : const SizedBox.shrink()),

            // Messages list
            Expanded(
              child: Obx(() {
                if (controller.messages.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: "No messages yet.\nSay hello!",
                      fontSize: 14.sp,
                      color: AppColors.geryColor,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    final isMe = msg.author.id == CacheService.userId;

                    // Show date separator when day changes
                    final showDate = index == 0 ||
                        _isDifferentDay(
                          controller.messages[index - 1].createdAt,
                          msg.createdAt,
                        );

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

            // Input bar
            _buildInputBar(controller),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(ConversationsSingleController controller) {
    return AppBar(
      backgroundColor: AppColors.primaryDark,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
      ),
      title: Obx(() {
        final conv = controller.conversation.value;
        final other = conv?.users.isNotEmpty == true ? conv!.users.first : null;
        final imageUrl = (other?.image.isNotEmpty == true)
            ? '${ApiConstants.baseImageUrl}${other!.image}'
            : '';

        return Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.primaryContainer,
              backgroundImage:
                  imageUrl.isNotEmpty ? CachedNetworkImageProvider(imageUrl) : null,
              child: imageUrl.isEmpty
                  ? Icon(Icons.person, size: 18.sp, color: AppColors.primaryDark)
                  : null,
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: other?.fullName.isNotEmpty == true
                      ? other!.fullName
                      : 'User',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                if (conv?.contextId.name.isNotEmpty == true)
                  CustomText(
                    text: conv!.contextId.name,
                    fontSize: 10.sp,
                    color: AppColors.primary,
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDateSeparator(String createdAt) {
    final dt = DateTime.tryParse(createdAt);
    if (dt == null) return const SizedBox.shrink();

    final now = DateTime.now();
    String label;
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      label = 'Today';
    } else if (dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.day - 1) {
      label = 'Yesterday';
    } else {
      label = '${dt.day}/${dt.month}/${dt.year}';
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 0.8)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: CustomText(
              text: label,
              fontSize: 11.sp,
              color: AppColors.geryColor,
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 0.8)),
        ],
      ),
    );
  }

  Widget _buildInputBar(ConversationsSingleController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 28.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F0),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: const Color(0xFFC4C99A)),
              ),
              child: TextField(
                controller: controller.textController,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle:
                      TextStyle(color: AppColors.geryColor, fontSize: 13.sp),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Obx(() => GestureDetector(
                onTap: controller.isSending.value ? null : controller.sendMessage,
                child: Container(
                  width: 46.w,
                  height: 46.w,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryDark,
                    shape: BoxShape.circle,
                  ),
                  child: controller.isSending.value
                      ? Padding(
                          padding: EdgeInsets.all(12.r),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.send_rounded,
                          color: Colors.white, size: 20.sp),
                ),
              )),
        ],
      ),
    );
  }

  bool _isDifferentDay(String prev, String current) {
    final a = DateTime.tryParse(prev);
    final b = DateTime.tryParse(current);
    if (a == null || b == null) return false;
    return a.year != b.year || a.month != b.month || a.day != b.day;
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  String _timeLabel() {
    final dt = DateTime.tryParse(message.createdAt);
    if (dt == null) return '';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 4.h,
        bottom: 4.h,
        left: isMe ? 60.w : 0,
        right: isMe ? 0 : 60.w,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  radius: 14.r,
                  backgroundColor: AppColors.primaryContainer,
                  backgroundImage: message.author.image.isNotEmpty
                      ? CachedNetworkImageProvider(
                          '${ApiConstants.baseImageUrl}${message.author.image}')
                      : null,
                  child: message.author.image.isEmpty
                      ? Icon(Icons.person,
                          size: 14.sp, color: AppColors.primaryDark)
                      : null,
                ),
                SizedBox(width: 8.w),
              ],
              Container(
                constraints: BoxConstraints(maxWidth: 240.w),
                padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primaryDark : AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.r),
                    topRight: Radius.circular(18.r),
                    bottomLeft:
                        isMe ? Radius.circular(18.r) : Radius.circular(4.r),
                    bottomRight:
                        isMe ? Radius.circular(4.r) : Radius.circular(18.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isMe ? Colors.white : AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
              if (isMe) SizedBox(width: 4.w),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 3.h,
              left: isMe ? 0 : 36.w,
              right: isMe ? 4.w : 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: _timeLabel(),
                  fontSize: 10.sp,
                  color: AppColors.geryColor,
                ),
                if (isMe) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    message.seenBy.length > 1
                        ? Icons.done_all
                        : Icons.done,
                    size: 12.sp,
                    color: message.seenBy.length > 1
                        ? AppColors.primaryDark
                        : AppColors.geryColor,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
