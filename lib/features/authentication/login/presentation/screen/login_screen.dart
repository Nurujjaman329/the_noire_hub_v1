
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../controller/login_controller.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final LoginController controller;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    controller = Get.find<LoginController>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // --- Header Image ---
          Positioned(
            top: 0, left: 0, right: 0, height: 350.h,
            child: Image.asset(AppAssets.logInMan, fit: BoxFit.cover),
          ),

          // --- Logo & Tagline ---
          Positioned(
            top: 110.h, left: 0, right: 0,
            child: Column(
              children: [
                Image.asset(AppAssets.appLogo, width: 150.w, fit: BoxFit.contain),
                CustomText(
                  text: "culture meets care",
                  color: AppColors.textOnDark,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  top: 5.h,
                ),
              ],
            ),
          ),

          // --- Main Container ---
          Positioned.fill(
            top: 280.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    CustomText(
                      text: "Sign in to TNP",
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0XFF000000),
                      top: 30.h,
                    ),
                    _buildSubHeader(),

                    SizedBox(height: 35.h),

                    // --- TextFields ---
                    CustomTextField(
                      controller: _emailController,
                      labelText: "Email",
                      prefixIcon: Icons.email_outlined,
                    ),
                    SizedBox(height: 25.h),
                    CustomTextField(
                      controller: _passwordController,
                      labelText: "Password",
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                    ),

                    SizedBox(height: 15.h),
                    _buildOptionsRow(),

                    SizedBox(height: 25.h),

                    // --- Login Button ---
                    Obx(() => CustomButton(
                      text: "Sign in",
                      color: const Color(0XFF1D3826),
                      loading: controller.isLoading.value,
                      onTap: () => controller.login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      ),
                    )),

                    SizedBox(height: 20.h),

                    // --- Create Account ---
                    GestureDetector(
                      onTap: () => Get.toNamed(RouteConstants.registration),
                      child: CustomText(
                        text: "Create Account",
                        color: const Color(0XFF1D3826),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
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

  // --- Sub Header ---
  Widget _buildSubHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: "Vendors and Beauticians ",
          color: const Color(0XFF999999),
          fontSize: 13.sp,
          top: 8.h,
        ),
        GestureDetector(
          onTap: () => Get.toNamed(RouteConstants.selection),
          child: CustomText(
            text: "click here",
            color: const Color(0XFFB5B475),
            fontWeight: FontWeight.bold,
            textDecoration: TextDecoration.underline,
            fontSize: 13.sp,
            top: 8.h,
          ),
        ),
      ],
    );
  }

  // --- Options Row ---
  Widget _buildOptionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [


          ],
        ),
        GestureDetector(
          onTap: () => Get.toNamed(
            RouteConstants.gmailVerification,
            arguments: {"flow": "forgot_password"},
          ),
          child: CustomText(
            text: "Forgot Password",
            color: const Color(0xFFB5B475),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
