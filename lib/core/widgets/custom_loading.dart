import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants/app_colors.dart';
import '../utils/app_colors.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        color:AppColors.primary,
        size: 60.0.h,
      ),);
  }
}