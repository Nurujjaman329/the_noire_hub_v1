
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_network_image.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [

          /// 🔹 TOP CURVED BACKGROUND (FROM TOP 0)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 320.h,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(120.r),
                  bottomRight: Radius.circular(120.r),
                ),
              ),
            ),
          ),

          /// 🔹 WELCOME TEXT (MIDDLE-BOTTOM OF CURVE)
          Positioned(
            top: 110.h,
            left: 0,
            right: 0,
            child: Center(
              child: CustomText(
                text: "Welcome!",
                fontSize: 36.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.onPrimary,
              ),
            ),
          ),

          /// 🔹 MAIN WHITE CARD (STARTS BELOW CURVE)
          Positioned(
            top: 200.h, // 👈 overlaps curve nicely
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 700.h,
                width: 280.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(160.r),
                    topRight: Radius.circular(160.r),
                  ),
                ),
                child: Column(
                  children: [

                    SizedBox(height: 30.h),

                    /// 🔹 CIRCULAR IMAGE
                    Container(
                      height: 200.r,
                      width: 200.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: CustomNetworkImage(
                          imageUrl: "https://picsum.photos/400",
                          fit: BoxFit.cover, height: 40, width: 40,
                        ),
                      ),
                    ),

                    SizedBox(height: 25.h),

                    /// 🔹 STORE NAME
                    CustomText(
                      text: "Ada's Body Shop",
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),

                    SizedBox(height: 56.h),

                    /// 🔹 SETUP TEXT
                    CustomText(
                      text: "Let's set up\nyour store!",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      color: AppColors.onPrimary,
                      letterSpacing: 5,
                    ),

                    SizedBox(height: 50.h),

                    /// 🔹 CONTINUE BUTTON
                    Padding(
                      padding: EdgeInsets.only(right: 30.w, bottom: 40.h),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CustomButton(
                          text: "Continue",
                          color: AppColors.buttonSecondary,
                          textColor: AppColors.secondary,
                          fontSize: 16.sp,
                          width: 120.w,
                          height: 40.h,
                          onTap: () {
                            Get.toNamed(RouteConstants.storeSetUp);
                          },
                        ),
                      ),
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
}
