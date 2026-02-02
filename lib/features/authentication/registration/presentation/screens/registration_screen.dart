
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_icons.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false; // For CustomButton

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Top Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 320.h,
            child: Image.asset(
              AppImages.registration,
              fit: BoxFit.cover,
            ),
          ),

          // Back Button
          Positioned(
            top: 50.h,
            left: 20.w,
            child: CircleAvatar(
              backgroundColor: Colors.black26,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                onPressed: () => Get.back(),
              ),
            ),
          ),

          // 2. Form Container
          Positioned.fill(
            top: 260.h,
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
                    // Header using CustomText
                    CustomText(
                      text: "Create TNP Account",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF000000),
                      // color: AppColors.textPrimary,
                      top: 30.h,
                    ),

                    _buildDivider("Or"),

                    GestureDetector(
                      onTap: () => Get.toNamed(RouteConstants.selection),
                      child: CustomText(
                        text: "Earn with us",
                        color: Color(0XFFB5B475),
                        // color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        textDecoration: TextDecoration.underline,
                        fontSize: 14.sp,
                      ),
                    ),

                    SizedBox(height: 25.h),

                    // Input Fields (CustomTextField already handles its own logic)
                    CustomTextField(controller: nameController, labelText: "Name"),
                    SizedBox(height: 20.h),
                    CustomTextField(controller: emailController, labelText: "Email"),
                    SizedBox(height: 20.h),
                    CustomTextField(
                        controller: passwordController,
                        labelText: "Password",
                        isPassword: true
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                        controller: confirmPasswordController,
                        labelText: "Confirm Password",
                        isPassword: true
                    ),

                    SizedBox(height: 10.h),

                    // Remember Me
                    Row(
                      children: [
                        SizedBox(
                          height: 24.w,
                          width: 24.w,
                          child: Checkbox(
                            value: rememberMe,
                            activeColor: AppColors.primaryDark,
                            onChanged: (val) => setState(() => rememberMe = val!),
                          ),
                        ),
                        CustomText(
                          text: "Remember Me",
                          fontSize: 12.sp,
                          // color: Colors.grey,
                          color: Color(0XFF000000),
                          left: 8.w,
                        ),
                      ],
                    ),

                    SizedBox(height: 25.h),


                    CustomButton(
                      text: "Continue",
                      // color: AppColors.primaryDark,
                      color: Color(0XFF1D3826),
                      loading: isLoading,
                      onTap: () {
                        Get.toNamed(RouteConstants.customerAddAddress);
                      },
                    ),

                    _buildDivider("Or"),

                    // Social Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _socialButton("Google", AppIcons.googleIcon),
                        _socialButton("Facebook", AppIcons.fbIcon),
                        _socialButton("Apple", AppIcons.appleIcon),
                      ],
                    ),

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