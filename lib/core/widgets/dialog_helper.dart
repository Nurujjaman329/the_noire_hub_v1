

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../utils/app_colors.dart';
import 'custom_text.dart';

class GlobalDialogs {
  /// Shows the Action Required Dialog for business verification
  static void showActionRequiredDialog({
    required VoidCallback onVerifyTap,
    required VoidCallback onFulfillmentTap,
    required VoidCallback onClose,
  }) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 30.w), // Ensures consistent width
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(

                  onTap: () {
                    onClose(); // Trigger the dismiss logic
                    Get.back();
                  },
                  child: Icon(Icons.close, color: AppColors.primaryDark, size: 20.sp),
                ),
              ),

              // Title
              CustomText(
                text: "Action Required",
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Color(0XFF627F2F),
                // color: AppColors.secondaryVariant,
              ),
              SizedBox(height: 15.h),

              // Subtitle
              CustomText(
                text: "You have to verify your business and set up order fulfillment before going live",
                textAlign: TextAlign.center,
                fontSize: 13.sp,
                color: Color(0xB2000000),
                // color: AppColors.geryColor,
              ),
              SizedBox(height: 25.h),

              // Verify Now Button
              _dialogButton(
                bgColor: Color(0xFF627E4C),
                text: "Verify Now",
                onTap: () {
                  Get.back();
                  onVerifyTap();
                },
              ),
              SizedBox(height: 12.h),

              // Go to Order Fulfillment Button
              _dialogButton(
                text: "Go to Order Fulfillment",
                bgColor: Color(0XFF1D3826),
                // bgColor: AppColors.primaryDark,
                onTap: () {
                  Get.back();
                  onFulfillmentTap();
                },
              ),


            ],
          ),
        ),
      ),
    );
  }

  /// Private helper widget for dialog buttons
  static Widget _dialogButton({
    required String text,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: Color(0XFF627E4C),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Center(
          child: CustomText(
            text: text,
            color: AppColors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}