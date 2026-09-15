import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../serviceBookingScreen/presentation/controller/service_booking_details_controller.dart';

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
    double initialTip = 0.0;
    if (args is Map) {
      subtotal = (args['subtotal'] as num?)?.toDouble() ?? 0.0;
      initialTip = (args['tip'] as num?)?.toDouble() ?? 0.0;
    } else {
      subtotal = 0.0;
    }

    // Prefer tip already stored on booking controller.
    if (Get.isRegistered<ServiceBookingDetailsController>()) {
      final stored = Get.find<ServiceBookingDetailsController>().tipAmount.value;
      if (stored > 0 && initialTip <= 0) initialTip = stored;
    }

    quickTips = [
      const _QuickTipOption(amount: 0, label: 'No Tip'),
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

    _restoreInitialSelection(initialTip);
  }

  void _restoreInitialSelection(double initialTip) {
    if (initialTip <= 0) {
      selectedIndex = 0;
      return;
    }

    final matches = quickTips.map((e) => e.amount).toList();
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

  void _saveAndReturn() {
    final tip = _resolveTipAmount();
    if (Get.isRegistered<ServiceBookingDetailsController>()) {
      Get.find<ServiceBookingDetailsController>().setTipAmount(tip);
    }
    if (tip > 0) {
      AppSnackbar.success(
        'Tip \$${tip.toStringAsFixed(2)} added to booking',
        title: 'Tip added',
      );
    } else {
      AppSnackbar.info('No tip will be added', title: 'Tip');
    }
    Get.back(result: tip);
  }

  @override
  void dispose() {
    _customTipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previewTip = _resolveTipAmount();

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
            SizedBox(height: 24.h),
            CustomText(
              text: "Say thanks with a tip. It will be added to your booking total.",
              fontSize: 13.sp,
              color: Colors.black54,
            ),
            SizedBox(height: 16.h),

            if (previewTip > 0)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D3826).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFF1D3826)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF1D3826)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomText(
                        text: 'Tip \$${previewTip.toStringAsFixed(2)} ready',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: const Color(0xFF1D3826),
                      ),
                    ),
                  ],
                ),
              ),

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
                final isSelected = selectedIndex == index;
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
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.cardUnselected,
                      borderRadius: BorderRadius.circular(15.r),
                      border: isSelected
                          ? Border.all(
                              color: AppColors.secondaryVariant,
                              width: 2,
                            )
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

            SizedBox(height: 32.h),

            CustomText(
              text: "Custom",
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            SizedBox(height: 15.h),
            CustomTextField(
              controller: _customTipController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              hintText: "Enter tip amount",
              contenpaddingVertical: 12.h,
              onChanged: (val) {
                setState(() {
                  if (val.isNotEmpty) selectedIndex = -1;
                });
              },
            ),

            const Spacer(),

            CustomButton(
              text: previewTip > 0
                  ? "Add tip \$${previewTip.toStringAsFixed(2)}"
                  : "Continue without tip",
              color: AppColors.secondaryVariant,
              textColor: AppColors.onPrimary,
              onTap: _saveAndReturn,
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
