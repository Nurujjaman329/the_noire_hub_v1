import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/custom_text_field.dart';


class GmailVerificationScreen extends StatefulWidget {
  const GmailVerificationScreen({super.key});

  @override
  State<GmailVerificationScreen> createState() => _GmailVerificationScreenState();
}

class _GmailVerificationScreenState extends State<GmailVerificationScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Determine the flow type
    final String flowType = Get.arguments?['flow'] ?? "verification_only";
    final bool isForgotPassword = flowType == "forgot_password";

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.background, size: 20.sp),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Forces the content to be at least as tall as the screen
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),

                        // 1. Dynamic Icon
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

                        // 2. Dynamic Title
                        CustomText(
                          text: isForgotPassword ? "Forgot Password?" : "Verify Email",
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF1D3826),
                          // color: AppColors.background,
                        ),

                        SizedBox(height: 10.h),

                        // 3. Dynamic Subtitle
                        CustomText(
                          text: isForgotPassword
                              ? "No worries! Enter your email address below and we will send you a code to reset your password."
                              : "Enter your email address below. We will send you a verification code to confirm your account.",
                          fontSize: 14.sp,
                          color: AppColors.geryColor,
                          textHeight: 1.5,
                        ),

                        SizedBox(height: 40.h),

                        CustomTextField(
                          controller: emailController,
                          labelText: "Email Address",
                          prefixIcon: Icons.email_outlined,
                          hintText: "example@mail.com",
                        ),

                        SizedBox(height: 40.h),

                        // 4. Dynamic Button Text
                        CustomButton(
                          text: isForgotPassword ? "Send Reset Code" : "Send Verification Code",
                          color: Color(0XFF1D3826),
                          loading: isLoading,
                          onTap: () {
                            if (emailController.text.isNotEmpty) {
                              _handleVerificationRequest(flowType);
                            } else {
                              Get.snackbar("Error", "Please enter your email",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white
                              );
                            }
                          },
                        ),

                        // Spacer now works because IntrinsicHeight + ConstrainedBox
                        // gives the Column a target height to fill.
                        const Spacer(),

                        Center(
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: RichText(
                              text: TextSpan(
                                text: isForgotPassword ? "Remember your password? " : "Already have an account? ",
                                style: TextStyle(color: Color(0x4D000000), fontSize: 14.sp),
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

  void _handleVerificationRequest(String flowType) {
    setState(() => isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isLoading = false);

      Get.toNamed(
          RouteConstants.otpVerifyScreen,
          arguments: {"flow": flowType}
      );

      Get.snackbar(
          "Success",
          flowType == "forgot_password"
              ? "Reset code sent to your email"
              : "Verification code sent to your email",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFD9E8B9),
          colorText: const Color(0xFF1B3022)
      );
    });
  }
}