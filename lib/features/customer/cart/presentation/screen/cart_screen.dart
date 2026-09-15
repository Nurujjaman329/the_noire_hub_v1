import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../multiVendorCartScreen/data/cart_api_paths.dart';
import '../../../multiVendorCartScreen/data/multi_vendor_cart_response_model.dart';
import '../../../multiVendorCartScreen/presentation/controller/multi_vendor_cart_controller.dart';

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
      bottomNavigationBar: Obx(() {
        final currentVendor = controller.cartAttributes.value?.vendors
            .firstWhereOrNull((v) => v.vendor.id == vendorData.vendor.id);
        final subtotal = currentVendor?.subtotal ?? 0.0;
        final canCheckout = currentVendor != null && currentVendor.items.isNotEmpty;

        return Container(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 30.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              SizedBox(height: 16.h),
              CustomButton(
                text: "Go to checkout",
                onTap: canCheckout
                    ? () => Get.toNamed(
                          RouteConstants.checkOutScreen,
                          arguments: currentVendor,
                        )
                    : () {},
              ),
            ],
          ),
        );
      }),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final currentVendor = controller.cartAttributes.value?.vendors
                  .firstWhereOrNull((v) => v.vendor.id == vendorData.vendor.id);
              final displayItems = currentVendor?.items ?? const <CartItem>[];

              if (displayItems.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.h),
                  child: Center(
                    child: CustomText(
                      text: "No items in this cart",
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

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

            _buildAddMoreButton(),

            const Divider(thickness: 1, color: Colors.black12),

            SizedBox(height: 10.h),
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
                // Decrement / delete (qty 1 → DELETE /cart/items/{id})
                GestureDetector(
                  onTap: () {
                    if (controller.isUpdating.value) return;
                    if (CartApiPaths.shouldRemoveOnDecrement(item.quantity)) {
                      controller.removeCartItem(item.cartItemId);
                    } else {
                      controller.updateItemQuantity(
                        item.cartItemId,
                        item.quantity - 1,
                      );
                    }
                  },
                  child: Icon(
                    item.quantity <= 1 ? Icons.delete_outline : Icons.remove,
                    size: 18.sp,
                    color: item.quantity <= 1 ? AppColors.error : null,
                  ),
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


}