import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../constants/app_colors.dart';


class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField({super.key, this.textEditingController});
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return MaterialPinField(
      pinController: textEditingController != null
          ? PinInputController(textController: textEditingController)
          : null,
      length: 6,
      theme: MaterialPinTheme(
        shape: MaterialPinShape.filled,
        borderRadius: BorderRadius.circular(8),
        cellSize: Size(44.w, 57.h),
        borderColor: AppColors.primary,
        focusedBorderColor: AppColors.primary,
        fillColor: AppColors.primary,
        focusedFillColor: AppColors.geryColor,
        followingFillColor: AppColors.primary,
        followingBorderColor: AppColors.primary,
        textStyle: TextStyle(color: Colors.black),
        cursorColor: AppColors.primary,
      ),
      keyboardType: TextInputType.number,
      autoFocus: false,
      onCompleted: (pin) {},
    );
  }
}