
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../controller/registration_controller.dart';

class RegistrationScreen extends GetView<RegistrationController> {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 320.h,
            child: Image.asset(AppAssets.registration, fit: BoxFit.cover),
          ),
          Positioned(
            top: 50.h, left: 20.w,
            child: CircleAvatar(
              backgroundColor: Colors.black26,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                onPressed: () => Get.back(),
              ),
            ),
          ),
          Positioned.fill(
            top: 260.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              decoration:  BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomText(text: "Create TNP Account", fontSize: 20.sp, fontWeight: FontWeight.bold, top: 30.h),
                    _buildDivider("Or"),
                    GestureDetector(
                      onTap: () => Get.toNamed(RouteConstants.selection),
                      child: CustomText(text: "Earn with us", color: const Color(0XFFB5B475), fontWeight: FontWeight.bold, textDecoration: TextDecoration.underline, fontSize: 14.sp),
                    ),
                    SizedBox(height: 25.h),
                    CustomTextField(controller: controller.fullNameController, labelText: "Name"),
                    SizedBox(height: 20.h),
                    CustomTextField(controller: controller.emailController, labelText: "Email"),
                    SizedBox(height: 20.h),
                    CustomTextField(controller: controller.passwordController, labelText: "Password", isPassword: true),
                    SizedBox(height: 20.h),
                    CustomTextField(controller: controller.confirmPasswordController, labelText: "Confirm Password", isPassword: true),
                    SizedBox(height: 10.h),

                    SizedBox(height: 25.h),
                    CustomButton(
                      text: "Continue",
                      color: const Color(0XFF1D3826),
                      onTap: () {

                        if (controller.fullNameController.text.isEmpty ||
                            controller.emailController.text.isEmpty ||
                            controller.passwordController.text.isEmpty) {
                          Get.snackbar(
                            "Required Fields",
                            "Please fill in all details",
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        // 2. Check if passwords match
                        if (controller.passwordController.text != controller.confirmPasswordController.text) {
                          Get.snackbar(
                            "Password Mismatch",
                            "Passwords do not match. Please check again.",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        Get.toNamed(RouteConstants.customerAddAddress);

                      },
                    ),

                    // _buildDivider("Or"),
                    //
                    // // Social Buttons
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     _socialButton("Google", AppIcons.googleIcon),
                    //     _socialButton("Facebook", AppIcons.fbIcon),
                    //     _socialButton("Apple", AppIcons.appleIcon),
                    //   ],
                    // ),

                    SizedBox(height: 25.h),

                    // Bottom Navigation Link using CustomText
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Already have an account? ",
                          fontSize: 12.sp,
                          color: Color(0XFF000000),
                          // color: AppColors.textPrimary,
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(RouteConstants.login),
                          child: CustomText(
                            text: "Sign in",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                              color: Color(0XFFB5B475)
                            // color: AppColors.textSecondary,
                          ),
                        ),
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

  Widget _buildDivider(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          CustomText(
            text: text,
            color: Color(0x4D000000),
            // color: Colors.grey,
            fontSize: 12.sp,
            left: 10.w,
            right: 10.w,
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget _socialButton(String label, String iconPath) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(iconPath, width: 18.w, height: 18.w),
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