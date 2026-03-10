
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../controller/registration_controller.dart';

class VendorRegistrationScreen extends GetView<RegistrationController> {
  const VendorRegistrationScreen({super.key});
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Top Background Image
          Positioned(top: 0, left: 0, right: 0, height: 300.h, child: Image.asset(AppAssets.vendorRegistration, fit: BoxFit.cover)),

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
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r))),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: "Join TNP ${controller.userRole.value.capitalizeFirst}", fontSize: 22.sp, fontWeight: FontWeight.bold),
                        GestureDetector(
                          onTap: () => controller.pickShopImage(),
                          child: Obx(() => Container(
                            height: 50.w, width: 50.w,
                            decoration: BoxDecoration(color: const Color(0XFFB5B475), shape: BoxShape.circle,
                                image: controller.selectedShopImage.value != null
                                    ? DecorationImage(image: FileImage(controller.selectedShopImage.value!), fit: BoxFit.cover) : null),
                            child: controller.selectedShopImage.value == null ? Icon(Icons.camera_alt_outlined, color: Colors.white, size: 24.sp) : null,
                          )),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    CustomTextField(controller: controller.fullNameController, labelText: "Full Name", prefixIcon: Icons.person_outline),
                    SizedBox(height: 25.h),
                    CustomTextField(controller: controller.businessNameController, labelText: "Business Name", prefixIcon: Icons.business_outlined),
                    SizedBox(height: 25.h),
                    CustomTextField(controller: controller.emailController, labelText: "Email", prefixIcon: Icons.email_outlined),
                    SizedBox(height: 25.h),
                    CustomTextField(controller: controller.phoneController, labelText: "Phone", prefixIcon: Icons.phone_android_outlined),
                    SizedBox(height: 25.h),
                    CustomTextField(controller: controller.passwordController, labelText: "Create Password", isPassword: true, prefixIcon: Icons.lock_outline),
                    SizedBox(height: 25.h),
                    CustomTextField(controller: controller.confirmPasswordController, labelText: "Confirm Password", isPassword: true, prefixIcon: Icons.lock_reset_outlined),
                    SizedBox(height: 40.h),
                    CustomButton(
                      text: "Continue",
                      color: const Color(0XFF1D3826),
                      onTap: () => Get.toNamed(RouteConstants.storeSetUp),
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
                            onTap: () => Get.until((route) => route.settings.name == RouteConstants.login),
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