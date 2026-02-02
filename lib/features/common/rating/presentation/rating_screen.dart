

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int selectedRating = 4;
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Image Section
            Stack(
              clipBehavior: Clip.none, // Allows the card to overflow the stack
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35.r),
                    bottomRight: Radius.circular(35.r),
                  ),
                  child: CustomNetworkImage(
                    imageUrl: AppAssets.vendorRegistration,
                    height: 300.h, // Adjusted height
                    width: double.infinity,
                  ),
                ),

                // Custom Back Button
                Positioned(
                  top: 50.h,
                  left: 20.w,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18.sp),
                    ),
                  ),
                ),
              ],
            ),

            // 2. The Floating Rating Card (Half-on, Half-off)
            Transform.translate(
              offset: Offset(0, -60.h), // Pulls the card 60 pixels UP onto the image
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: _buildRatingCard(),
              ),
            ),

            // Adjusted Spacing because of the translate offset
            SizedBox(height: 5.h),

            // 3. Review Text Field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Container(
                height: 150.h,
                padding: EdgeInsets.all(15.r),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: TextField(
                  controller: _reviewController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Leave a review",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30.h),

            // 4. Submit Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryVariant,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: CustomText(
                      text: "Submit",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: "Give Feedback",
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "Braids By Mia",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(width: 5.w),
              CustomText(
                text: "Knotless Braids",
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ],
          ),
          CustomText(
            text: "Delivered on November 15th 2025",
            fontSize: 11.sp,
            color: Colors.grey,
          ),
          SizedBox(height: 20.h),

          // Star Rating Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(text: "Rate", fontSize: 14.sp, fontWeight: FontWeight.bold),
              SizedBox(width: 15.w),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedRating = index + 1),
                    child: Icon(
                      Icons.star,
                      color: index < selectedRating ? const Color(0xFFC4C900) : Colors.grey.shade300,
                      size: 32.sp,
                    ),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Tip Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(text: "Add Tip", fontSize: 14.sp, fontWeight: FontWeight.bold),
              SizedBox(width: 15.w),
              Container(
                width: 150.w,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    CustomText(text: "\$ ", fontSize: 14.sp, fontWeight: FontWeight.bold),
                    Expanded(
                      child: TextField(
                        controller: _tipController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "0.00",
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}