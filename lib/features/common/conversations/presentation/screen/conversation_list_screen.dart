import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/cache_service.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../data/conversation_list_response_model.dart';
import '../controller/conversation_list_controller.dart';

class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConversationController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Messages",
        showBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.conversations.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryDark),
          );
        }

        if (controller.conversations.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: AppColors.primaryDark,
          onRefresh: controller.onRefresh,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemCount: controller.conversations.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              thickness: 0.8,
              color: AppColors.divider,
              indent: 80.w,
            ),
            itemBuilder: (context, index) {
              return _ConversationTile(doc: controller.conversations[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 72.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: 16.h),
          CustomText(
            text: "No Conversations Yet",
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: "Start a conversation from a product\nor service page.",
            fontSize: 13.sp,
            color: AppColors.geryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationDoc doc;

  const _ConversationTile({required this.doc});

  ConversationUser _otherUser() {
    return doc.users.isNotEmpty
        ? doc.users.first
        : ConversationUser(id: '', fullName: 'Unknown', image: '', role: '');
  }

  String _timeLabel() {
    final dt = doc.lastMessage?.createdAt ?? doc.createdAt;
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final myId = CacheService.userId;
    final other = _otherUser();
    final hasUnread = doc.hasUnread(myId);
    final lastText = doc.lastMessage?.text ?? '';
    final imageUrl = other.image.isNotEmpty
        ? '${ApiConstants.baseImageUrl}${other.image}'
        : '';

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundColor: AppColors.primaryContainer,
                  backgroundImage: imageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(imageUrl)
                      : null,
                  child: imageUrl.isEmpty
                      ? Icon(Icons.person, size: 26.sp, color: AppColors.primaryDark)
                      : null,
                ),
                if (hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryDark,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 14.w),

            // Name + last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: other.fullName.isNotEmpty ? other.fullName : 'User',
                          fontSize: 14.sp,
                          fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                          color: AppColors.textPrimary,
                          maxLines: 1,
                        ),
                      ),
                      CustomText(
                        text: _timeLabel(),
                        fontSize: 11.sp,
                        color: hasUnread ? AppColors.primaryDark : AppColors.geryColor,
                        fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  // Context label (product/service name)
                  if (doc.contextId != null && doc.contextId!.name.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(
                          doc.contextModel == 'Product'
                              ? Icons.shopping_bag_outlined
                              : Icons.spa_outlined,
                          size: 11.sp,
                          color: AppColors.secondaryVariant,
                        ),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: doc.contextId!.name,
                          fontSize: 10.sp,
                          color: AppColors.secondaryVariant,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          text: lastText.isNotEmpty ? lastText : 'No messages yet',
                          fontSize: 12.sp,
                          color: hasUnread ? AppColors.textPrimary : AppColors.geryColor,
                          fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                          maxLines: 1,
                        ),
                      ),
                      if (hasUnread) ...[
                        SizedBox(width: 8.w),
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryDark,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
