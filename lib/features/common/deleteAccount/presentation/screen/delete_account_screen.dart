import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../controller/delete_account_controller.dart';

class DeleteAccountScreen extends GetView<DeleteAccountController> {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          text: "Delete Account",
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.background, size: 20.sp),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),

                  // Warning Header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.redAccent,
                          size: 28.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomText(
                          text: "This action cannot be undone",
                          fontSize: 14.sp,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Description
                  CustomText(
                    text: "Deleting your account will permanently remove all your data, including:",
                    fontSize: 13.sp,
                    color: AppColors.geryColor,
                  ),
                  SizedBox(height: 12.h),

                  _buildBulletPoint("Your profile and business information"),
                  _buildBulletPoint("All products, services, and bookings"),
                  _buildBulletPoint("Earnings, wallet balance, and reviews"),
                  _buildBulletPoint("All associated data will be lost forever"),

                  SizedBox(height: 30.h),
                  Divider(color: Colors.grey.shade200),
                  SizedBox(height: 25.h),

                  // Confirmation text
                  CustomText(
                    text: "Enter your password to confirm:",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    bottom: 10.h,
                  ),

                  // Password Field
                  Obx(
                    () => CustomTextField(
                      controller: controller.passwordController,
                      labelText: "Enter your password",
                      prefixIcon: Icons.lock_outline,
                      isPassword: !controller.passwordObscure.value,
                      suffixIcons: IconButton(
                        icon: Icon(
                          controller.passwordObscure.value ? Icons.visibility : Icons.visibility_off,
                          size: 20.sp,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Delete Button
                  Obx(
                    () => CustomButton(
                      text: "Delete My Account",
                      color: Colors.redAccent,
                      loading: controller.isLoading.value,
                      onTap: _showDeleteConfirmationDialog,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Center(
                    child: CustomText(
                      text: "Once deleted, this account cannot be recovered. Please proceed with caution.",
                      fontSize: 12.sp,
                      color: AppColors.geryColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: Icon(Icons.circle, size: 6.sp, color: Colors.redAccent),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomText(
              text: text,
              fontSize: 13.sp,
              color: AppColors.geryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    if (!controller.formKey.currentState!.validate()) return;

    Get.defaultDialog(
      title: "Confirm Deletion",
      titleStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.redAccent,
      ),
      middleText: "Are you absolutely sure? This will permanently delete your account and all associated data.",
      backgroundColor: AppColors.white,
      radius: 20.r,
      textCancel: "Cancel",
      textConfirm: "Delete",
      confirmTextColor: AppColors.white,
      buttonColor: Colors.redAccent,
      onCancel: () => Get.back(),
      onConfirm: () {
        Get.back();
        controller.deleteAccount();
      },
    );
  }
}
