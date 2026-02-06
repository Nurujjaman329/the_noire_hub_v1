import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_text.dart';


class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "About TNP Beauty",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomText(
                text: "TNP Beauty",
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),

                  // 2. Main Mission Statement
                  _buildBoldIntro(
                      "TNP Beauty is more than a booking platform — it is a cultural ecosystem built to center Black beauty, craftsmanship, and convenience."
                  ),

                  SizedBox(height: 20.h),

                  // 3. The Problem Section
                  _buildBodyText(
                      "For years, finding skilled Afro-beauty professionals has depended on word of mouth, scattered Instagram pages, or unreliable directories. Clients often struggle to discover trusted stylists, makeup artists, nail techs, and skincare specialists in one place, while beauty professionals face fragmented demand and limited digital tools."
                  ),

                  SizedBox(height: 15.h),

                  _buildBodyText(
                      "At the same time, many Black-owned beauty retailers remain invisible in mainstream marketplaces, making it difficult for customers to access authentic products designed for textured hair and melanated skin."
                  ),

                  SizedBox(height: 20.h),

                  // 4. The Solution Highlight
                  _buildHighlightBox("TNP Beauty exists to close this gap."),

                  SizedBox(height: 20.h),

                  _buildBodyText(
                      "We are creating a unified, global marketplace where Afro-beauty services and products are easy to find, book, and deliver — locally and across borders. Through our platform, clients can discover vetted professionals, view portfolios, and book with confidence."
                  ),

                  SizedBox(height: 30.h),

                  // 5. The Vision Section
                  CustomText(
                    text: "The gap we are closing",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3E2F),
                  ),
                  SizedBox(height: 15.h),

                  _buildBulletItem("Fragmented discovery: No single, reliable home for Afro-beauty"),
                  _buildBulletItem("Invisibility: Making Black-owned beauty retailers global"),
                  _buildBulletItem("Digital Tools: Empowering professionals with better growth infrastructure"),

                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildBoldIntro(String text) {
    return CustomText(
      text: text,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF2D3E2F),
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

  Widget _buildHighlightBox(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4D3).withValues(alpha:0.5),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFC4C99A)),
      ),
      child: CustomText(
        text: text,
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF707E5F),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: const Color(0xFF707E5F), size: 18.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomText(
              text: text,
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}