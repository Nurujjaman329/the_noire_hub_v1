

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/accountController/account_controller.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/dialog_helper.dart';

class VendorBillingSection extends StatelessWidget {
  const VendorBillingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountController accountCtrl = Get.find<AccountController>();

    return Scaffold(
      backgroundColor: Color(0XFF627E4C),
      // backgroundColor: AppColors.secondaryVariant,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          // 1. Pinned Header
          SliverAppBar(
            expandedHeight: 180.h,
            backgroundColor: Color(0XFF627E4C),
            // backgroundColor: AppColors.secondaryVariant,
            automaticallyImplyLeading: false,
            elevation: 0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 18.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    CustomNetworkImage(
                      imageUrl: AppImages.appLogo,
                      height: 60.h,
                      width: 150.w,
                      fit: BoxFit.contain,
                    ),
                    const Spacer(),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),

          // 2. Scrolling Content Area
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CustomText(
                        text: "Ada’s Body Shop",
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    CustomText(
                      text: "Payments",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF1D3826),
                      // color: AppColors.primaryDark,
                    ),
                    CustomText(
                      text: "Add payout information",
                      fontSize: 12.sp,
                      color: Color(0XFF627E4C),
                      // color: AppColors.geryColor,
                    ),

                    SizedBox(height: 25.h),

                    _buildSectionLabel("Your billing country"),
                    _buildSelectionDropdown("Canada (CAN)"),

                    SizedBox(height: 20.h),

                    _buildSectionLabel("Payout Method"),
                    _buildSelectionDropdown("Direct Deposit"),

                    SizedBox(height: 30.h),

                    CustomText(
                      text: "Recommended",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF000000),
                      // color: AppColors.primaryDark,
                    ),
                    SizedBox(height: 12.h),

                    _buildStripeCard(),

                    SizedBox(height: 50.h),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
          text: label,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        color: Color(0XFF000000),
          // color: AppColors.primaryDark
      ),
    );
  }

  Widget _buildSelectionDropdown(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Color(0XFF9BB575),
        // color: AppColors.secondaryVariant.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: value, color: AppColors.white, fontWeight: FontWeight.w500),
          Icon(Icons.keyboard_arrow_down, color: AppColors.white),
        ],
      ),
    );
  }

  Widget _buildStripeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: Color(0XFFD7EBB8),
        // color: AppColors.secondaryVariant.withOpacity(0.15), // Soft brand tint
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        children: [
          CustomText(
            text: "Stripe",
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
          SizedBox(height: 15.h),
          CustomText(
            text: "Connect your account to Stripe for easier\nand more seamless payments",
            textAlign: TextAlign.center,
            fontSize: 12.sp,
            color: Color(0XFF000000),
            // color: AppColors.geryColor,
            textHeight: 1.4,
          ),
          SizedBox(height: 25.h),

          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                elevation: 0,
              ),
              child: CustomText(
                text: "Connect your account",
                color: AppColors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 15.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontSize: 10.sp, color: Colors.black45),
              children: [
                const TextSpan(text: "By connecting to Stripe, you agree to their ",style: TextStyle(color: Color(0XFF000000))),
                TextSpan(
                  text: "terms",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      decoration: TextDecoration.underline
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}