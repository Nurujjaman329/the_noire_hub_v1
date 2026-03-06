
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controller/login_controller.dart';


class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // --- Header Image ---
          Positioned(
            top: 0, left: 0, right: 0, height: 350.h,
            child: Image.asset(AppAssets.logInMan, fit: BoxFit.cover),
          ),

          // --- Logo & Tagline ---
          Positioned(
            top: 110.h, left: 0, right: 0,
            child: Column(
              children: [
                Image.asset(AppAssets.appLogo, width: 150.w, fit: BoxFit.contain),
                CustomText(
                  text: "culture meets care",
                  color: AppColors.textOnDark,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  top: 5.h,
                ),
              ],
            ),
          ),

          // --- Main Container ---
          Positioned.fill(
            top: 280.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                      text: "Sign in to TNP",
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0XFF000000),
                      top: 30.h,
                    ),
                    _buildSubHeader(),

                    SizedBox(height: 35.h),

                    // --- TextFields ---
                    CustomTextField(
                      controller: controller.emailController,
                      labelText: "Email",
                      prefixIcon: Icons.email_outlined,
                    ),
                    SizedBox(height: 25.h),
                    CustomTextField(
                      controller: controller.passwordController,
                      labelText: "Password",
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                    ),

                    SizedBox(height: 15.h),
                    _buildOptionsRow(),

                    SizedBox(height: 25.h),

                    // --- Login Button ---
                    Obx(() => CustomButton(
                      text: "Sign in",
                      color: const Color(0XFF1D3826),
                      loading: controller.isLoading.value,
                      onTap: controller.login,
                    )),

                    SizedBox(height: 20.h),

                    // --- Create Account ---
                    GestureDetector(
                      onTap: () => Get.toNamed(RouteConstants.registration),
                      child: CustomText(
                        text: "Create Account",
                        color: const Color(0XFF1D3826),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),

                    _buildSocialDivider(),

                    // --- Social Buttons ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _socialButton("Google", AppIcons.googleIcon),
                        _socialButton("Facebook", AppIcons.fbIcon),
                        _socialButton("Apple", AppIcons.appleIcon),
                      ],
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Sub Header ---
  Widget _buildSubHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: "Vendors and Beauticians ",
          color: const Color(0XFF999999),
          fontSize: 13.sp,
          top: 8.h,
        ),
        GestureDetector(
          onTap: () => Get.toNamed(RouteConstants.selection),
          child: CustomText(
            text: "click here",
            color: const Color(0XFFB5B475),
            fontWeight: FontWeight.bold,
            textDecoration: TextDecoration.underline,
            fontSize: 13.sp,
            top: 8.h,
          ),
        ),
      ],
    );
  }

  // --- Options Row ---
  Widget _buildOptionsRow() {
    // final controller = Get.find<LoginController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [


          ],
        ),
        GestureDetector(
          onTap: () => Get.toNamed(
            RouteConstants.gmailVerification,
            arguments: {"flow": "forgot_password"},
          ),
          child: CustomText(
            text: "Forgot Password",
            color: const Color(0xFFB5B475),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  // --- Divider ---
  Widget _buildSocialDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25.h),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          CustomText(
            text: "Or Continue With",
            color: const Color(0x4D000000),
            fontSize: 12.sp,
            left: 10.w,
            right: 10.w,
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  // --- Social Button ---
  Widget _socialButton(String label, String iconPath) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(iconPath, width: 20.w, height: 20.w),
          CustomText(
            text: label,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            left: 8.w,
          ),
        ],
      ),
    );
  }
}
