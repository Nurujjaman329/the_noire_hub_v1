import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../controller/reset_password_controller.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),
                _buildIconHeader(Icons.lock_open_rounded),
                SizedBox(height: 30.h),

                CustomText(
                  text: "New Password",
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0XFF1D3826),
                ),

                CustomText(
                    text: "Set a strong password for your account.",
                    fontSize: 14.sp,
                    color: AppColors.geryColor,
                    top: 10.h
                ),

                SizedBox(height: 40.h),

                // Connected to controller.passwordController
                Obx(() => CustomTextField(
                  controller: controller.passwordController,
                  labelText: "New Password",
                  isPassword: !controller.isPasswordVisible.value,
                  prefixIcon: Icons.lock_outline,
                  suffixIcons: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                      size: 20.sp,
                    ),
                    onPressed: () => controller.togglePasswordVisibility(),
                  ),
                )),

                SizedBox(height: 20.h),

                // Connected to controller.confirmPasswordController
                Obx(() => CustomTextField(
                  controller: controller.confirmPasswordController,
                  labelText: "Confirm Password",
                  isPassword: !controller.isConfirmPasswordVisible.value,
                  prefixIcon: Icons.lock_reset_outlined,
                  suffixIcons: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                      size: 20.sp,
                    ),
                    onPressed: () => controller.toggleConfirmVisibility(),
                  ),
                )),

                SizedBox(height: 40.h),

                // Reactive button with loading state
                Obx(() => CustomButton(
                  text: "Reset Password",
                  color: const Color(0XFF1D3826),
                  loading: controller.isLoading.value,
                  onTap: () => controller.handleResetPassword(),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconHeader(IconData icon) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: const BoxDecoration(
          color: Color(0xFFD9E8B9),
          shape: BoxShape.circle
      ),
      child: Icon(icon, size: 40.sp, color: const Color(0xFF1B3022)),
    );
  }
}