
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import '../data/vendor_product_details_response_model.dart';
import 'controller/vendor_product_details_controller.dart';

class VendorProductDetailsScreen extends GetView<VendorProductDetailsController> {
  const VendorProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // 1. Handle Loading State
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1D3826)));
        }

        // 2. Handle Error State
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: CustomText(text: controller.errorMessage.value));
        }

        final product = controller.productDetails.value;
        if (product == null) return const Center(child: Text("Product not found"));

        return CustomScrollView(
          slivers: [
            // Header with Dynamic Image
            SliverAppBar(
              expandedHeight: 380.h,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: CustomAppBar(
                title: "Details",
                showBackButton: true,
                bgColor: Colors.transparent,
                arrowColor: const Color(0xFF1D3826),
              ),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    SizedBox(height: 100.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25.r),
                      child: CustomNetworkImage(
                        imageUrl: "${ApiConstants.baseImageUrl}${product.image}",
                        height: 300.h,
                        width: 340.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    // Dynamic Dots for Image Gallery (if multiple images exist)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        product.images.isEmpty ? 1 : product.images.length,
                            (index) => _buildDot(isActive: index == 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Information
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: product.name,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D3826),
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      text: "\$${product.price.toStringAsFixed(2)}",
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1D3826),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: Divider(color: Colors.grey.shade300, thickness: 1),
                    ),
                    CustomText(
                      text: "Description",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: product.description,
                      fontSize: 14.sp,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                    SizedBox(height: 25.h),

                    // Dynamic Variant List
                    if (product.variants.isNotEmpty)
                      _buildVariantSection(product.variants),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      height: 6.r,
      width: 6.r,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1D3826) : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildVariantSection(List<VariantModel> variants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Available Variants",
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1D3826),
        ),
        SizedBox(height: 15.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F4),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: const Color(0xFF9BB575).withOpacity(0.2)),
          ),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D3826).withOpacity(0.03),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    topRight: Radius.circular(15.r),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: CustomText(
                            text: "Unit/Size",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600)),
                    CustomText(
                        text: "Price",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
                    SizedBox(width: 20.w),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),

              // Dynamic Variant Rows
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: variants.length,
                itemBuilder: (context, index) {
                  final variant = variants[index];
                  return _buildTableRow(
                    variant.name,
                    "\$${variant.price.toStringAsFixed(2)}",
                    isLast: index == variants.length - 1,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableRow(String label, String price, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
          child: Row(
            children: [
              Expanded(
                child: CustomText(
                  text: label,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D3826),
                ),
              ),
              CustomText(
                text: price,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D3826),
              ),
              SizedBox(width: 10.w),
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Divider(color: Colors.grey.withOpacity(0.1), height: 1),
          ),
      ],
    );
  }
}