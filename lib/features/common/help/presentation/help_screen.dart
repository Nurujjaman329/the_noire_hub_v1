import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'controller/help_controller.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Find the controller
    final controller = Get.find<HelpController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Help",
        showBackButton: true,
      ),
      body: Obx(() {
        // 2. Handle Loading State with Shimmer
        if (controller.isLoading.value) {
          return _buildShimmerLoading();
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchHelpContent(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title
                CustomText(
                  text: "Help & Support",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3E2F),
                ),

                // Dynamic Date
                if (controller.lastUpdated.value.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  CustomText(
                    text: "Last updated: ${controller.formattedDate}",
                    fontSize: 13.sp,
                    color: Colors.grey,
                  ),
                ],

                SizedBox(height: 25.h),

                // 3. Main Dynamic Content from API
                _buildSectionText(controller.content.value),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Shimmer Helper for consistent look
  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 25.h, width: 180.w, color: Colors.white),
            SizedBox(height: 10.h),
            Container(height: 15.h, width: 120.w, color: Colors.white),
            SizedBox(height: 35.h),
            ...List.generate(12, (index) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Container(
                height: 14.h,
                width: index % 3 == 0 ? 200.w : double.infinity,
                color: Colors.white,
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return CustomText(
      text: text,
      fontSize: 14.sp,
      color: const Color(0xFF2D3E2F),
      textAlign: TextAlign.justify,
    );
  }
}