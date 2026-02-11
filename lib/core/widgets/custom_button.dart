import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.color,
    this.textColor,
    this.broderColor,
    this.textStyle,
    this.padding = EdgeInsets.zero,
     this.onTap,
    required this.text,
    this.loading = false,
    this.width,
    this.fontSize,
    this.height,
    this.borderRadius, // Added borderRadius parameter
  });

  final Function()? onTap;
  final String text;
  final bool loading;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? borderRadius; // New
  final Color? color;
  final Color? textColor;
  final Color? broderColor;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          // Uses buttonPrimary if color is null
          disabledBackgroundColor: (color ?? AppColors.buttonPrimary).withValues(alpha:0.6),
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1.w,
                color: loading
                    ? (broderColor ?? Colors.transparent)
                    : (broderColor ?? Colors.transparent)
            ),
            // Match the app's 15.r rounded style by default
            borderRadius: BorderRadius.circular(borderRadius ?? 15.r),
          ),
          backgroundColor: color ?? Color(0XFF1D3826),
          minimumSize: Size(width ?? Get.width, height ?? 53.h),
          elevation: 0, // Keeps it flat to match your current UI
        ),
        child: loading
            ? SizedBox(
          height: 20.h,
          width: 20.h,
          child: CircularProgressIndicator(
            color: textColor ?? AppColors.onButton,
            strokeWidth: 2.w,
          ),
        )
            : CustomText(
          text: text,
          fontWeight: FontWeight.bold, // Switched to bold for better visibility
          fontSize: fontSize ?? 16.sp,
          color: textColor ?? AppColors.onButton,
        ),
      ),
    );
  }
}