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
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    // Initialize local storage first
    await LocalStorage.init();

    // Wait for 3 seconds for branding
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is logged in
    final isLoggedIn = await _checkLoginStatus();

    if (isLoggedIn) {
      // If logged in, navigate to the appropriate main container based on role
      _navigateBasedOnRole();
    } else {
      // If not logged in, navigate to login screen
      Get.offAllNamed(RouteConstants.login);
    }
  }

  Future<bool> _checkLoginStatus() async {
    // Initialize local storage if not already done
    try {
      await LocalStorage.init();
    } catch (e) {
      // If initialization fails, try to continue anyway
      debugPrint('LocalStorage initialization error: $e');
    }

    final accessToken = LocalStorage.getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  void _navigateBasedOnRole() {
    // Get user data from local storage
    final userDataMap = LocalStorage.getUserData();

    if (userDataMap != null) {
      // Create a temporary UserModel to get the role
      try {
        final user = UserModel.fromJson(userDataMap);
        final userRole = user.role.toLowerCase();

        if (userRole.contains('customer') || userRole.contains('user')) {
          Get.offAllNamed(RouteConstants.customerMainContainer);
        } else if (userRole.contains('vendor') || userRole.contains('beautician')) {
          Get.offAllNamed(RouteConstants.vendorMainContainer);
        } else {
          // Default to customer container if role is unknown
          Get.offAllNamed(RouteConstants.customerMainContainer);
        }
      } catch (e) {
        // If there's an error parsing user data, default to login screen
        Get.offAllNamed(RouteConstants.login);
      }
    } else {
      // If no user data, default to login screen
      Get.offAllNamed(RouteConstants.login);
    }
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
              AppAssets.splashImage,
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
                  AppAssets.appLogo,
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