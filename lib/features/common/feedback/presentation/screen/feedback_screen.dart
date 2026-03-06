import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:the_noire_hub_v1/core/constants/app_colors.dart';
import 'package:the_noire_hub_v1/core/widgets/custom_text_field.dart';

import '../../../../../core/widgets/custom_text.dart';
import '../../data/feedback_response_model.dart';
import '../controller/feedback_controller.dart';

class FeedbackScreen extends GetView<FeedbackController> {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText(text: "Feedback", fontSize: 18.sp, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- INPUT SECTION ---
            CustomText(text: "Subject", fontWeight: FontWeight.w600),
            SizedBox(height: 8.h),
            CustomTextField(controller: controller.subjectController,
              hintText: "Issue subject...",),


            SizedBox(height: 15.h),
            CustomText(text: "Message", fontWeight: FontWeight.w600),
            SizedBox(height: 8.h),
            CustomTextField(controller: controller.messageController, maxLines: 4,hintText: "Enter your message...",),

            SizedBox(height: 20.h),

            // --- SUBMIT BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF435B33),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onPressed: () => controller.submitFeedback(),
                child: Obx(() => controller.isSubmitting.value
                    ? SizedBox(
                  height: 20.r,
                  width: 20.r,
                  child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const CustomText(text: "Send Feedback", color: Colors.white)),
              ),
            ),

            SizedBox(height: 30.h),
            const Divider(),
            SizedBox(height: 10.h),
            CustomText(text: "Your Previous Feedback", fontSize: 16.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 15.h),

            // --- HISTORY LIST (Replaced Expanded with Obx) ---
            Obx(() {
              if (controller.isFetching.value && controller.feedbackList.isEmpty) {
                return Center(child: CircularProgressIndicator(color: AppColors.primary,));
              }
              if (controller.feedbackList.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: const Center(child: CustomText(text: "No feedback history", color: Colors.grey)),
                );
              }
              return ListView.builder(
                shrinkWrap: true, // 👈 Critical for SCSV
                physics: const NeverScrollableScrollPhysics(), // 👈 Critical for SCSV
                itemCount: controller.feedbackList.length,
                itemBuilder: (context, index) {
                  final item = controller.feedbackList[index];
                  return _buildFeedbackCard(item);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(FeedbackItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(text: item.subject, fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              _buildStatusChip(item.status),
            ],
          ),
          SizedBox(height: 6.h),
          CustomText(text: item.message, fontSize: 12.sp, color: Colors.black87),

          if (item.adminNote.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha:0.05),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: CustomText(
                  text: "Admin: ${item.adminNote}",
                  fontSize: 11.sp,
                  color: Colors.blue.shade800,
                  fontStyle: FontStyle.italic
              ),
            ),
          ],

          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomText(
              text: item.createdAt?.toLocal().toString().split(' ')[0] ?? '',
              fontSize: 10.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = status.toLowerCase() == "pending" ? Colors.orange : Colors.green;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: CustomText(
        text: status.toUpperCase(),
        fontSize: 9.sp,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}