

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/custom_text_field.dart';

class AddTipScreen extends StatefulWidget {
  const AddTipScreen({super.key});

  @override
  State<AddTipScreen> createState() => _AddTipScreenState();
}

class _AddTipScreenState extends State<AddTipScreen> {
  final TextEditingController _customTipController = TextEditingController();
  int selectedIndex = -1;

  final List<Map<String, String>> quickTips = [
    {"amount": r"+$0.00", "label": "No Tip"},
    {"amount": "+\$5.00", "label": "5%"},
    {"amount": "+\$10.00", "label": "10%"},
    {"amount": "+\$15.00", "label": "15%"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Add Tip",
        showBackButton: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),

            // 1. Quick Tip Section
            CustomText(
              text: "Quick",
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(quickTips.length, (index) {
                bool isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      _customTipController.clear(); // Clear custom if quick is picked
                    });
                  },
                  child: Container(
                    width: 78.w,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.cardUnselected,
                      borderRadius: BorderRadius.circular(15.r),
                      border: isSelected ? Border.all(color: AppColors.secondaryVariant, width: 2) : null,
                    ),
                    child: Column(
                      children: [
                        CustomText(
                          text: quickTips[index]["amount"]!,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 4.h),
                        CustomText(
                          text: quickTips[index]["label"]!,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 40.h),

            // 2. Custom Tip Section
            CustomText(
              text: "Custom",
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,

            ),
            SizedBox(height: 15.h),
            CustomTextField(
              controller: _customTipController,
              keyboardType: TextInputType.number,
              hintText: "Enter Tip",
              // Using custom padding to match your previous design
              contenpaddingVertical: 12.h,
              onChanged: (val) {
                if (val != null && val.isNotEmpty) {
                  setState(() => selectedIndex = -1);
                }
              },
            ),

            const Spacer(),

            // 3. Save Button
            CustomButton(
              text: "Save",
              color: AppColors.secondaryVariant,
              textColor: AppColors.onPrimary,
              onTap: () {
                // Logic to save tip
                Get.back();
              },
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}