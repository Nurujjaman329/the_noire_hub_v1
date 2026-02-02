import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_images.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/widgets/custom_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Maintain the 3-second delay for branding
    Timer(const Duration(seconds: 3), () {
      Get.offAllNamed(RouteConstants.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Full Screen Background Image
          Positioned.fill(
            child: Image.asset(
              AppImages.splashImage,
              fit: BoxFit.cover,
            ),
          ),

          // 2. Center Content (Logo and Tagline)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App Logo (TNP)
                Image.asset(
                  AppImages.appLogo,
                  width: 180.w,
                  fit: BoxFit.contain,
                ),

                // Using CustomText for the Tagline
                CustomText(
                  text: "culture meets care",
                  color: AppColors.textOnDark,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  top: 12.h,
                ),

                SizedBox(height: 40.h),

                // Branding Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 8.h,
                    width: 8.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryVariant, // Using new variant color
                      shape: BoxShape.circle,
                    ),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}