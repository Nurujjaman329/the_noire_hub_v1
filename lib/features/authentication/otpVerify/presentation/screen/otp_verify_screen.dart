import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../controller/otp_verification_controller.dart';



class OtpVerificationScreen extends GetView<OtpVerificationController> {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "", showBackButton: true),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        // 1. Icon & Header
                        _buildHeaderIcon(),
                        SizedBox(height: 25.h),
                        CustomText(
                          text: "Verify Your Email",
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0XFF1D3826),
                        ),
                        SizedBox(height: 10.h),
                        CustomText(
                          text: "Please enter the 4-digit code sent to ${controller.email}",
                          fontSize: 14.sp,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                        SizedBox(height: 40.h),
                        // 2. OTP Input Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(4, (index) => _otpBox(index)),
                        ),
                        SizedBox(height: 40.h),
                        // 3. Verify Button (Reactive)
                        Obx(() => CustomButton(
                          text: "Verify Now",
                          color: const Color(0XFF1D3826),
                          loading: controller.isLoading.value,
                          onTap: () => controller.verify(),
                        )),
                        const Spacer(),
                        // 4. Resend Logic
                        _buildResendSection(),
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

  Widget _buildHeaderIcon() {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: const BoxDecoration(
        color: Color(0xFFD9E8B9),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.mark_email_read_outlined, size: 40.sp, color: const Color(0xFF1B3022)),
    );
  }

  Widget _buildResendSection() {
    return Center(
      child: Column(
        children: [
           CustomText(text: "Didn't receive the code?", fontSize: 14.sp, color: Color(0x4D000000)),
          TextButton(
            onPressed: () => controller.resendCode(),
            child:  CustomText(
              text: "Resend New Code",
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Color(0XFF1D3826),
            ),
          ),
        ],
      ),
    );
  }

  Widget _otpBox(int index) {
    return Container(
      width: 70.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: const Color(0xFFD9E8B9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.transparent, width: 2),
      ),
      child: Center(
        child: TextField(
          controller: controller.controllers[index],
          focusNode: controller.focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1B3022)),
          decoration: const InputDecoration(counterText: "", border: InputBorder.none),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              controller.focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              controller.focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}