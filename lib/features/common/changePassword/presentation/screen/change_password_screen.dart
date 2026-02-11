import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
            text: "Change Password",
            fontSize: 18.sp,
            fontWeight: FontWeight.bold
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),

                // 1. Old Password Field
                CustomText(
                  text: "Current Password",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  bottom: 10.h,
                ),
                Obx(() => CustomTextField(
                  controller: controller.oldPasswordController,
                  labelText: "Enter old password",
                  prefixIcon: Icons.lock_outline,
                  isPassword: !controller.isOldVisible.value,
                  suffixIcons: IconButton(
                    icon: Icon(
                      controller.isOldVisible.value ? Icons.visibility : Icons.visibility_off,
                      size: 20.sp,
                    ),
                    onPressed: () => controller.toggleOldVisibility(),
                  ),
                )),

                SizedBox(height: 25.h),
                Divider(color: Colors.grey.shade200),
                SizedBox(height: 25.h),

                // 2. New Password Field
                CustomText(
                  text: "New Password",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  bottom: 10.h,
                ),
                Obx(() => CustomTextField(
                  controller: controller.newPasswordController,
                  labelText: "Enter new password",
                  prefixIcon: Icons.vpn_key_outlined,
                  isPassword: !controller.isNewVisible.value,
                  suffixIcons: IconButton(
                    icon: Icon(
                      controller.isNewVisible.value ? Icons.visibility : Icons.visibility_off,
                      size: 20.sp,
                    ),
                    onPressed: () => controller.toggleNewVisibility(),
                  ),
                )),

                SizedBox(height: 20.h),

                // 3. Confirm Password Field
                CustomText(
                  text: "Confirm New Password",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  bottom: 10.h,
                ),
                Obx(() => CustomTextField(
                  controller: controller.confirmPasswordController,
                  labelText: "Re-type new password",
                  prefixIcon: Icons.lock_reset_outlined,
                  isPassword: !controller.isConfirmVisible.value,
                  suffixIcons: IconButton(
                    icon: Icon(
                      controller.isConfirmVisible.value ? Icons.visibility : Icons.visibility_off,
                      size: 20.sp,
                    ),
                    onPressed: () => controller.toggleConfirmVisibility(),
                  ),
                )),

                SizedBox(height: 40.h),

                // 4. Update Button (Reactive)
                Obx(() => CustomButton(
                  text: "Update Password",
                  color: const Color(0xFF1B3022),
                  loading: controller.isLoading.value,
                  onTap: () => controller.handleChangePassword(),
                )),

                SizedBox(height: 20.h),

                Center(
                  child: CustomText(
                    text: "Make sure your new password is at least 8 characters long and includes a mix of letters and numbers.",
                    fontSize: 12.sp,
                    color: AppColors.geryColor,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}