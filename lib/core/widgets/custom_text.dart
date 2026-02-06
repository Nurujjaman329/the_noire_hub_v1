import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? textDecoration;
  final double? letterSpacing;
  final FontStyle? fontStyle;
  final double? height;

  // Spacing properties
  final double top;
  final double bottom;
  final double left;
  final double right;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.textDecoration,
    this.letterSpacing,
    this.fontStyle,
    this.height,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 16.sp,
          color: color ?? AppColors.textPrimary,
          fontWeight: fontWeight ?? FontWeight.normal,
          decoration: textDecoration,
          letterSpacing: letterSpacing,
          fontStyle: fontStyle,
          height: height,
        ),
        textAlign: textAlign ?? TextAlign.left,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.clip,
      ),
    );
  }
}