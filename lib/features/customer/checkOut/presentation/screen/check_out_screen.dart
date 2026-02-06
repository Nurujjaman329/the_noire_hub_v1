import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isDelivery = true;
  String selectedSpeed = "Standard";
  int selectedDateIndex = 2; // Default to Oct 10 as per design

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: "Checkout",
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),

            // 1. Delivery/Pickup Toggle
            Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  _toggleButton("Delivery", isDelivery),
                  _toggleButton("Pickup", !isDelivery),
                ],
              ),
            ),

            SizedBox(height: 25.h),

            // --- PICKUP SPECIFIC UI ---
            if (!isDelivery) ...[
              Row(
                children: [
                  Icon(Icons.alarm, size: 24.sp, color: AppColors.iconPrimary),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Schedule Pickup", fontSize: 14.sp, fontWeight: FontWeight.bold),
                      CustomText(text: "Pickup Available From October 10 2025", fontSize: 11.sp, color: AppColors.geryColor),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(7, (index) {
                    bool isSelected = selectedDateIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedDateIndex = index),
                      child: Container(
                        margin: EdgeInsets.only(right: 10.w),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? AppColors.primaryDark : AppColors.dividerVariant,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          children: [
                            CustomText(
                                text: "Oct",
                                fontSize: 10.sp,
                                color: isSelected ? AppColors.textPrimary : AppColors.geryColor
                            ),
                            CustomText(
                                text: "${8 + index}",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 20.h),
              _buildListTile(Icons.phone_outlined, "+1 500-500-5000", null),
              SizedBox(height: 25.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 24.sp, color: AppColors.iconPrimary),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "Details", fontSize: 14.sp, fontWeight: FontWeight.bold),
                        SizedBox(height: 8.h),
                        CustomText(text: "Ada's Body Shop", fontSize: 14.sp, fontWeight: FontWeight.bold),
                        CustomText(
                          text: "17 Binder Lane, NW, Block 52, Edmonton, AB. T2L0Z5",
                          fontSize: 11.sp,
                          color: AppColors.geryColor,
                          textAlign: TextAlign.start,
                        ),
                        CustomText(text: "About 10.5 km away", fontSize: 10.sp, color: AppColors.geryColor),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(text: "10/10/2025", fontSize: 10.sp),
                      CustomText(text: "Open 9 am to 9 pm", fontSize: 10.sp, color: AppColors.geryColor),
                      CustomText(text: "+1 587 597 5997", fontSize: 10.sp, color: AppColors.geryColor),
                    ],
                  )
                ],
              ),
            ],

            // --- DELIVERY SPECIFIC UI ---
            if (isDelivery) ...[
              _buildListTile(Icons.location_on_outlined, "72 Poplar Ave", "Welland, Ontario L2M 4M5"),
              SizedBox(height: 20.h),
              CustomText(text: "Delivery Instructions", fontSize: 14.sp, fontWeight: FontWeight.w600,color: Color(0XFF000000)),
              SizedBox(height: 10.h),
              Container(
                height: 100.h,
                width: double.infinity,
                padding: EdgeInsets.all(15.r),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: CustomText(
                  text: "Add details here",
                  color: AppColors.geryColor,
                  fontSize: 12.sp,
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 20.sp, color: Color(0XFF000000)),
                      SizedBox(width: 8.w),
                      CustomText(text: "Estimated Delivery Time", fontSize: 14.sp, fontWeight: FontWeight.w600,color: Color(0XFF000000)),
                    ],
                  ),
                  CustomText(text: "2 - 6 days", fontSize: 14.sp, fontWeight: FontWeight.bold),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _speedCard("Turbo", "1 - 3 days", "\$9.00", true),
                  _speedCard("Standard", "2 - 6 days", "\$10.00", false),
                  _speedCard("Basic", "4 - 10 days", "\$6.00", false),
                ],
              ),
              SizedBox(height: 20.h),
              _buildListTile(Icons.phone_outlined, "+1 500-500-5000", null),
            ],

            // --- COMMON SUMMARY SECTION ---
            SizedBox(height: 30.h),
            CustomText(text: "Summary", fontSize: 22.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 15.h),
            _buildSummaryRow(Icons.storefront, isDelivery ? "Skie Homemade Care Products | 4 items" : "Ada's Body Shop | 4 items", onTap: (){}),

            // Clickable Promo Code
            _buildSummaryRow(
                Icons.brightness_5_outlined,
                "Add Promo Code",
                onTap: () => Get.toNamed(RouteConstants.addPromoScreen)
            ),

            // Clickable Tip
            _buildSummaryRow(
                Icons.payments_outlined,
                "Add a Tip | \$3.80 | 5% of subtotal",
                onTap: () => Get.toNamed(RouteConstants.addTipScreen)
            ),

            SizedBox(height: 25.h),
            _priceRow("Subtotal", "76.00"),
            _priceRow("Promotions", "-0.00"),
            _priceRow("Delivery Fee", "2.00"),
            _priceRow("Tip", "3.80"),
            _priceRow("Taxes & Other Fees", "9.28"),

            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "Total", fontSize: 18.sp, fontWeight: FontWeight.bold),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(text: "\$91.08", fontSize: 18.sp, fontWeight: FontWeight.bold),
                    CustomText(text: "with TNP Star \$86.28", fontSize: 10.sp, color: Color(0XFF93972E), fontWeight: FontWeight.bold),
                  ],
                ),
              ],
            ),

            SizedBox(height: 25.h),
            _buildListTile(Icons.credit_card, "Amina ....3982", null, isPayment: true),
            SizedBox(height: 30.h),

            CustomButton(
              text: "Place Order",
              onTap: () {
                Get.toNamed(RouteConstants.orderSuccessScreen);
              },
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _toggleButton(String title, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isDelivery = (title == "Delivery")),
        child: Container(
          height: 45.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Color(0XFFDEDD9D) : Colors.transparent,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: CustomText(
            text: title,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Color(0XFF000000),
            // color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String? subtitle, {bool isPayment = false}) {
    return Row(
      children: [
        if (isPayment)
          Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1280px-Mastercard-logo.svg.png", width: 30.w)
        else
          Icon(icon, size: 28.sp, color: Color(0XFF000000)),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: title, fontSize: 14.sp, fontWeight: FontWeight.w600,color: Color(0XFF000000),),
              if (subtitle != null)
                CustomText(text: subtitle, fontSize: 11.sp, color: Color(0XFF000000)),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textPrimary),
      ],
    );
  }

  Widget _speedCard(String title, String desc, String price, bool hasPromo) {
    bool isSelected = selectedSpeed == title;
    return GestureDetector(
      onTap: () => setState(() => selectedSpeed = title),
      child: Container(
        width: 105.w,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceVariant : AppColors.surfaceVariant.withValues(alpha:0.5),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: isSelected ? AppColors.chipActive : Colors.transparent, width: 2),
        ),
        child: Column(
          children: [
            if (title == "Turbo") Icon(Icons.bolt, size: 18.sp, color: Colors.orange),
            if (title == "Standard") Icon(Icons.hourglass_empty, size: 18.sp, color: AppColors.geryColor),
            if (title == "Basic") Icon(Icons.ac_unit, size: 18.sp, color: Colors.blueGrey),
            SizedBox(height: 5.h),
            CustomText(text: title, fontSize: 12.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 5.h),
            CustomText(text: desc, fontSize: 9.sp, color: Color(0XFF000000), maxLines: 2,),
            SizedBox(height: 5.h),
            CustomText(text: price, fontSize: 12.sp, fontWeight: FontWeight.bold,color: Color(0XFF000000),),
            if (hasPromo)
              CustomText(text: "with TNP Star", fontSize: 12.sp, color: Color(0XFF93972E), fontWeight: FontWeight.bold),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String text, {VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 24.sp, color: AppColors.iconPrimary),
            SizedBox(width: 15.w),
            Expanded(child: CustomText(text: text, fontSize: 13.sp, fontWeight: FontWeight.w500, textAlign: TextAlign.start)),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textPrimary),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, String price) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: label, fontSize: 12.sp, color: Color(0XFF4E5760)),
          CustomText(text: "\$$price", fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0XFF4E5760)),
        ],
      ),
    );
  }
}