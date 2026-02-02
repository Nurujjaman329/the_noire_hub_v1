import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';

class AddVariantSheet extends StatelessWidget {
  const AddVariantSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close, color: AppColors.geryColor)),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(10.r)),
              child: CustomText(text: "Variant Name", color: AppColors.geryColor, fontSize: 14.sp),
            ),
            SizedBox(height: 15.h),
            Container(
              padding: EdgeInsets.all(15.r),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(20.r)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.add, size: 18.sp, color: AppColors.background),
                      CustomText(text: " Add more photos", color: AppColors.background, fontSize: 13.sp),
                      const Spacer(),
                      CustomText(text: "\$ 0.00", fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Icon(Icons.image_outlined, size: 55, color: AppColors.geryColor),
                  CustomText(text: "Tap to add photos", fontSize: 12.sp, color: AppColors.geryColor),
                  SizedBox(height: 30.h),
                  Align(alignment: Alignment.centerLeft, child: CustomText(text: "0 photos added", fontSize: 11.sp, color: AppColors.background)),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            CustomButton(text: "Save Variant", color: AppColors.background, textColor: AppColors.white, onTap: () => Get.back()),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}