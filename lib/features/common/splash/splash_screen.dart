import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/storage/local_storage.dart';
import '../../../features/authentication/login/data/login_response_model.dart';
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
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Initialize local storage (one single reliable call)
    await LocalStorage.init();

    // 2. Wait for branding/animations (3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    // 3. Determine Navigation
    final String? token = LocalStorage.getAccessToken();
    final user = LocalStorage.getUserModel();

    if (token != null && token.isNotEmpty && user != null) {
      // User is authenticated and we have their profile
      _navigateBasedOnRole(user);
    } else {
      // Not logged in or data is corrupted/missing
      Get.offAllNamed(RouteConstants.login);
    }
  }

  void _navigateBasedOnRole(UserModel user) {
    final String userRole = user.role.toLowerCase();
    debugPrint("🚀 Navigating user with role: $userRole");

    if (userRole.contains('vendor') || userRole.contains('beautician')) {
      Get.offAllNamed(RouteConstants.vendorMainContainer);
    } else {
      // Default to customer container for 'customer', 'user', or any unknown roles
      Get.offAllNamed(RouteConstants.customerMainContainer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppAssets.splashImage,
              fit: BoxFit.cover,
            ),
          ),

          // Logo and Tagline
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppAssets.appLogo,
                  width: 180.w,
                  fit: BoxFit.contain,
                ),
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
                  children: List.generate(
                    3,
                        (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      height: 8.h,
                      width: 8.w,
                      decoration: const BoxDecoration(
                        color: Color(0XFFCADA9F),
                        shape: BoxShape.circle,
                      ),
                    ),
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