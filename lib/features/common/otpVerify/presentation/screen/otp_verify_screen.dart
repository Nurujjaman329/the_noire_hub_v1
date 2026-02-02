import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';



class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // Use a list of controllers for the 4-digit OTP
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  bool isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "",showBackButton: true,),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // BouncingScrollPhysics makes it feel premium on both iOS and Android
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),

                        // 1. Icon & Header
                        Container(
                          padding: EdgeInsets.all(15.r),
                          decoration: const BoxDecoration(
                            color: Color(0xFFD9E8B9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.mark_email_read_outlined,
                            size: 40.sp,
                            color: const Color(0xFF1B3022),
                          ),
                        ),

                        SizedBox(height: 25.h),

                        CustomText(
                          text: "Verify Your Email",
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF1D3826),
                          // color: AppColors.background,
                        ),

                        SizedBox(height: 10.h),

                        CustomText(
                          text: "Please enter the 4-digit code sent to your email address.",
                          fontSize: 14.sp,
                          color: AppColors.geryColor,
                          height: 1.5,
                        ),

                        SizedBox(height: 40.h),

                        // 2. OTP Input Fields Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(4, (index) => _otpBox(index)),
                        ),

                        SizedBox(height: 40.h),

                        // 3. Verify Button
                        CustomButton(
                          text: "Verify Now",
                          color: Color(0XFF1D3826),
                          loading: isLoading,
                          onTap: () => _verifyOtp(),
                        ),

                        // This pushes the resend logic to the bottom on tall screens
                        const Spacer(),

                        // 4. Resend Logic
                        Center(
                          child: Column(
                            children: [
                              CustomText(
                                text: "Didn't receive the code?",
                                fontSize: 14.sp,
                                color: Color(0x4D000000),
                                // color: AppColors.geryColor,
                              ),
                              TextButton(
                                onPressed: () {
                                  // Resend OTP logic
                                  Get.snackbar("Sent", "New code has been sent to your email");
                                },
                                child: CustomText(
                                  text: "Resend New Code",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFF1D3826),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h), // Bottom padding for breathing room
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

  // Styled OTP Box
  Widget _otpBox(int index) {
    return Container(
      width: 70.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: const Color(0xFFD9E8B9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: _focusNodes[index].hasFocus ? const Color(0xFF1B3022) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1B3022)),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }

  void _verifyOtp() {
    // 1. Combine the digits from the controllers
    String otp = _controllers.map((e) => e.text).join();

    // 2. Validate length
    if (otp.length < 4) {
      Get.snackbar("Incomplete", "Please enter the full 4-digit code");
      return;
    }

    // 3. Extract the flow type from arguments
    // Default to 'verification_only' if no argument is found
    final String flowType = Get.arguments?['flow'] ?? "verification_only";

    setState(() => isLoading = true);

    // 4. Simulate API Verification
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isLoading = false);

      // 5. Branching Logic based on 'flow'
      if (flowType == "forgot_password") {
        // Path: Forgot Password -> Gmail Verify -> OTP -> RESET PASSWORD
        Get.toNamed(
            RouteConstants.resetPasswordScreen,
            arguments: {"flow": "forgot_password"} // Pass it forward if needed
        );
      } else {
        // Path: Normal Signup/Login -> Gmail Verify -> OTP -> LOGIN
        Get.snackbar("Success", "Email verified successfully!");
        Get.offAllNamed(RouteConstants.vendorMainContainer);
      }
    });
  }
}