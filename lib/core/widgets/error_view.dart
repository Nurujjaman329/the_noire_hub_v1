import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../utils/app_colors.dart';
import 'custom_text.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onPressed;
  final String? buttonText;

  const ErrorView({
    Key? key,
    this.message = 'Something went wrong!',
    this.onPressed,
    this.buttonText = 'Retry',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            CustomText(
              text: message,
              fontSize: 16.sp,
              color: AppColors.error,
              textAlign: TextAlign.center,
            ),
            if (onPressed != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: CustomText(
                  text: buttonText!,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}