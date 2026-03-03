import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../data/multi_vendor_cart_response_model.dart';
import '../controller/multi_vendor_cart_controller.dart';

class MultiVendorCartScreen extends StatelessWidget {
  const MultiVendorCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Find the controller
    final controller = Get.find<MultiVendorCartController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "All Cart",
      ),
      body: Obx(() {
        // 2. Show loading state
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 3. Show empty state if no vendors
        if (controller.isCartEmpty) {
          return Center(
            child: CustomText(text: "Your cart is empty", fontSize: 16.sp),
          );
        }

        final vendors = controller.cartAttributes.value!.vendors;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              // 4. Dynamic Vendor Groups List from API
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vendors.length,
                itemBuilder: (context, index) {
                  final vendorData = vendors[index];
                  // Pass only the named parameter here
                  return _buildVendorGroup(vendorData: vendorData);
                },
              ),

              const Divider(thickness: 1, color: AppColors.divider),
              SizedBox(height: 20.h),

              // 5. Similar Items Section (Keep as static or link to a different API later)
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
              SizedBox(height: 80.h)
            ],
          ),
        );
      }),
    );
  }

  Widget _buildVendorGroup({required CartVendor vendorData}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        children: [
          CustomNetworkImage(
            imageUrl: vendorData.vendor.image.startsWith('http')
                ? vendorData.vendor.image
                : "https://tonmoy3000.sobhoy.com${vendorData.vendor.image}",
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
                    text: vendorData.vendor.businessName,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFF000000),
                    maxLines: 1
                ),
                CustomText(
                  text: "${vendorData.itemCount} items",
                  fontSize: 14.sp,
                  color: const Color(0x80000000),
                ),
                CustomText(
                  text: "\$${vendorData.subtotal.toStringAsFixed(2)}",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0XFF000000),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(
                RouteConstants.myCartScreen,
                arguments: vendorData // Now vendorData is accessible here!
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0XFFF1F0B2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: CustomText(
                text: "checkout",
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF000000),
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
