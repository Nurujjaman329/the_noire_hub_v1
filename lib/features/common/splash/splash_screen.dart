import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/services/cache_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/auth_role_guard.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/widgets/custom_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TextEditingController fcmCTRL = TextEditingController();
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
      if (AuthRoleGuard.isAllowed(role)) {
        AuthRoleGuard.navigateToHomeForRole(role);
      } else {
        await CacheService.clear();
        Get.offAllNamed(RouteConstants.login);
        AppSnackbar.error(AuthRoleGuard.blockedMessage(role));
      }
    } else {
      Get.offAllNamed(RouteConstants.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.splashImage, fit: BoxFit.cover),
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
