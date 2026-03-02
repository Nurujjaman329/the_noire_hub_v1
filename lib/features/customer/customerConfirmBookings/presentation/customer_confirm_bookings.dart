
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../serviceBookingScreen/presentation/controller/service_booking_details_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomerConfirmBookings extends StatelessWidget {
  const CustomerConfirmBookings({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Retrieve arguments from ServiceBookingScreen
    final Map<String, dynamic> args = Get.arguments ?? {};

    final String serviceId = args['serviceId'] ?? "";
    final String serviceTitle = args['title'] ?? "Service";
    final String imageUrl = args['img'] ?? "";
    final String date = args['date'] ?? "";
    final String time = args['time'] ?? "";

    // Prices
    final double basePrice = args['basePrice']?.toDouble() ?? 0.0;
    final double subtotal = args['price']?.toDouble() ?? 0.0;

    // Booking Items (List of selected variants and sub-variants with names/prices)
    final List<dynamic> displayItems = args['displayItems'] ?? [];
    final List<dynamic> bookingItems = args['bookingItems'] ?? [];

    // Calculations
    const double serviceFee = 4.00;
    final double taxes = subtotal * 0.05; // 5% Tax example
    final double total = subtotal + serviceFee + taxes;

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
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dynamic Provider Card
                    _buildProviderCard(imageUrl, serviceTitle, date, time),

                    SizedBox(height: 30.h),
                    const CustomText(text: "Price Breakdown", fontWeight: FontWeight.bold, fontSize: 16),
                    SizedBox(height: 10.h),

                    // 1. Base Price
                    _buildPriceRow(serviceTitle, "\$${basePrice.toStringAsFixed(2)}"),

                    // 2. Dynamic Sub-Variants Loop (Multiple Selections)
                    ...displayItems.map((item) => _buildPriceRow(
                      item['name'] ?? "Option",
                      "+\$${(item['price'] ?? 0.0).toStringAsFixed(2)}",
                    )),

                    // 3. Static Fees
                    _buildPriceRow("Service Fee", "\$${serviceFee.toStringAsFixed(2)}"),

                    SizedBox(height: 10.h),

                    _buildSummaryRow(
                        Icons.brightness_5_outlined,
                        "Add Promo Code",
                        onTap: () => Get.toNamed(RouteConstants.addPromoScreen)
                    ),

                    _buildSummaryRow(
                        Icons.payments_outlined,
                        "Add a Tip | 5% of subtotal",
                        onTap: () => Get.toNamed(RouteConstants.addTipScreen)
                    ),

                    const Divider(thickness: 3, color: Color(0xFFC4C99A)),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: "Total", fontSize: 20.sp, fontWeight: FontWeight.bold),
                          CustomText(
                            text: "\$${total.toStringAsFixed(2)}",
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1D3826),
                          ),
                        ],
                      ),
                    ),

                    _buildPaymentMethod(),
                    SizedBox(height: 20.h),
                    const Center(
                      child: CustomText(
                        text: "Payment will be processed after service approval",
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Pass the collected data to the booking logic
          _buildPayButton(total, serviceId, bookingItems, date, time),
        ],
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildProviderCard(String img, String title, String date, String time) {
    String formattedDateTime = "$date | $time";

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
              CustomText(text: title, fontSize: 20.sp, fontWeight: FontWeight.bold),
              SizedBox(height: 8.h),
              CustomText(
                text: formattedDateTime,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(text: "Edit", fontSize: 12.sp, fontWeight: FontWeight.bold),
                      SizedBox(width: 5.w),
                      const Icon(Icons.edit_outlined, size: 14),
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
              Expanded(child: CustomText(text: label, fontSize: 14.sp, fontWeight: FontWeight.w500)),
              CustomText(text: amount, fontSize: 14.sp, fontWeight: FontWeight.bold),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F4D3)),
      ],
    );
  }

  Widget _buildSummaryRow(IconData icon, String text, {VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 22.sp, color: const Color(0xFF1D3826)),
            SizedBox(width: 15.w),
            Expanded(child: CustomText(text: text, fontSize: 13.sp, fontWeight: FontWeight.w500)),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4D3).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6.r)),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.red, radius: 6.r),
                Transform.translate(offset: Offset(-4.w, 0), child: CircleAvatar(backgroundColor: Colors.orange, radius: 6.r)),
              ],
            ),
          ),
          SizedBox(width: 15.w),
          const CustomText(text: "Amina   ....3982", fontSize: 14, fontWeight: FontWeight.bold),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  Widget _buildPayButton(double total, String serviceId, List<dynamic> items, String date, String time) {
    final controller = Get.find<ServiceBookingDetailsController>();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(25.w, 10.h, 25.w, 40.h),
      child: Obx(() => CustomButton(
        text: controller.isLoading.value ? "Processing..." : "Pay Now | \$${total.toStringAsFixed(2)}",
        onTap: () {
          if (controller.isLoading.value) return;

          controller.createBooking(
            serviceId: serviceId,
            items: List<Map<String, dynamic>>.from(items),
            date: date,
            time: time,
          );
        },
        textColor: const Color(0XFFF1F0B2),
        fontSize: 18.sp,
      )),
    );
  }

}