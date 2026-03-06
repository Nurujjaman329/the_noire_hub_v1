import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import '../data/product_details_response_model.dart';
import 'controller/product_details_controller.dart';


class ProductDetailScreen extends GetView<ProductDetailsController> {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Product Details",
        showBackButton: true,
        actions: [_buildCartIcon()],
      ),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value || controller.product.value == null) {
          return const SizedBox.shrink();
        }
        return Container(
          height: 90.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: _buildFloatingAddToCart(),
        );
      }),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryDark));
        }

        final p = controller.product.value;
        if (p == null) {
          return const Center(child: CustomText(text: "Product not found"));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Image Carousel Section (Updated with Base URL)
              _buildImageSection(p),

              Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreHeader(p),
                    SizedBox(height: 10.h),
                    CustomText(
                      text: p.name,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 15.h),

                    // Price and Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "\$${controller.currentPrice.toStringAsFixed(2)}",
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                            if (p.originalPrice > controller.currentPrice)
                              Text(
                                "\$${p.originalPrice}",
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                  fontSize: 14.sp,
                                ),
                              ),
                          ],
                        ),
                        _buildRatingBadge(p.rating, p.totalReviews),
                      ],
                    ),

                    // 2. Dynamic Variant Selection
                    if (p.variants.isNotEmpty) ...[
                      SizedBox(height: 25.h),
                      CustomText(
                          text: "Available Options",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold
                      ),
                      SizedBox(height: 12.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: p.variants.map((v) => _buildVariantChip(v)).toList(),
                        ),
                      ),
                    ],
                    SizedBox(height: 25.h),

                    // Inside ProductDetailScreen Column, above the Description:
                    if (p.activePromoCodes.isNotEmpty) ...[
                      SizedBox(height: 25.h),
                      _buildPromoCodeSection(p.activePromoCodes),
                    ],

                    SizedBox(height: 15.h),
                    CustomText(text: "Description", fontSize: 14.sp, fontWeight: FontWeight.bold),
                    SizedBox(height: 10.h),
                    CustomText(
                      text: p.description,
                      fontSize: 12.sp,
                      color: AppColors.textPrimary,
                      textAlign: TextAlign.start,
                    ),

                    SizedBox(height: 20.h),
                    _buildStockIndicator(p.stock),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // --- HELPER WIDGETS ---


  Widget _buildPromoCodeSection(List<PromoCode> codes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "Available Offers",
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: "${codes.length} Offers",
              fontSize: 12.sp,
              color: AppColors.primaryDark,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: codes.map((promo) => _buildPromoCard(promo)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard(PromoCode promo) {
    return Obx(() {
      bool isSelected = controller.selectedPromoCode.value == promo.code;

      return GestureDetector(
        onTap: () => controller.togglePromoCode(promo.code),
        child: Container(
          width: 220.w,
          margin: EdgeInsets.only(right: 15.w),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF0F7F0) : AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.primaryDark : Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.local_offer_outlined,
                      size: 16.sp,
                      color: AppColors.primaryDark
                  ),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: promo.code,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: AppColors.primaryDark,
                  ),
                  const Spacer(),
                  if (isSelected)
                    Icon(Icons.check_circle, color: AppColors.primaryDark, size: 18.sp),
                ],
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: promo.title,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                maxLines: 1,
              ),
              CustomText(
                text: "Get ${promo.discountPercentage}% OFF",
                fontSize: 11.sp,
                color: AppColors.geryColor,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildImageSection(DetailsProductAttributes p) {
    return Stack(
      children: [
        SizedBox(
          height: 350.h,
          child: PageView.builder(
            onPageChanged: controller.changeImage,
            itemCount: p.images.length,
            itemBuilder: (context, index) {
              // Constructing full image URL
              final fullImageUrl = "${ApiConstants.baseImageUrl}${p.images[index]}";

              return CustomNetworkImage(
                imageUrl: fullImageUrl,
                height: 350.h,
                width: double.infinity,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 15.h,
          left: 0,
          right: 0,
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              p.images.length,
                  (index) => _buildDotIndicator(controller.selectedImageIndex.value == index),
            ),
          )),
        )
      ],
    );
  }

  Widget _buildVariantChip(DetailsVariant v) {
    return Obx(() {
      bool isSelected = controller.selectedVariantId.value == v.id;

      return GestureDetector(
        onTap: () => controller.selectVariant(v.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(right: 12.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryDark : AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected ? AppColors.primaryDark : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show color indicator if color is present
              if (v.colorCode.isNotEmpty) ...[
                Container(
                  width: 14.w,
                  height: 14.w,
                  decoration: BoxDecoration(
                    color: v.colorValue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "${v.weight.value} ${v.weight.unit}",
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                  CustomText(
                    text: "\$${v.price}",
                    color: isSelected ? AppColors.white.withValues(alpha:0.7) : AppColors.geryColor,
                    fontSize: 10.sp,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFloatingAddToCart() {
    return Row(
      children: [
        // 1. Quantity Selector
        Container(
          height: 54.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.remove, color: AppColors.textPrimary, size: 20.sp),
                onPressed: controller.decrementQty,
              ),
              Obx(() => SizedBox(
                width: 30.w,
                child: Center(
                  child: CustomText(
                    text: "${controller.quantity.value}",
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              )),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.add, color: AppColors.textPrimary, size: 20.sp),
                onPressed: controller.incrementQty,
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),

        // 2. Add to Cart Button (Wrapped in Obx for loading state)
        Expanded(
          child: Obx(() {
            final bool isLoading = controller.isCartLoading.value;

            return GestureDetector(
              onTap: isLoading ? null : () => controller.addToCart(),
              child: Container(
                height: 54.h,
                decoration: BoxDecoration(
                  color: const Color(0XFF1D3826),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0XFF1D3826).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: const CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, color: AppColors.white, size: 20.sp),
                      SizedBox(width: 10.w),
                      CustomText(
                        text: "Add to Cart",
                        color: AppColors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStoreHeader(DetailsProductAttributes p) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: "${p.vendor.businessName} | ${p.category.name}",
          fontSize: 10.sp,
          color: AppColors.geryColor,
        ),
        const CustomText(
          text: "View Store",
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0XFF3F592B),
        ),
      ],
    );
  }

  Widget _buildRatingBadge(num rating, int reviews) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(Icons.star, size: 14.sp, color: AppColors.textPrimary),
          SizedBox(width: 4.w),
          CustomText(text: "$rating | $reviews+", fontSize: 12.sp, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  Widget _buildStockIndicator(int stock) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: stock > 0 ? Colors.green.withValues(alpha:0.1) : Colors.red.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(
            stock > 0 ? Icons.check_circle : Icons.do_not_disturb_on,
            color: stock > 0 ? Colors.green : Colors.red,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          CustomText(
            text: stock > 0 ? "In Stock ($stock items)" : "Out of Stock",
            color: stock > 0 ? Colors.green : Colors.red,
            fontSize: 12.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      height: 6.h,
      width: isActive ? 18.w : 6.w,
      decoration: BoxDecoration(
        color: isActive ? AppColors.textPrimary : AppColors.dividerVariant,
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }

  Widget _buildCartIcon() {
    return Padding(
      padding: EdgeInsets.only(right: 15.w),
      child: GestureDetector(
        onTap: () => Get.offAllNamed(
            RouteConstants.customerMainContainer,
            arguments: {'initialTab': 3}
        ),
        child: Icon(Icons.shopping_cart_outlined, color: AppColors.textPrimary, size: 24.sp),
      ),
    );
  }
}