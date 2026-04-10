import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../constants/app_colors.dart';

class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField({
    super.key,
    this.textEditingController,
    this.onCompleted,
  });

  final TextEditingController? textEditingController;
  final Function(String)? onCompleted;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      controller: textEditingController,
      keyboardType: TextInputType.number,
      autoFocus: false,

      onCompleted: onCompleted,

      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: 57.h,
        fieldWidth: 44.w,
        activeColor: AppColors.primary,
        selectedColor: AppColors.primary,
        inactiveColor: AppColors.primary,
        activeFillColor: AppColors.geryColor,
        selectedFillColor: AppColors.geryColor,
        inactiveFillColor: AppColors.primary,
      ),

      enableActiveFill: true,
    );
  }
}