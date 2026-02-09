
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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1D3826)));
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: CustomText(text: controller.errorMessage.value));
        }

        final product = controller.productDetails.value;
        if (product == null) return const Center(child: Text("Product not found"));

        return CustomScrollView(
          slivers: [
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
                        imageUrl: product.images.isNotEmpty
                            ? "${ApiConstants.baseImageUrl}${product.images[0]}"
                            : "",
                        height: 300.h,
                        width: 340.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 15.h),
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

                    // Updated Variant Section
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
            border: Border.all(color: const Color(0xFF9BB575).withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D3826).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    topRight: Radius.circular(15.r),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text: "Variant Options",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    CustomText(
                      text: "Price",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                    SizedBox(width: 10.w),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: variants.length,
                itemBuilder: (context, index) {
                  final variant = variants[index];
                  return _buildVariantRow(
                    variant,
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

  Widget _buildVariantRow(VariantModel variant, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
          child: Row(
            children: [
              // 1. Precise Color Swatch
              if (variant.color != null && variant.color!.isNotEmpty) ...[
                _buildColorCircle(variant.color!),
                SizedBox(width: 12.w),
              ],

              // 2. Info Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      // If it's a hex code, we show a clean label or the code itself
                      text: _getColorName(variant.color),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D3826),
                    ),
                    if (variant.weight != null)
                      CustomText(
                        text: "${variant.weight!.value} ${variant.weight!.unit}",
                        fontSize: 11.sp,
                        color: Colors.black45,
                      ),
                  ],
                ),
              ),

              // 3. Price
              CustomText(
                text: "\$${variant.price.toStringAsFixed(2)}",
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D3826),
              ),
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Divider(color: Colors.grey.withValues(alpha: 0.1), height: 1),
          ),
      ],
    );
  }

  Widget _buildColorCircle(String hexCode) {
    Color displayColor;
    try {
      // Standardize the string: remove 0X, #, and whitespace
      String cleanHex = hexCode.toUpperCase().replaceAll('0X', '').replaceAll('#', '').trim();

      // If API sends 0XFF0000 (6 chars after 0X), it needs the FF alpha prefix
      if (cleanHex.length == 6) {
        cleanHex = 'FF$cleanHex';
      }

      displayColor = Color(int.parse('0x$cleanHex'));
    } catch (e) {
      displayColor = const Color(0xFF9BB575); // Fallback to brand green
    }

    return Container(
      width: 24.r, // Slightly larger for better visibility
      height: 24.r,
      decoration: BoxDecoration(
        color: displayColor,
        shape: BoxShape.circle,
        // Thin border so white/light colors don't disappear on white background
        border: Border.all(color: Colors.black.withValues(alpha: 0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: displayColor.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
    );
  }

// Helper to keep the UI clean if the color is just a hex string
  String _getColorName(String? colorValue) {
    if (colorValue == null || colorValue.isEmpty) return "Standard";

    try {
      // Convert hex string to Color
      String cleanHex = colorValue.toUpperCase().replaceAll('0X', '').replaceAll('#', '').trim();
      if (cleanHex.length == 6) cleanHex = 'FF$cleanHex'; // Add alpha if missing
      final color = Color(int.parse('0x$cleanHex'));

      return describeColor(color); // <-- Dynamic name
    } catch (e) {
      return "Unknown Color";
    }
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

  String describeColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    final lightness = hsl.lightness;
    final saturation = hsl.saturation;
    final hue = hsl.hue;

    String shade = lightness < 0.2
        ? "Dark"
        : lightness > 0.8
        ? "Light"
        : "";

    String basicColor;
    if (saturation < 0.25) {
      basicColor = "Gray";
    } else if (hue < 30) {
      basicColor = "Red";
    } else if (hue < 90) {
      basicColor = "Yellow";
    } else if (hue < 150) {
      basicColor = "Green";
    } else if (hue < 210) {
      basicColor = "Cyan";
    } else if (hue < 270) {
      basicColor = "Blue";
    } else if (hue < 330) {
      basicColor = "Magenta";
    } else {
      basicColor = "Red";
    }

    return "$shade $basicColor".trim();
  }

}