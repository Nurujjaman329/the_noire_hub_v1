import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import 'package:get/get.dart';

import '../../customerProducts/presentation/controller/customer_products_controller.dart';


class ServicePopularNearYouScreen extends StatefulWidget {
  const ServicePopularNearYouScreen({super.key});

  @override
  State<ServicePopularNearYouScreen> createState() => _ServicePopularNearYouScreenState();
}

class _ServicePopularNearYouScreenState extends State<ServicePopularNearYouScreen> {
  final controller = Get.find<CustomerProductsController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Schedule the data fetch AFTER the first build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1. Set the specific distance for this screen
      controller.selectedDistance.value = 10;

      // 2. Refresh data from API
      controller.fetchProducts();
    });

    // 3. Setup Pagination Listener (this is fine in initState)
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Popular Near You", showBackButton: true),
      body: Obx(() {
        if (controller.isLoading.value && controller.productList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1D3826)));
        }

        if (controller.productList.isEmpty) {
          return const Center(child: CustomText(text: "No stylists found within 10km"));
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: GridView.builder(
            controller: _scrollController, // Attach for pagination
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,
              mainAxisExtent: 260.h,
            ),
            itemCount: controller.productList.length,
            itemBuilder: (context, index) {
              final product = controller.productList[index];

              // Calculate dynamic distance for the card
              String distText = "10+ km";
              if (CacheService.lat != 0.0 && product.location.coordinates.length >= 2) {
                double meters = Geolocator.distanceBetween(
                    CacheService.lat, CacheService.lon,
                    product.location.coordinates[1], product.location.coordinates[0]
                );
                distText = "${(meters / 1000).toStringAsFixed(1)} km away";
              }

              return _popularVerticalCard(
                product.name,
                "Knotless", // Or product.category.name if available
                product.price.toString(),
                distText,
                product.rating.toString(),
                product.images.isNotEmpty ? "${ApiConstants.baseImageUrl}${product.images.first}" : "",
                onTap: () => Get.toNamed(RouteConstants.productDetailsScreen, arguments: product),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _popularVerticalCard(
      String name, String style, String price, String distance,
      String rating, String imageUrl, {VoidCallback? onTap}
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1F0B2),
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
                    child: CustomNetworkImage(
                      imageUrl: imageUrl,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 10.h, right: 10.w,
                    child: CircleAvatar(
                      radius: 15.r,
                      backgroundColor: const Color(0xFF1D3826).withValues(alpha:0.8),
                      child: Icon(Icons.favorite, color: const Color(0xFFF1F0B2), size: 16.sp),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(text: name, fontSize: 12.sp, fontWeight: FontWeight.w600, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      CustomText(text: style, fontSize: 10.sp, fontWeight: FontWeight.bold),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: distance, fontSize: 10.sp, color: Colors.black54),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              CustomText(text: "$rating ", fontSize: 10.sp, color: const Color(0xFF9BB575)),
                              Icon(Icons.star, size: 10.sp, color: const Color(0xFF9BB575)),
                            ],
                          ),
                        ],
                      ),
                      CustomText(text: "\$$price", fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}