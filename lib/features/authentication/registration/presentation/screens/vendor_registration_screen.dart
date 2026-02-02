
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/accountController/account_controller.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class VendorRegistrationScreen extends StatefulWidget {
  const VendorRegistrationScreen({super.key});

  @override
  State<VendorRegistrationScreen> createState() => _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  String _accountType = "Vendors"; // Default to Vendors

  @override
  void initState() {
    super.initState();
    // Get the account type from the arguments passed from SelectionScreen
    final args = Get.arguments;
    if (args != null && args is String) {
      _accountType = args;
    }
  }
  final TextEditingController nameController = TextEditingController();
  final TextEditingController businessController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final AccountController controller = Get.find<AccountController>();

    debugPrint("Registration Screen loaded for: ${controller.userType.value}");

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Top Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300.h,
            child: Image.asset(
              AppAssets.vendorRegistration,
              fit: BoxFit.cover,
            ),
          ),

          // 2. Logo and Tagline (Stacked on the image)
          Positioned(
            top: 100.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  AppAssets.appLogo,
                  width: 150.w,
                  fit: BoxFit.contain,
                ),
                // Using CustomText for the tagline
                CustomText(
                  text: "culture meets care",
                  color: AppColors.textOnDark,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  textDecoration: TextDecoration.none,
                  top: 5.h,

                ),
              ],
            ),
          ),

          // 3. Back Button
          Positioned(
            top: 50.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Color(0x33000000),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18.sp),
              ),
            ),
          ),

          // 4. Main Form Container
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),

                    // Header Row with Camera Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Obx(() {
                          // --- NESTED DEBUG PRINT ---
                          debugPrint("Obx Rebuilding Header for: ${controller.userType.value}");

                          return CustomText(
                            text: "Join TNP ${controller.userType.value}",
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0XFF000000),
                            // color: AppColors.textPrimary,
                            textAlign: TextAlign.left,
                          );
                        }),

                        Container(
                          height: 50.w,
                          width: 50.w,
                          decoration: const BoxDecoration(
                            color: Color(0XFFB5B475),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 24.sp),
                        ),
                      ],
                    ),

                    SizedBox(height: 30.h),

                    // Input Fields using your updated CustomTextField (prefixIcon support)
                    CustomTextField(
                      controller: nameController,
                      labelText: "Full Name",
                      prefixIcon: Icons.person_outline,
                    ),
                    SizedBox(height: 25.h),
                    CustomTextField(
                      controller: businessController,
                      labelText: "Business Name",
                      prefixIcon: Icons.business_outlined,
                    ),
                    SizedBox(height: 25.h),
                    CustomTextField(
                      controller: emailController,
                      labelText: "Email",
                      prefixIcon: Icons.email_outlined,
                    ),
                    SizedBox(height: 25.h),
                    CustomTextField(
                      controller: phoneController,
                      labelText: "Phone",
                      prefixIcon: Icons.phone_android_outlined,
                    ),
                    SizedBox(height: 25.h),
                    CustomTextField(
                      controller: passwordController,
                      labelText: "Create Password",
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                    ),
                    SizedBox(height: 25.h),
                    CustomTextField(
                      controller: confirmPasswordController,
                      labelText: "Confirm Password",
                      isPassword: true,
                      prefixIcon: Icons.lock_reset_outlined,
                    ),

                    SizedBox(height: 40.h),

                    // Create Account Button using CustomButton
                    CustomButton(
                      text: "Continue",
                      color: Color(0XFF1D3826),
                      // color: AppColors.primaryDark,
                      loading: isLoading,
                      onTap: () {
                        // setState(() => isLoading = true);
                        // // Registration logic here
                        // Future.delayed(const Duration(seconds: 2), () {
                        //   setState(() => isLoading = false);
                        // });
                        // Navigate to vendor main container after registration
                        Get.toNamed(RouteConstants.storeSetUp);
                      },
                    ),

                    SizedBox(height: 20.h),

                    // Bottom Login Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Already have an account? ",
                            fontSize: 13.sp,
                            color: AppColors.textPrimary,
                          ),
                          GestureDetector(
                            onTap: () => Get.offAllNamed(RouteConstants.login),
                            child: CustomText(
                              text: "Login",
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFFB5B475),
                              // color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
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
}