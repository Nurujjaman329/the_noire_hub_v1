import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/datetime_util.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_text.dart';
import 'package:get/get.dart';
import '../data/service_details_response_model.dart';
import 'controller/service_details_controller.dart';

class ServiceDetailsScreen extends GetView<ServiceDetailsController> {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Details", showBackButton: true),
      body: Obx(() {
        // Show loader while fetching data
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1D3826)));
        }

        final data = controller.serviceData.value;

        // Handle empty state or error
        if (data == null) {
          return const Center(child: CustomText(text: "Service not found"));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Dynamic Image Carousel
              _buildImageCarousel(data.images),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    // 2. Dynamic Title and Price
                    CustomText(
                      text: data.name,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      text: "\$${data.price.toStringAsFixed(2)}",
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1D3826),
                    ),

                    const Divider(height: 40, thickness: 1),

                    // 3. Dynamic Description
                    _buildSectionTitle("Description"),
                    CustomText(
                      text: data.description,
                      fontSize: 14.sp,
                      color: Colors.grey.shade700,
                    ),

                    SizedBox(height: 25.h),

                    // 4. Dynamic Variants (Mapping variants from API)
                    if (data.variants.isNotEmpty)
                      ...data.variants.map((variant) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(variant.variantName, subtitle: variant.description),
                            _buildOptionGrid(variant.subVariants),
                            SizedBox(height: 25.h),
                          ],
                        );
                      }),

                    // 5. Service Availability
                    CustomText(
                      text: "Services Date & Time",
                      color: const Color(0XFF1D3826),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 10.h),

                    CustomText(
                      text: data.availableDates.isNotEmpty
                          ? DateTimeUtil.formatFullDateTime(data.availableDates.first)
                          : "Contact for availability",
                      color: const Color(0XFF1D3826),
                      fontSize: 18.sp,
                    ),

                    SizedBox(height: 25.h),

                    // 6. Dynamic Location Selection
                    _buildSectionTitle("Location", subtitle: "where would you prefer to meet?"),
                    _buildLocationSelector(data.homeService),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // --- Helper Widgets Updated for Dynamic Data ---

  Widget _buildImageCarousel(List<String> images) {
    // If no images from API, use a placeholder
    final displayImages = images.isNotEmpty
        ? images.map((img) => "${ApiConstants.imageUrl}$img").toList()
        : ["https://via.placeholder.com/300"];

    return Column(
      children: [
        SizedBox(
          height: 300.h,
          child: PageView.builder(
            itemCount: displayImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  image: DecorationImage(
                    image: NetworkImage(displayImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(displayImages.length, (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 6.h,
            width: 6.w,
            decoration: BoxDecoration(
              color: index == 0 ? const Color(0xFF1D3826) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {String? subtitle}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: title, fontSize: 18.sp, fontWeight: FontWeight.bold),
          if (subtitle != null && subtitle.isNotEmpty)
            CustomText(text: subtitle, fontSize: 11.sp, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildOptionGrid(List<SubVariant> subVariants) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: subVariants.map((sub) => Container(
          width: 100.w,
          margin: EdgeInsets.only(right: 10.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F0B2).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF1D3826),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Center(
                    child: CustomText(
                      text: sub.name,
                      color: Colors.white,
                      fontSize: 12.sp,
                      maxLines: 1,
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(text: "\$${sub.price}", fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildLocationSelector(bool homeServiceAvailable) {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFF1D3826).withValues(alpha: 0.3)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Opacity(
                opacity: homeServiceAvailable ? 1.0 : 0.4,
                child: Column(
                  children: [
                    CustomText(text: "Home Service", fontWeight: FontWeight.bold),
                    CustomText(
                        text: homeServiceAvailable ? "Available" : "Not Available",
                        color: Colors.grey,
                        fontSize: 12.sp
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(thickness: 2, color: Color(0xFF1D3826)),
            Expanded(
              child: Column(
                children: [
                  CustomText(text: "Salon", fontWeight: FontWeight.bold),
                  CustomText(text: "In-Store", color: Colors.grey, fontSize: 12.sp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}