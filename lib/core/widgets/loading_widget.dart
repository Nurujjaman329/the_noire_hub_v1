import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants/app_colors.dart';
import '../utils/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitCircle(
            color: AppColors.primary,
            size: 40.0.h,
          ),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message!,
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ],
      ),
    );
  }
}