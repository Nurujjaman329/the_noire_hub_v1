import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../serviceBookingScreen/presentation/controller/service_booking_details_controller.dart';


class CustomerConfirmBookings extends StatefulWidget {
  const CustomerConfirmBookings({super.key});

  @override
  State<CustomerConfirmBookings> createState() => _CustomerConfirmBookingsState();
}

class _CustomerConfirmBookingsState extends State<CustomerConfirmBookings> {
  double tipAmount = 0.0;
  String? appliedPromoCode;

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

    // Amount (service + selected lengths) → Service fee 4% + GST/Tax 5% + tip
    final double serviceFee = AppConstants.serviceFeeFor(subtotal);
    final double taxes = AppConstants.gstTaxFor(subtotal);
    final double total = AppConstants.roundMoney(
      AppConstants.totalWithFeesAndTax(subtotal) + tipAmount,
    );

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

                    // 3. Fees & tax (same rule as product checkout)
                    _buildPriceRow(
                      "Service Fee (4%)",
                      "\$${serviceFee.toStringAsFixed(2)}",
                    ),
                    _buildPriceRow(
                      "GST/Tax (5%)",
                      "\$${taxes.toStringAsFixed(2)}",
                    ),
                    if (tipAmount > 0)
                      _buildPriceRow(
                        "Tip",
                        "\$${tipAmount.toStringAsFixed(2)}",
                      ),
                    if (appliedPromoCode != null)
                      _buildPriceRow(
                        "Promo",
                        appliedPromoCode!,
                      ),

                    SizedBox(height: 10.h),

                    _buildSummaryRow(
                        Icons.brightness_5_outlined,
                        appliedPromoCode != null
                            ? "Promo | $appliedPromoCode"
                            : "Add Promo Code",
                        onTap: () => _openPromoScreen(),
                    ),

                    _buildSummaryRow(
                        Icons.payments_outlined,
                        tipAmount > 0
                            ? "Tip | \$${tipAmount.toStringAsFixed(2)}"
                            : "Add a Tip | 5% of subtotal",
                        onTap: () => _openTipScreen(subtotal),
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

  Future<void> _openTipScreen(double subtotal) async {
    final result = await Get.toNamed(
      RouteConstants.addTipScreen,
      arguments: {
        'subtotal': subtotal,
        'tip': tipAmount,
      },
    );

    if (result is num) {
      setState(() {
        tipAmount = AppConstants.roundMoney(result.toDouble());
      });
    }
  }

  Future<void> _openPromoScreen() async {
    final result = await Get.toNamed(
      RouteConstants.addPromoScreen,
      arguments: {
        'promoCode': appliedPromoCode,
      },
    );

    if (result is String) {
      setState(() {
        appliedPromoCode = result.trim().isEmpty ? null : result.trim();
      });
    }
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
            tip: tipAmount > 0 ? tipAmount : null,
            promoCode: appliedPromoCode,
          );
        },
        textColor: const Color(0XFFF1F0B2),
        fontSize: 18.sp,
      )),
    );
  }

}
