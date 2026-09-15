import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../dealsPromos/data/promo_validate_response_model.dart';
import '../../dealsPromos/presentation/controller/customer_deals_promos_controller.dart';
import '../../serviceBookingScreen/presentation/controller/service_booking_details_controller.dart';

class AddPromoScreen extends StatefulWidget {
  const AddPromoScreen({super.key});

  @override
  State<AddPromoScreen> createState() => _AddPromoScreenState();
}

class _AddPromoScreenState extends State<AddPromoScreen> {
  late final TextEditingController promoController;
  late final CustomerDealsPromosController promoCtrl;

  late final String beauticianId;
  late final double subtotal;
  AppliedPromoResult? previewResult;

  @override
  void initState() {
    super.initState();
    promoCtrl = Get.find<CustomerDealsPromosController>();

    final args = Get.arguments;
    final map = args is Map
        ? Map<String, dynamic>.from(args)
        : <String, dynamic>{};
    beauticianId = (map['beauticianId'] ?? '').toString();
    subtotal = (map['subtotal'] as num?)?.toDouble() ?? 0.0;
    final initial = (map['promoCode'] as String?) ?? '';
    promoController = TextEditingController(text: initial);

    // Prefer already-validated promo from booking controller.
    if (Get.isRegistered<ServiceBookingDetailsController>()) {
      final existing =
          Get.find<ServiceBookingDetailsController>().appliedPromo.value;
      if (existing != null) {
        previewResult = existing;
        if (promoController.text.isEmpty) {
          promoController.text = existing.code;
        }
      }
    }

    if (beauticianId.isNotEmpty) {
      promoCtrl.fetchPromos(
        createdBy: beauticianId,
        applicableFor: 'service',
      );
    }
  }

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  void _saveAndReturn(AppliedPromoResult result) {
    if (Get.isRegistered<ServiceBookingDetailsController>()) {
      Get.find<ServiceBookingDetailsController>().setAppliedPromo(result);
    }
    setState(() => previewResult = result);
    Get.back(result: result);
  }

  Future<void> _validateAndReturn([String? codeOverride]) async {
    final code = (codeOverride ?? promoController.text).trim();
    if (code.isEmpty) {
      AppSnackbar.error('Please enter a promo code', title: 'Promo');
      return;
    }
    if (beauticianId.isEmpty) {
      AppSnackbar.error(
        'Beautician info missing. Go back and try again.',
        title: 'Promo',
      );
      return;
    }

    final result = await promoCtrl.validatePromoCode(
      code: code,
      subtotal: subtotal,
      beauticianId: beauticianId,
      showSuccessSnack: true,
    );

    if (result != null && mounted) {
      _saveAndReturn(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Add Promo", showBackButton: true),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Pick an offer or paste a code. After it checks OK, we'll add it to your booking.",
              fontSize: 13.sp,
              color: Colors.black54,
            ),
            SizedBox(height: 16.h),
            if (previewResult != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
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
                        text: previewResult!.successLabel,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: const Color(0xFF1D3826),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
            ],
            CustomTextField(
              controller: promoController,
              keyboardType: TextInputType.text,
              hintText: "Promo code",
              contenpaddingVertical: 12.h,
            ),
            SizedBox(height: 16.h),
            Obx(
              () => CustomButton(
                onTap: promoCtrl.isValidating.value
                    ? () {}
                    : () => _validateAndReturn(),
                text: promoCtrl.isValidating.value
                    ? "Checking..."
                    : "Apply to booking",
                height: 44.h,
                textColor: const Color(0XFF000000),
                color: const Color(0xFFCADA9F),
              ),
            ),
            SizedBox(height: 28.h),
            CustomText(
              text: "Available offers",
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                if (promoCtrl.isListLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (promoCtrl.promoList.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: "No listed offers — paste a code above to try.",
                      fontSize: 13.sp,
                      color: Colors.black54,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: promoCtrl.promoList.length,
                  separatorBuilder: (_, _) =>
                      Divider(color: Colors.grey.shade200),
                  itemBuilder: (context, index) {
                    final promo = promoCtrl.promoList[index];
                    final selected =
                        promoController.text.trim().toUpperCase() ==
                            promo.code.toUpperCase();
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        selected
                            ? Icons.check_circle
                            : Icons.local_offer_outlined,
                        color: const Color(0xFF1D3826),
                      ),
                      title: CustomText(
                        text: promo.code,
                        fontWeight: FontWeight.bold,
                      ),
                      subtitle: CustomText(
                        text:
                            "${promo.discountPercentage}% off · min \$${promo.minPurchaseAmount}",
                        fontSize: 12.sp,
                      ),
                      trailing: CustomText(
                        text: "Use",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1D3826),
                      ),
                      onTap: promoCtrl.isValidating.value
                          ? null
                          : () {
                              promoController.text = promo.code;
                              setState(() {});
                              _validateAndReturn(promo.code);
                            },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
