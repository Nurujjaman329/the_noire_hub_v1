import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_text.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Terms & Privacy Policy",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Header
            CustomText(
              text: "THE NOIRE PLACE PRIVACY POLICY",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3E2F),
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: "Last updated April 02, 2026",
              fontSize: 13.sp,
              color: Colors.grey,
            ),
            SizedBox(height: 25.h),

            // Intro Text
            _buildSectionText(
                "This Privacy Notice for The Noire Place Inc. (doing business as TNP Beauty) (\"we,\" \"us,\" or \"our\"), describes how and why we might access, collect, store, use, and/or share (\"process\") your personal information when you use our services (\"Services\"), including when you:"
            ),

            SizedBox(height: 15.h),

            // Bullet Points
            _buildBulletPoint("Download and use our mobile application (The Noire Place), or any other application of ours that links to this Privacy Notice"),
            _buildBulletPoint("Use TNP Beauty. TNP Beauty (The Noire Place – Beauty) is the first vertical of The Noire Place, a global Afro-centric marketplace and on-demand service platform built to serve Black women, families, and culture across Canada, the U.S., the U.K., and Africa. It is designed to solve two problems at once: access to skilled Black beauty professionals locally, and access to authentic Black-owned beauty products globally."),
            _buildBulletPoint("Engage with us in other related ways, including any marketing or events"),

            SizedBox(height: 20.h),

            _buildSectionText(
                "Questions or concerns? Reading this Privacy Notice will help you understand your privacy rights and choices. We are responsible for making decisions about how your personal information is processed. If you do not agree with our policies and practices, please do not use our Services. If you still have any questions or concerns, please contact us at Anna@thenoireplace.com."
            ),

            SizedBox(height: 30.h),
            const Divider(color: Color(0xFFF1F4D3), thickness: 1),
            SizedBox(height: 20.h),

            // Summary Section
            CustomText(
              text: "SUMMARY OF KEY POINTS",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3E2F),
            ),
            SizedBox(height: 15.h),
            _buildSectionText(
                "This summary provides key points from our Privacy Notice, but you can find out more details about any of these topics by clicking the link following each key point or by using our table of contents below to find the section you are looking for."
            ),

            SizedBox(height: 40.h),
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

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 5.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "• ", fontSize: 16.sp, fontWeight: FontWeight.bold),
          Expanded(
            child: CustomText(
              text: text,
              fontSize: 14.sp,
              color: const Color(0xFF2D3E2F),
            ),
          ),
        ],
      ),
    );
  }
}