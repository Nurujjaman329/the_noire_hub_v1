import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(text: "Change Password", fontSize: 18.sp, fontWeight: FontWeight.bold),
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
                CustomTextField(
                  controller: oldPasswordController,
                  labelText: "Enter old password",
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                ),

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
                CustomTextField(
                  controller: newPasswordController,
                  labelText: "Enter new password",
                  prefixIcon: Icons.vpn_key_outlined,
                  isPassword: true,
                ),

                SizedBox(height: 20.h),

                // 3. Confirm Password Field
                CustomText(
                  text: "Confirm New Password",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  bottom: 10.h,
                ),
                CustomTextField(
                  controller: confirmPasswordController,
                  labelText: "Re-type new password",
                  prefixIcon: Icons.lock_reset_outlined,
                  isPassword: true,
                ),

                SizedBox(height: 40.h),

                // 4. Update Button
                CustomButton(
                  text: "Update Password",
                  color: const Color(0xFF1B3022), // Dark Forest Green
                  loading: isLoading,
                  onTap: () => _handleChangePassword(),
                ),

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

  void _handleChangePassword() {
    String oldPass = oldPasswordController.text.trim();
    String newPass = newPasswordController.text.trim();
    String confirmPass = confirmPasswordController.text.trim();

    // Validation logic
    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar("Required", "All fields must be filled", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar("Error", "New passwords do not match", backgroundColor: Colors.orangeAccent, colorText: Colors.white);
      return;
    }

    if (oldPass == newPass) {
      Get.snackbar("No Change", "New password cannot be the same as the old one", backgroundColor: Colors.blueAccent, colorText: Colors.white);
      return;
    }

    setState(() => isLoading = true);

    // Simulate API process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isLoading = false);

      Get.back(); // Return to Profile/Settings

      Get.snackbar(
        "Success",
        "Password updated successfully",
        backgroundColor: const Color(0xFFD9E8B9),
        colorText: const Color(0xFF1B3022),
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }
}