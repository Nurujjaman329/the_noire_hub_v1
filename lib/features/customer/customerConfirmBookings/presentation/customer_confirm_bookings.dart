import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../dealsPromos/data/promo_validate_response_model.dart';
import '../../serviceBookingScreen/presentation/controller/service_booking_details_controller.dart';
import '../data/booking_tip_helper.dart';
import 'widgets/custom_tip_dialog.dart';

class CustomerConfirmBookings extends StatefulWidget {
  const CustomerConfirmBookings({super.key});

  @override
  State<CustomerConfirmBookings> createState() =>
      _CustomerConfirmBookingsState();
}

class _CustomerConfirmBookingsState extends State<CustomerConfirmBookings> {
  late final ServiceBookingDetailsController bookingCtrl;

  @override
  void initState() {
    super.initState();
    bookingCtrl = Get.find<ServiceBookingDetailsController>();
  }

  AppliedPromoResult? get appliedPromo => bookingCtrl.appliedPromo.value;
  double get tipAmount => bookingCtrl.tipAmount.value;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};

    final String serviceId = args['serviceId'] ?? "";
    final String serviceTitle = args['title'] ?? "Service";
    final String imageUrl = args['img'] ?? "";
    final String date = args['date'] ?? "";
    final String time = args['time'] ?? "";
    final String beauticianId = args['beauticianId'] ?? "";

    final double basePrice = args['basePrice']?.toDouble() ?? 0.0;
    final double subtotal = args['price']?.toDouble() ?? 0.0;

    final List<dynamic> displayItems = args['displayItems'] ?? [];
    final List<dynamic> bookingItems = args['bookingItems'] ?? [];

    final tip5 = BookingTipHelper.tipPercent(subtotal, 0.05);
    final tip10 = BookingTipHelper.tipPercent(subtotal, 0.10);
    final tip15 = BookingTipHelper.tipPercent(subtotal, 0.15);

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: "Confirm Booking",
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.onPrimary,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final promo = bookingCtrl.appliedPromo.value;
        final tip = bookingCtrl.tipAmount.value;
        final promoDiscount = promo?.discountAmount ?? 0.0;
        final serviceFee = AppConstants.serviceFeeFor(subtotal);
        final taxes = AppConstants.gstTaxFor(subtotal);
        final total = AppConstants.roundMoney(
          AppConstants.totalWithFeesAndTax(subtotal) + tip - promoDiscount,
        );

        return Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.r),
                    topRight: Radius.circular(50.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProviderCard(imageUrl, serviceTitle, date, time),
                      SizedBox(height: 30.h),
                      CustomText(
                        text: "Price Breakdown",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(height: 10.h),
                      _buildPriceRow(
                        serviceTitle,
                        "\$${basePrice.toStringAsFixed(2)}",
                      ),
                      ...displayItems.map(
                        (item) => _buildPriceRow(
                          item['name'] ?? "Option",
                          "+\$${(item['price'] ?? 0.0).toStringAsFixed(2)}",
                        ),
                      ),
                      _buildPriceRow(
                        "Service Fee (4%)",
                        "\$${serviceFee.toStringAsFixed(2)}",
                      ),
                      _buildPriceRow(
                        "GST/Tax (5%)",
                        "\$${taxes.toStringAsFixed(2)}",
                      ),
                      if (tip > 0)
                        _buildPriceRow(
                          "Tip",
                          "\$${tip.toStringAsFixed(2)}",
                        ),
                      if (promo != null)
                        _buildPriceRow(
                          "Promo ${promo.code}",
                          "-\$${promoDiscount.toStringAsFixed(2)}",
                        ),
                      SizedBox(height: 16.h),
                      _buildPromoCard(
                        promo: promo,
                        onTap: () => _openPromoScreen(
                          beauticianId: beauticianId,
                          subtotal: subtotal,
                        ),
                        onClear: promo != null
                            ? () => bookingCtrl.clearAppliedPromo()
                            : null,
                      ),
                      SizedBox(height: 20.h),
                      CustomText(
                        text: "Tip (optional)",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.iconPrimary,
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: BookingTipHelper.statusMessage(tip),
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          _quickTipChip(
                            label: 'No tip',
                            amount: null,
                            selected: BookingTipHelper.isNoTip(tip),
                            onTap: () => bookingCtrl.clearTip(),
                          ),
                          _quickTipChip(
                            label: '5%',
                            amount: tip5,
                            selected:
                                BookingTipHelper.matchesAmount(tip, tip5),
                            onTap: () => bookingCtrl.setTipAmount(tip5),
                          ),
                          _quickTipChip(
                            label: '10%',
                            amount: tip10,
                            selected:
                                BookingTipHelper.matchesAmount(tip, tip10),
                            onTap: () => bookingCtrl.setTipAmount(tip10),
                          ),
                          _quickTipChip(
                            label: '15%',
                            amount: tip15,
                            selected:
                                BookingTipHelper.matchesAmount(tip, tip15),
                            onTap: () => bookingCtrl.setTipAmount(tip15),
                          ),
                          _quickTipChip(
                            label: 'Other',
                            amount: null,
                            selected: BookingTipHelper.isCustomTip(
                              tip: tip,
                              tip5: tip5,
                              tip10: tip10,
                              tip15: tip15,
                            ),
                            onTap: _openCustomTipDialog,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      const Divider(
                        thickness: 3,
                        color: AppColors.secondaryVariant,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Total",
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            CustomText(
                              text: "\$${total.toStringAsFixed(2)}",
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.iconPrimary,
                            ),
                          ],
                        ),
                      ),
                      if (promo != null)
                        CustomText(
                          text: "Promo ${promo.code} will be used when you pay",
                          fontSize: 11.sp,
                          color: AppColors.iconPrimary,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            _buildPayButton(total, serviceId, bookingItems, date, time),
          ],
        );
      }),
    );
  }

  Future<void> _openCustomTipDialog() async {
    // Controller lifecycle is owned by CustomTipDialog State — do NOT dispose here.
    final result = await Get.dialog<double>(
      CustomTipDialog(initialTip: tipAmount),
      barrierDismissible: true,
    );
    if (result != null) {
      bookingCtrl.setTipAmount(result);
    }
  }

  Future<void> _openPromoScreen({
    required String beauticianId,
    required double subtotal,
  }) async {
    final result = await Get.toNamed(
      RouteConstants.addPromoScreen,
      arguments: {
        'beauticianId': beauticianId,
        'subtotal': subtotal,
        'promoCode': appliedPromo?.code,
      },
    );

    if (result is AppliedPromoResult) {
      bookingCtrl.setAppliedPromo(result);
    }
  }

  Widget _quickTipChip({
    required String label,
    required double? amount,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72.w,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.chipActive : AppColors.chipInactive,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? AppColors.iconPrimary : AppColors.cardBorder,
          ),
        ),
        child: Column(
          children: [
            CustomText(
              text: label,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.iconPrimary,
            ),
            if (amount != null) ...[
              SizedBox(height: 2.h),
              CustomText(
                text: '\$${amount.toStringAsFixed(0)}',
                fontSize: 10.sp,
                color: AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard({
    required AppliedPromoResult? promo,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    final hasPromo = promo != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: hasPromo
              ? AppColors.primary.withValues(alpha: 0.35)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: hasPromo ? AppColors.iconPrimary : AppColors.cardBorder,
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasPromo ? Icons.check_circle : Icons.local_offer_outlined,
              color: AppColors.iconPrimary,
              size: 22.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: hasPromo ? promo.successLabel : "Add promo code",
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.iconPrimary,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: hasPromo
                        ? "Ready to use on payment"
                        : "Tap to select or enter a code",
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: const Icon(
                  Icons.cancel,
                  color: AppColors.error,
                  size: 20,
                ),
              )
            else
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.navigationInactive,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderCard(
    String img,
    String title,
    String date,
    String time,
  ) {
    final formattedDateTime = "$date | $time";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: CustomNetworkImage(
            imageUrl: img,
            width: 110.w,
            height: 110.h,
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: formattedDateTime,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.cardBorder),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        text: "Edit",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(width: 5.w),
                      const Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: AppColors.iconPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  text: label,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              CustomText(
                text: amount,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.primaryContainer,
        ),
      ],
    );
  }

  Widget _buildPayButton(
    double total,
    String serviceId,
    List<dynamic> items,
    String date,
    String time,
  ) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(25.w, 10.h, 25.w, 40.h),
      child: Obx(
        () => CustomButton(
          text: bookingCtrl.isLoading.value
              ? "Processing..."
              : "Pay Now | \$${total.toStringAsFixed(2)}",
          onTap: () {
            if (bookingCtrl.isLoading.value) return;

            bookingCtrl.createBooking(
              serviceId: serviceId,
              items: List<Map<String, dynamic>>.from(items),
              date: date,
              time: time,
              tip: bookingCtrl.tipAmount.value > 0
                  ? bookingCtrl.tipAmount.value
                  : null,
              promoCode: bookingCtrl.appliedPromo.value?.code,
            );
          },
          color: AppColors.buttonPrimary,
          textColor: AppColors.textOnDark,
          fontSize: 18.sp,
        ),
      ),
    );
  }
}
