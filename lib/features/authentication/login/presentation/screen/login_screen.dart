
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/accountController/account_controller.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_icons.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false; // Added for CustomButton state
  String userType = 'customer'; // Default to customer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Header Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 350.h,
            child: Image.asset(
              AppAssets.logInMan,
              fit: BoxFit.cover,
            ),
          ),

          // 2. Logo and Tagline (Stacked on the image)
          Positioned(
            top: 110.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  AppAssets.appLogo,
                  width: 150.w,
                  fit: BoxFit.contain,
                ),
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

          // 3. Main Content Container
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
                      color: Color(0XFF000000),
                      // color: AppColors.textPrimary,
                      top: 30.h,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Vendors and Beauticians ",
                          // color: AppColors.textHint,
                          color: Color(0XFF999999),
                          fontSize: 13.sp,
                          top: 8.h,
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(RouteConstants.selection),
                          child: CustomText(
                            text: "click here",
                            color: Color(0XFFB5B475),
                            // color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            textDecoration: TextDecoration.underline,
                            fontSize: 13.sp,
                            top: 8.h,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 35.h),

                    // Input Fields using direct IconData
                    CustomTextField(
                      controller: emailController,
                      labelText: "Email",
                      prefixIcon: Icons.email_outlined,
                    ),
                    SizedBox(height: 25.h),
                    CustomTextField(
                      controller: passwordController,
                      labelText: "Password",
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                    ),

                    SizedBox(height: 15.h),

                    // Options Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              color: Color(0XFF000000),
                              // color: AppColors.textHint,
                              left: 8.w,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                                RouteConstants.gmailVerification,
                                arguments: {"flow": "forgot_password"}
                            );
                          },
                          child: CustomText(
                            text: "Forgot Password",
                            color: Color(0xFFB5B475),
                            // color: AppColors.secondary,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),



                    SizedBox(height: 25.h),

                    // Sign In Button
                    CustomButton(
                      text: "Sign in",
                      color: Color(0XFF1D3826),
                      // color: AppColors.primaryDark,
                      loading: isLoading,
                      onTap: () {
                        setState(() => isLoading = true);
                        // Mock login process - in a real app, this would depend on user type
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() => isLoading = false);

                          // Get the account controller
                          final accountCtrl = Get.find<AccountController>();

                          // Navigate based on selected user type
                          if (userType == 'vendor' || userType == 'beautician') {
                            // Set the account type before navigating
                            accountCtrl.setUserType(userType);
                            Get.offAllNamed(RouteConstants.vendorMainContainer);
                          } else {
                            // Explicitly set user type to customer for customer login
                            accountCtrl.setUserType('customer');
                            Get.offAllNamed(RouteConstants.customerMainContainer);
                          }
                        });
                      },
                    ),

                    SizedBox(height: 20.h),

                    GestureDetector(
                      onTap: () => Get.toNamed(RouteConstants.registration),
                      child: CustomText(
                        text: "Create Account",
                        color: Color(0XFF1D3826),
                        // color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),

                    // Divider
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 25.h),
                      child: Row(
                        children: [
                          const Expanded(child: Divider()),
                          CustomText(
                            text: "Or Continue With",
                            // color: AppColors.textHint,
                            color: Color(0x4D000000),
                            fontSize: 12.sp,
                            left: 10.w,
                            right: 10.w,
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                    ),

                    // Social Buttons
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

  Widget _buildUserTypeOption(String label, String type) {
    bool isSelected = userType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            userType = type;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryDark : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: CustomText(
              text: label,
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

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