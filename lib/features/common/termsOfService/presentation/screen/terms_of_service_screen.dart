import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../controller/terms_of_service_controller.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TermsOfServiceController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Terms & Privacy Policy",
        showBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerLoading();
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchTermsAndConditions(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dynamic Title (Optional: if title comes from API, map it here)
                CustomText(
                  text: "THE NOIRE PLACE PRIVACY POLICY",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3E2F),
                ),
                SizedBox(height: 8.h),

                // --- DYNAMIC DATE ---
                if (controller.lastUpdated.value.isNotEmpty)
                  CustomText(
                    text: "Last updated ${controller.formattedDate}",
                    fontSize: 13.sp,
                    color: Colors.grey,
                  ),

                SizedBox(height: 25.h),

                // --- DYNAMIC CONTENT ---
                _buildSectionText(controller.content.value),

                SizedBox(height: 30.h),
                const Divider(color: Color(0xFFF1F4D3), thickness: 1),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Helper for Shimmer Loading
  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 30.h, width: 250.w, color: Colors.white),
            SizedBox(height: 10.h),
            Container(height: 15.h, width: 150.w, color: Colors.white),
            SizedBox(height: 40.h),
            ...List.generate(8, (index) => Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: Container(height: 15.h, width: double.infinity, color: Colors.white),
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