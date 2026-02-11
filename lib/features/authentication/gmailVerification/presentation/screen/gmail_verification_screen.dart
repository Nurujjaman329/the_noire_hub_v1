import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../controller/gmail_verification_controller.dart';

class GmailVerificationScreen extends GetView<GmailVerificationController> {
  const GmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Determine the flow type from arguments
    final dynamic args = Get.arguments;
    final String flowType = (args is Map) ? (args['flow'] ?? "verification") : "verification";
    final bool isForgotPassword = flowType == "forgot_password";

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: const Color(0XFF1D3826), size: 20.sp),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),

                        // Dynamic Icon Container
                        Container(
                          padding: EdgeInsets.all(15.r),
                          decoration: const BoxDecoration(
                            color: Color(0xFFD9E8B9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isForgotPassword ? Icons.lock_reset_outlined : Icons.mark_email_read_outlined,
                            size: 40.sp,
                            color: const Color(0xFF1B3022),
                          ),
                        ),

                        SizedBox(height: 25.h),

                        // Dynamic Title
                        CustomText(
                          text: isForgotPassword ? "Forgot Password?" : "Verify Email",
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0XFF1D3826),
                        ),

                        SizedBox(height: 10.h),

                        // Dynamic Subtitle
                        CustomText(
                          text: isForgotPassword
                              ? "No worries! Enter your email address below and we will send you a code to reset your password."
                              : "Enter your email address below. We will send you a verification code to confirm your account.",
                          fontSize: 14.sp,
                          color: Colors.grey,
                          height: 1.5,
                        ),

                        SizedBox(height: 40.h),

                        // Connected to Controller's emailController
                        CustomTextField(
                          controller: controller.emailController,
                          labelText: "Email Address",
                          prefixIcon: Icons.email_outlined,
                          hintText: "example@mail.com",
                        ),

                        SizedBox(height: 40.h),

                        // Dynamic Button with Loading State
                        Obx(() => CustomButton(
                          text: isForgotPassword ? "Send Reset Code" : "Send Verification Code",
                          color: const Color(0XFF1D3826),
                          loading: controller.isLoading.value,
                          onTap: () => controller.sendVerificationCode(),
                        )),

                        const Spacer(),

                        // Bottom Navigation Link
                        Center(
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: RichText(
                              text: TextSpan(
                                text: isForgotPassword ? "Remember your password? " : "Already have an account? ",
                                style: TextStyle(color: const Color(0x4D000000), fontSize: 14.sp),
                                children: [
                                  const TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                      color: Color(0XFF1D3826),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}