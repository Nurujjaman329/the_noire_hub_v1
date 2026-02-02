
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text.dart';

class CustomerConfirmBookings extends StatelessWidget {
  const CustomerConfirmBookings({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Retrieve the arguments passed from ServiceBookingScreen
    final dynamic args = Get.arguments;
    final String imageUrl = args?['img'] ?? "";
    final String serviceTitle = args?['title'] ?? "Knotless Braids";
    final String selectedSize = args?['size'] ?? "Medium";
    final String selectedLength = args?['length'] ?? "Armpit";

    return Scaffold(
      backgroundColor: const Color(0xFFCADA9F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: "Confirm Booking",
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2D3E2F),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dynamic Provider Card with passed Image
                    _buildProviderCard(imageUrl),

                    SizedBox(height: 40.h),

                    // Dynamic Breakdown
                    _buildPriceRow(serviceTitle, "\$100.00"),
                    _buildPriceRow("$selectedSize Size", "\$40.00"),
                    _buildPriceRow("$selectedLength Length", "\$40.00"),
                    _buildPriceRow("Service Fee", "\$4.00"),
                    _buildPriceRow("Taxes", "\$7.80"),


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

                    const Divider(thickness: 3, color: Color(0xFFC4C99A)),


                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: "Total", fontSize: 20.sp, fontWeight: FontWeight.bold),
                          CustomText(text: "\$191.80", fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ],
                      ),
                    ),

                    _buildPaymentMethod(),
                    SizedBox(height: 20.h),
                    CustomText(
                      text: "Braids By Mia will get paid after you approve rendered services",
                      fontSize: 10.sp,
                      color: Colors.black54,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildPayButton(),
        ],
      ),
    );
  }


  Widget _buildSummaryRow(IconData icon, String text, {VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h,top: 10.h),
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


  Widget _buildProviderCard(String img) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: img.isNotEmpty
              ? Image.network(img, width: 120.w, height: 120.h, fit: BoxFit.cover)
              : Container(width: 120.w, height: 120.h, color: Colors.grey[200]), // Fallback
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: "Braids By Mia", fontSize: 22.sp, fontWeight: FontWeight.bold),
              SizedBox(height: 8.h),
              CustomText(text: "10/03/2025 | 1:00 AM (MST)", fontSize: 11.sp, fontWeight: FontWeight.bold),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: () => Get.back(),
                child: Row(
                  children: [
                    CustomText(text: "Edit", fontSize: 13.sp, color: Color(0XFF000000),),
                    SizedBox(width: 5.w),
                    const Icon(Icons.edit_outlined, size: 16, color: Color(0XFF000000)),
                  ],
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
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: label, fontSize: 14.sp, fontWeight: FontWeight.w500),
              CustomText(text: amount, fontSize: 14.sp, fontWeight: FontWeight.bold),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F4D3)),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          // Mastercard Logo Placeholder
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.red, radius: 8.r),
                Transform.translate(
                  offset: Offset(-6.w, 0),
                  child: CircleAvatar(backgroundColor: Colors.orange.withOpacity(0.8), radius: 8.r),
                ),
              ],
            ),
          ),
          SizedBox(width: 15.w),
          CustomText(text: "Amina   ....3982", fontSize: 14.sp, fontWeight: FontWeight.bold),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(25.w, 10.h, 25.w, 40.h),
      child: CustomButton(
        text: "Pay Now",
        onTap: () {
          Get.toNamed(RouteConstants.customerBookingSuccess);
        },
        textColor: Color(0XFFF1F0B2),
        fontSize: 18.sp,
        // If your CustomButton supports these optional parameters:
      ),
    );
  }
}