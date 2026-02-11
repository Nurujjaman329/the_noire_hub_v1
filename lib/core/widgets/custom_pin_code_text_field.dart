import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../constants/app_colors.dart';


class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField({super.key,this.textEditingController});
  final TextEditingController? textEditingController;
  @override
  Widget build(BuildContext context) {
    return  PinCodeTextField(
      backgroundColor: Colors.transparent,
      cursorColor: AppColors.primary,
      controller: textEditingController,
      textStyle: TextStyle(color: Colors.black),
      autoFocus: false,
      appContext: context,
      length: 6,
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          selectedColor: AppColors.primary,
          activeFillColor: AppColors.primary,
          selectedFillColor: AppColors.geryColor,
          inactiveFillColor: AppColors.primary,
          fieldHeight: 57.h,
          fieldWidth: 44.w,
          inactiveColor: AppColors.primary,
          activeColor: AppColors.primary),
      obscureText: false,
      keyboardType: TextInputType.number,
      onChanged: (value) {},
    );
  }
}