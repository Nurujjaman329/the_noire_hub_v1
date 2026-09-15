import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';


class AddPromoScreen extends StatefulWidget {
  const AddPromoScreen({super.key});

  @override
  State<AddPromoScreen> createState() => _AddPromoScreenState();
}

class _AddPromoScreenState extends State<AddPromoScreen> {
  late final TextEditingController promoController;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    final initial = args is Map ? (args['promoCode'] as String?) ?? '' : '';
    promoController = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  void _onRedeem() {
    final code = promoController.text.trim();
    if (code.isEmpty) {
      Get.snackbar("Promo", "Please enter a promo code");
      return;
    }
    // Return code to Confirm Booking — validated/applied on POST /bookings
    Get.back(result: code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Add Promo", showBackButton: true),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 20.w),
        child: Column(
          children: [
            CustomTextField(
              controller: promoController,
              keyboardType: TextInputType.text,
              hintText: "Promo or Gift Card Code",
              contenpaddingVertical: 12.h,
            ),
            SizedBox(height: 50.h),
            CustomButton(
              onTap: _onRedeem,
              text: "Redeem",
              height: 40.h,
              textColor: const Color(0XFF000000),
              color: const Color(0xFFCADA9F),
            ),
          ],
        ),
      ),
    );
  }
}
