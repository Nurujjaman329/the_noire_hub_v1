import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';


class DealsPromosHistoryScreen extends StatelessWidget {
  const DealsPromosHistoryScreen({super.key});

  // Provided static image link
  static String vendorStoreTop = AppImages.registration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Top Image Header with Back Button
            Stack(
              children: [
                CustomNetworkImage(
                  imageUrl: vendorStoreTop,
                  height: 250.h,
                  width: double.infinity,
                ),
                Positioned(
                  top: 40.h,
                  left: 20.w,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
                    ),
                  ),
                ),
              ],
            ),



            // 4. Available Promos List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Used Promos & Deals",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(height: 15.h),
                  _buildWhiteCard(
                    child: Column(
                      children: [
                        _promoTile("20% Discounts", "52 Stores", "10/20/2025"),
                        _promoTile("10% Discounts", "73 Stores", "10/20/2025"),
                        _promoTile("10% Discounts", "73 Stores", "10/20/2025", isLast: true),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhiteCard({required Widget child, EdgeInsetsGeometry? margin}) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: child,
    );
  }

// Updated Promo Tile with Round Button
  Widget _promoTile(String title, String sub, String date, {bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              CustomText(text: title, fontSize: 15.sp, fontWeight: FontWeight.bold),
              SizedBox(width: 5.w),
              CustomText(text: sub, fontSize: 11.sp, color: Colors.grey),
            ],
          ),
          subtitle: CustomText(text: "Available till $date", fontSize: 12.sp, color: Colors.grey),
          // CHANGED: Replaced Icon with a Rounded Button

        ),
        if (!isLast) const Divider(color: AppColors.divider),
      ],
    );
  }

  // Success Dialog Function
  void _showSuccessDialog(String promoName) {
    Get.defaultDialog(
      title: "", // Empty title to use custom content
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      radius: 20.r,
      content: Column(
        children: [

          CustomText(
            text: "Hooray!",
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF9BB575),
          ),
          SizedBox(height: 10.h),
          CustomText(
            text: "$promoName is applied to your account",
            fontSize: 14.sp,
            textAlign: TextAlign.center,
            color: Colors.black54,
          ),
          SizedBox(height: 25.h),
          CustomButton(
            color: const Color(0xFF9BB575),
            text: "Start Shopping",
            onTap: () {
              // Get.offAllNamed(RouteConstants.customerMainContainer);
            },
          ),
        ],
      ),
    );
  }


}
