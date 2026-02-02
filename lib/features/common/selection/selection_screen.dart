import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/accountController/account_controller.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/widgets/custom_text.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountController controller = Get.find<AccountController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Background Image (75% height)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 0.75.sh,
            child: Image.asset(
              AppAssets.selection,
              fit: BoxFit.cover,
            ),
          ),

          // 2. Back Button
          Positioned(
            top: 50.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Color(0x33000000),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18.sp),
              ),
            ),
          ),

          // 3. STACKED TEXT OVER IMAGE
          Positioned(
            top: 140.h,
            left: 24.w,
            right: 24.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Earn with",
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  textAlign: TextAlign.left,
                ),
                Row(
                  children: [
                    Image.asset(AppAssets.appLogo, height: 35.h),
                    CustomText(
                      text: "Beauty!",
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      left: 10.w,
                    ),
                  ],
                ),
                CustomText(
                  text: "We are currently onboarding\nBeauticians and Vendors",
                  fontSize: 16.sp,
                  color: AppColors.primary.withOpacity(0.9),
                  textAlign: TextAlign.left,
                  top: 20.h,
                  bottom: 25.h,
                ),

              ],
            ),
          ),

          // 4. Selection Sheet
          Positioned(
            top: 0.60.sh,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    CustomText(
                      text: "Join TNP Beauty",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      // color: AppColors.textPrimary,
                      color: Color(0XFF000000),
                      bottom: 20.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "Select Account Type",
                        fontSize: 14.sp,
                        // color: AppColors.textPrimary,
                        color: Color(0XFF000000),
                        bottom: 25.h,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSelectionCard(
                          title: "Vendors",
                          image: AppAssets.vendors,
                        ),
                        _buildSelectionCard(
                          title: "Beauticians",
                          image: AppAssets.beauticians,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({required String title, required String image}) {
    return GestureDetector(
      onTap: () {
        // 2. Access the controller to save the state
        final AccountController controller = Get.find<AccountController>();

        // --- DEBUG PRINT ADDED HERE ---
        debugPrint("User selected account type: $title");

        controller.setUserType(title.toLowerCase());

        // Double check the controller updated correctly
        debugPrint("Controller current value: ${controller.userType.value}");

        // 3. Navigate to registration
        Get.toNamed(RouteConstants.vendorRegistration);
      },
      child: Container(
        width: 155.w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.cardSelected,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(image, height: 100.h, fit: BoxFit.contain),
            CustomText(
              text: title,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              // color: AppColors.onPrimary,
              color: Color(0XFF000000),
              top: 15.h,
            ),
          ],
        ),
      ),
    );
  }
}