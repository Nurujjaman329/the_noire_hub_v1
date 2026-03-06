import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Grab data passed from the Payment WebView
    // Expecting a Map or Object containing delivery details
    final dynamic data = Get.arguments;

    // Example keys based on common API responses
    final String deliveryTime = data?['deliveryTime'] ?? "Oct 15 2020 - Oct 19 2020";
    final String orderId = data?['orderId']?.toString() ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Success Icon
            Container(
              height: 120.r,
              width: 120.r,
              decoration: const BoxDecoration(
                color: Color(0XFF1D3826),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 80.sp,
              ),
            ),

            SizedBox(height: 40.h),

            // 2. Confirmation Text
            CustomText(
              text: "Order Confirmed!",
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),

            if (orderId.isNotEmpty) ...[
              SizedBox(height: 5.h),
              CustomText(
                text: "Order ID: #$orderId",
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ],

            SizedBox(height: 20.h),

            // 3. Subtext with "View Order" link
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                CustomText(
                  text: "Your order has been placed successfully. ",
                  fontSize: 12.sp,
                  color: const Color(0xB2000000),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(RouteConstants.customerOrdersScreen),
                  child: CustomText(
                    text: "View Order",
                    fontSize: 12.sp,
                    color: const Color(0xFFB4BD6C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 15.h),

            // 4. DYNAMIC Estimated Delivery Info
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  fontFamily: "Outfit",
                ),
                children: [
                  const TextSpan(text: "Estimated Delivery by "),
                  TextSpan(
                    text: deliveryTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xB2000000),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15.h),

            // 5. Track My Order Link
            GestureDetector(
              onTap: () {
                Get.defaultDialog(
                  title: "Tracking Status",
                  titleStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  middleText: orderId.isNotEmpty
                      ? "Tracking for #$orderId is being processed. Please contact vendor for real-time updates."
                      : "Tracking Number not available right now, Please Contact Vendor.",
                  middleTextStyle: TextStyle(fontSize: 14.sp),
                  backgroundColor: Colors.white,
                  radius: 10,
                  confirm: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Color(0xFF435B33)),
                    ),
                  ),
                );
              },
              child: CustomText(
                text: "Track My Order",
                fontSize: 12.sp,
                color: const Color(0xFFB4BD6C),
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 60.h),

            // 6. Continue Shopping Button
            CustomButton(
              text: "Continue Shopping",
              onTap: () {
                // Return to home and reset tab
                Get.offAllNamed(
                  RouteConstants.customerMainContainer,
                  arguments: {'initialTab': 0},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}