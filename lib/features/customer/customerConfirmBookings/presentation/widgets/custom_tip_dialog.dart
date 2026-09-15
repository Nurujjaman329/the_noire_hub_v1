import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../data/booking_tip_helper.dart';

/// Owns its [TextEditingController] so it is never disposed while still mounted.
class CustomTipDialog extends StatefulWidget {
  const CustomTipDialog({super.key, this.initialTip = 0});

  final double initialTip;

  @override
  State<CustomTipDialog> createState() => _CustomTipDialogState();
}

class _CustomTipDialogState extends State<CustomTipDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialTip > 0 ? widget.initialTip.toStringAsFixed(2) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSave() {
    final parsed = BookingTipHelper.parseCustomTip(_controller.text);
    if (parsed == null) {
      Get.snackbar(
        'Tip',
        'Enter a valid tip amount',
        backgroundColor: AppColors.error,
        colorText: AppColors.onError,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.back(result: parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Custom tip",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: "Enter any amount. Leave empty for no tip.",
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: "e.g. 5.00",
                hintStyle: TextStyle(color: AppColors.textHint),
                prefixText: "\$ ",
                prefixStyle: TextStyle(color: AppColors.textPrimary),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: AppColors.iconPrimary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,
                      foregroundColor: AppColors.onButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: _onSave,
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
