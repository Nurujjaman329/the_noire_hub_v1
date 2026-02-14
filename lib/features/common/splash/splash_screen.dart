import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/widgets/custom_text.dart';

import '../../../../core/services/cache_service.dart';

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
    // 1. Initialize CacheService (Uses SharedPreferences internally)
    await CacheService.init();

    // 2. Wait for branding/animations (3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    // 3. Determine Navigation based on simple strings
    final String token = CacheService.token;
    final String role = CacheService.role;

    if (token.isNotEmpty && role.isNotEmpty) {
      // User is authenticated and we know their role
      _navigateBasedOnRole(role);
    } else {
      // Not logged in or cache was cleared
      Get.offAllNamed(RouteConstants.login);
    }
  }

  void _navigateBasedOnRole(String role) {
    final String userRole = role.toLowerCase();
    debugPrint("🚀 Navigating user with role: $userRole");

    if (userRole.contains('vendor') || userRole.contains('beautician')) {
      Get.offAllNamed(RouteConstants.vendorMainContainer);
    } else {
      // Default to customer container for 'user/customer'
      Get.offAllNamed(RouteConstants.customerMainContainer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.splashImage,
              fit: BoxFit.cover,
            ),
          ),
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