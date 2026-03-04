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
import '../../../multiVendorCartScreen/presentation/controller/multi_vendor_cart_controller.dart';

// 1. Change to GetView to access our controller easily
class CartScreen extends GetView<MultiVendorCartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the specific vendor data passed via Get.arguments
    final CartVendor vendorData = Get.arguments;

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
            // 2. Wrap list in Obx so it refreshes when controller.getCartDetails() is called
            Obx(() {
              // We find the current vendor's updated data from the controller's main list
              final currentVendor = controller.cartAttributes.value?.vendors
                  .firstWhereOrNull((v) => v.vendor.id == vendorData.vendor.id);

              // Fallback to initial vendorData if controller hasn't loaded yet
              final displayItems = currentVendor?.items ?? vendorData.items;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: displayItems.length,
                itemBuilder: (context, index) {
                  final item = displayItems[index];
                  return _buildCartItem(item);
                },
              );
            }),

            // Add More Items Button
            _buildAddMoreButton(),

            const Divider(thickness: 1, color: Colors.black12),

            // Subtotal Section
            Obx(() {
              final currentVendor = controller.cartAttributes.value?.vendors
                  .firstWhereOrNull((v) => v.vendor.id == vendorData.vendor.id);
              final subtotal = currentVendor?.subtotal ?? vendorData.subtotal;

              return Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: "Subtotal", fontSize: 18.sp, fontWeight: FontWeight.bold),
                            CustomText(text: "Promotions Applied at Checkout", fontSize: 10.sp),
                          ],
                        ),
                        CustomText(
                          text: "\$${subtotal.toStringAsFixed(2)}",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: "Go to checkout",
                      onTap: () => Get.toNamed(RouteConstants.checkOutScreen),
                    ),
                  ],
                ),
              );
            }),

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

  Widget _buildCartItem(CartItem item) {
    final imgUrl = item.product.image.startsWith('http')
        ? item.product.image
        : "https://tonmoy3000.sobhoy.com${item.product.image}";

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
                CustomText(text: item.product.name, fontSize: 14.sp, fontWeight: FontWeight.w600, maxLines: 2),
                SizedBox(height: 10.h),
                CustomText(text: "\$${item.unitPrice.toStringAsFixed(2)}", fontSize: 14.sp, fontWeight: FontWeight.bold),
              ],
            ),
          ),

          // QUANTITY SELECTOR PART
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0XFFF1F0B2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                // Decrement
                GestureDetector(
                  onTap: () => controller.updateItemQuantity(item.cartItemId, item.quantity - 1),
                  child: Icon(item.quantity <= 1 ? Icons.delete_outline : Icons.remove, size: 18.sp),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: CustomText(text: "${item.quantity}", fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                // Increment
                GestureDetector(
                  onTap: () => controller.updateItemQuantity(item.cartItemId, item.quantity + 1),
                  child: Icon(Icons.add, size: 18.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreButton() {
    return GestureDetector(
      onTap: () => Get.offAllNamed(RouteConstants.customerMainContainer, arguments: {'initialTab': 1}),
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
                CustomText(text: "Add more items", fontSize: 13, fontWeight: FontWeight.w500),
              ],
            ),
          ),
        ),
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