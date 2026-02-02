import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

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
                CustomText(text: "New Password", fontSize: 26.sp, fontWeight: FontWeight.bold, color: Color(0XFF1D3826),),
                CustomText(text: "Set a strong password for your account.", fontSize: 14.sp, color: AppColors.geryColor, top: 10.h),
                SizedBox(height: 40.h),
                CustomTextField(
                  controller: passController,
                  labelText: "New Password",
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: confirmPassController,
                  labelText: "Confirm Password",
                  isPassword: true,
                  prefixIcon: Icons.lock_reset_outlined,
                ),
                SizedBox(height: 40.h),
                CustomButton(
                  text: "Reset Password",
                  color: Color(0XFF1D3826),
                  onTap: () {
                    // Reset logic here
                    Get.offAllNamed(RouteConstants.login);
                    Get.snackbar("Success", "Forgot Password successfully!");

                  },
                ),
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
      decoration: const BoxDecoration(color: Color(0xFFD9E8B9), shape: BoxShape.circle),
      child: Icon(icon, size: 40.sp, color: const Color(0xFF1B3022)),
    );
  }
}