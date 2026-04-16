import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'controller/about_us_controller.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AboutUsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "About TNP Beauty",
        showBackButton: true,
      ),
      body: Obx(() {
        // Handle Loading State
        if (controller.isLoading.value) {
          return _buildShimmerLoading();
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchAboutUs(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(15.r),
                  child: CustomText(
                    text: "TNP Beauty",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dynamic Update Date
                      if (controller.lastUpdated.value.isNotEmpty)
                        CustomText(
                          text: "Last updated: ${controller.formattedDate}",
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),

                      SizedBox(height: 20.h),

                      // Main Dynamic Content from API
                      _buildBodyText(controller.content.value),

                      // Extra spacing at the bottom for better UX
                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Shimmer Helper
  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 30.h, width: 150.w, color: Colors.white),
            SizedBox(height: 30.h),
            Container(height: 15.h, width: 100.w, color: Colors.white),
            SizedBox(height: 20.h),
            ...List.generate(10, (index) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Container(height: 15.h, width: double.infinity, color: Colors.white),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return CustomText(
      text: text,
      fontSize: 14.sp,
      color: Colors.black87,
      textAlign: TextAlign.justify,
    );
  }
}