import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../constants/app_colors.dart';

class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField({
    super.key,
    this.pinController,
    this.onCompleted,
  });

  final PinInputController? pinController;
  final ValueChanged<String>? onCompleted;

  @override
  Widget build(BuildContext context) {
    return MaterialPinField(
      length: 6,
      pinController: pinController,
      keyboardType: TextInputType.number,
      autoFocus: false,
      onCompleted: onCompleted,
      theme: MaterialPinTheme(
        shape: MaterialPinShape.outlined,
        cellSize: Size(44.w, 57.h),
        borderRadius: BorderRadius.circular(8),
        borderColor: AppColors.primary,
        focusedBorderColor: AppColors.primary,
        filledBorderColor: AppColors.primary,
        fillColor: AppColors.primary,
        focusedFillColor: AppColors.geryColor,
        filledFillColor: AppColors.geryColor,
      ),
    );
  }
}