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
                color: Color(0XFF1D3826), // Dark green background
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
              text: "Order Confirmed !",
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),

            SizedBox(height: 20.h),

            // 3. Subtext with "View Order" link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "Your order has been placed successfully. ",
                  fontSize: 12.sp,
                  color: Color(0xB2000000),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteConstants.customerOrdersScreen);
                  },
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

            // 4. Estimated Delivery Info
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  fontFamily: "Outfit",
                ),
                children: [
                  const TextSpan(text: "Estimated Delivery by "),
                  TextSpan(
                    text: "Oct 15 2020 - Oct 19 2020",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xB2000000),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15.h),

            // 5. Track My Order Link
            // 5. Track My Order Link
            GestureDetector(
              onTap: () {
                Get.defaultDialog(
                  title: "Tracking Status",
                  titleStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  middleText: "Tracking Number not available right now, Please Contact Vendor.",
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
                // Navigate to customer main container and set index to 0
                Get.offAllNamed(RouteConstants.customerMainContainer);
                // After navigation, set the index to 0
                Future.delayed(Duration.zero, () {
                  Get.offAllNamed(
                    RouteConstants.customerMainContainer,
                    arguments: {'initialTab': 0},
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}