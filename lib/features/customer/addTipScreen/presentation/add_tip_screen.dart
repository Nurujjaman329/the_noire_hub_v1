import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
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

  late final double subtotal;
  late final List<_QuickTipOption> quickTips;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args is Map) {
      subtotal = (args['subtotal'] as num?)?.toDouble() ?? 0.0;
      final initialTip = (args['tip'] as num?)?.toDouble() ?? 0.0;
      _restoreInitialSelection(initialTip);
    } else {
      subtotal = 0.0;
    }

    quickTips = [
      _QuickTipOption(amount: 0, label: 'No Tip'),
      _QuickTipOption(
        amount: AppConstants.roundMoney(subtotal * 0.05),
        label: '5%',
      ),
      _QuickTipOption(
        amount: AppConstants.roundMoney(subtotal * 0.10),
        label: '10%',
      ),
      _QuickTipOption(
        amount: AppConstants.roundMoney(subtotal * 0.15),
        label: '15%',
      ),
    ];
  }

  void _restoreInitialSelection(double initialTip) {
    if (initialTip <= 0) {
      selectedIndex = 0;
      return;
    }

    // Prefer matching a quick % option; otherwise treat as custom.
    final matches = [
      0.0,
      AppConstants.roundMoney(subtotal * 0.05),
      AppConstants.roundMoney(subtotal * 0.10),
      AppConstants.roundMoney(subtotal * 0.15),
    ];

    final matchIndex = matches.indexWhere(
      (value) => (value - initialTip).abs() < 0.01,
    );

    if (matchIndex != -1) {
      selectedIndex = matchIndex;
    } else {
      selectedIndex = -1;
      _customTipController.text = initialTip.toStringAsFixed(2);
    }
  }

  double _resolveTipAmount() {
    final customText = _customTipController.text.trim();
    if (customText.isNotEmpty) {
      return AppConstants.roundMoney(double.tryParse(customText) ?? 0.0);
    }
    if (selectedIndex >= 0 && selectedIndex < quickTips.length) {
      return quickTips[selectedIndex].amount;
    }
    return 0.0;
  }

  @override
  void dispose() {
    _customTipController.dispose();
    super.dispose();
  }

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
                final tip = quickTips[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      _customTipController.clear();
                    });
                  },
                  child: Container(
                    width: 78.w,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.cardUnselected,
                      borderRadius: BorderRadius.circular(15.r),
                      border: isSelected
                          ? Border.all(color: AppColors.secondaryVariant, width: 2)
                          : null,
                    ),
                    child: Column(
                      children: [
                        CustomText(
                          text: "+\$${tip.amount.toStringAsFixed(2)}",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 4.h),
                        CustomText(
                          text: tip.label,
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
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              hintText: "Enter Tip",
              contenpaddingVertical: 12.h,
              onChanged: (val) {
                if (val.isNotEmpty) {
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
                Get.back(result: _resolveTipAmount());
              },
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

class _QuickTipOption {
  final double amount;
  final String label;

  const _QuickTipOption({required this.amount, required this.label});
}
