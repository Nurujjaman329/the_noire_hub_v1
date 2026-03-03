import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../multiVendorCartScreen/data/multi_vendor_cart_response_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;

  // 1. Retrieve the specific vendor data passed via Get.arguments
  final CartVendor vendorData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "My Cart",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Dynamic Cart Items List from vendorData
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: vendorData.items.length,
              itemBuilder: (context, index) {
                final item = vendorData.items[index];
                return _buildCartItem(
                  item.product.name,
                  item.unitPrice.toStringAsFixed(2),
                  item.quantity.toString(),
                  // Handle partial image paths
                  item.product.image.startsWith('http')
                      ? item.product.image
                      : "https://tonmoy3000.sobhoy.com${item.product.image}",
                  index == 1, // Logic for delete icon placeholder
                );
              },
            ),

            // 3. Add More Items Button
            GestureDetector(
              onTap: () => Get.back(), // Returns to MultiVendorCartScreen
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w, top: 10.h, bottom: 20.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEDD9D),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 18.sp),
                        SizedBox(width: 5.w),
                        CustomText(
                          text: "Add more items",
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF000000),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const Divider(thickness: 1, color: Colors.black12),

            // 4. Options Section
            _buildOptionTile(Icons.card_giftcard, "Send as a gift"),
            _buildOptionTile(Icons.star_border, "Save on this order with TNP Star"),

            // 5. Dynamic Subtotal and Checkout
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Subtotal",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0XFF020F1B),
                          ),
                          CustomText(
                            text: "Promotions Applied at Checkout",
                            fontSize: 10.sp,
                            color: const Color(0XFF000000),
                          ),
                        ],
                      ),
                      // Real subtotal from API
                      CustomText(
                        text: "\$${vendorData.subtotal.toStringAsFixed(2)}",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0XFF000000),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  CustomButton(
                    text: "Go to checkout",
                    loading: isLoading,
                    onTap: () {
                      setState(() => isLoading = true);
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() => isLoading = false);
                        Get.toNamed(RouteConstants.checkOutScreen);
                      });
                    },
                  ),
                ],
              ),
            ),

            // 6. Recommendation Section (Static UI as per your design)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomText(
                text: "Products You Might Need",
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF000000),
              ),
            ),
            SizedBox(height: 15.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 20.w, bottom: 110.h),
              child: Row(
                children: [
                  _buildProductCard("Naturals Argan Shampoo", "13.00", "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?q=80&w=200"),
                  _buildProductCard("Skie Coconut & Peach Pomade", "15.00", "https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?q=80&w=200"),
                  _buildProductCard("Clay's Afro Comb", "10.39", "https://images.unsplash.com/photo-1590159346183-406b75bc912d?q=80&w=200"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helper Widgets ---

  Widget _buildCartItem(String title, String price, String qty, String imgUrl, bool showDelete) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          CustomNetworkImage(
            imageUrl: imgUrl,
            height: 75.h,
            width: 75.w,
            borderRadius: BorderRadius.circular(10.r),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  color: const Color(0XFF000000),
                ),
                SizedBox(height: 10.h),
                CustomText(
                  text: "\$$price",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0XFF000000),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0XFFF1F0B2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(showDelete ? Icons.delete_outline : Icons.remove, size: 18.sp),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: CustomText(text: qty, fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.add, size: 18.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        children: [
          Icon(icon, color: const Color(0XFF000000), size: 24.sp),
          SizedBox(width: 15.w),
          CustomText(
            text: title,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0XFF000000),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String title, String price, String imgUrl) {
    return Container(
      width: 140.w,
      margin: EdgeInsets.only(right: 15.w),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4D3),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        children: [
          CustomNetworkImage(
            imageUrl: imgUrl,
            height: 100.h,
            width: 110.w,
            borderRadius: BorderRadius.circular(20.r),
          ),
          SizedBox(height: 10.h),
          CustomText(
            text: title,
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(text: "\$$price", fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.bold),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(5.r),
                decoration: const BoxDecoration(color: Color(0xFF1E2F23), shape: BoxShape.circle),
                child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10.sp),
              )
            ],
          ),
        ],
      ),
    );
  }
}