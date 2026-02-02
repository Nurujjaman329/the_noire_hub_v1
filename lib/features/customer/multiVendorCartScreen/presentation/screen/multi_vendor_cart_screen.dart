import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';


class MultiVendorCartScreen extends StatelessWidget {
  const MultiVendorCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "All Cart",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            // 1. Vendor Groups List
            _buildVendorGroup(
                "Skie Homemade Care Pro...",
                "7 items",
                "40.00",
                "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?q=80&w=200"
            ),
            _buildVendorGroup(
                "Ada's Body Shop",
                "7 items",
                "40.00",
                "https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?q=80&w=200"
            ),
            _buildVendorGroup(
                "Ada's Body Shop",
                "7 items",
                "40.00",
                "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?q=80&w=200"
            ),
            _buildVendorGroup(
                "Ada's Body Shop",
                "7 items",
                "40.00",
                "https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?q=80&w=200"
            ),

            const Divider(thickness: 1, color: AppColors.divider),
            SizedBox(height: 20.h),

            // 2. Similar Items Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomText(
                text: "Similar to items in your carts",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 15.h),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 20.w, bottom: 40.h),
              child: Row(
                children: [
                  _buildSimilarProductCard("Naturals Argan Shampoo", "13.00", "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?q=80&w=200"),
                  _buildSimilarProductCard("Skie Coconut & Peach Pomade", "15.00", "https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?q=80&w=200"),
                  _buildSimilarProductCard("Clay's Afro Comb", "10.39", "https://images.unsplash.com/photo-1590159346183-406b75bc912d?q=80&w=200"),

                ],
              ),
            ),

            SizedBox(
              height: 80.h,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildVendorGroup(String name, String items, String price, String imgUrl) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        children: [
          CustomNetworkImage(
            imageUrl: imgUrl,
            height: 80.h,
            width: 80.w,
            borderRadius: BorderRadius.circular(10.r),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: name,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF000000),
                    // color: AppColors.textPrimary,
                    maxLines: 1
                ),
                CustomText(
                    text: items,
                    fontSize: 14.sp,
                    color: Color(0x80000000),
                    // color: AppColors.geryColor
                ),
                CustomText(
                  text: "\$$price",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF000000),
                  // color: AppColors.primaryDark,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(RouteConstants.myCartScreen),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Color(0XFFF1F0B2),
                // color: AppColors.primary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: CustomText(
                text: "checkout",
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Color(0XFF000000),
                // color: AppColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarProductCard(String title, String price, String imgUrl) {
    return Container(
      width: 150.w,
      margin: EdgeInsets.only(right: 15.w),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
          color: Color(0XFFF1F0B2),
          // color: AppColors.primary,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ]
      ),
      child: Column(
        children: [
          CustomNetworkImage(
              imageUrl: imgUrl,
              height: 110.h,
              width: 130.w,
              borderRadius: BorderRadius.circular(20.r)
          ),
          SizedBox(height: 10.h),
          CustomText(
              text: title,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              color: Color(0XFF000000),
              // color: AppColors.textPrimary,
              maxLines: 2
          ),
          SizedBox(height: 5.h),
          CustomText(
              text: "\$$price",
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                  shape: BoxShape.circle
              ),
              child: Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 12.sp),
            ),
          )
        ],
      ),
    );
  }
}