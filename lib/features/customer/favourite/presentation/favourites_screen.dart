import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import 'controller/favorites_controller.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerFavoritesController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: CustomText(
            text: "Favorites",
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
          bottom: TabBar(
            indicatorColor: const Color(0xFF435B33),
            indicatorWeight: 3,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: "Vendors"),
              Tab(text: "Beauticians"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Vendors (Filter by itemType: 'Product')
            _buildFavoritesList(controller, targetType: 'Product'),
            // Tab 2: Beauticians (Filter by itemType: 'Service')
            _buildFavoritesList(controller, targetType: 'Service'),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(CustomerFavoritesController controller, {required String targetType}) {
    return Obx(() {
      if (controller.isLoading.value && controller.favoritesList.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: Color(0xFF435B33)));
      }

      // Filter list based on itemType
      final filteredList = controller.favoritesList
          .where((fav) => fav.itemType.toLowerCase() == targetType.toLowerCase())
          .toList();

      if (filteredList.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: controller.onRefresh,
        color: const Color(0xFF435B33),
        child: ListView.separated(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          itemCount: filteredList.length + (controller.isMoreLoading.value ? 1 : 0),
          separatorBuilder: (context, index) => Divider(height: 30.h, color: Colors.grey.shade200),
          itemBuilder: (context, index) {
            if (index < filteredList.length) {
              final favorite = filteredList[index];
              final item = favorite.item;

              return _buildStoreItem(
                name: item?.name ?? "Unknown",
                orders: "${item?.totalReviews ?? 0}",
                location: "Location info N/A",
                imageUrl: (item?.images.isNotEmpty ?? false)
                    ? "${ApiConstants.baseImageUrl}${item!.images[0]}"
                    : "",
                onTap: () {
                  // 1. Check if item and id exist
                  if (item?.id != null && item!.id.isNotEmpty) {

                    // 2. Navigate based on targetType
                    if (targetType == 'Product') {
                      debugPrint("🚀 Navigating to Product Details: ${item.id}");
                      // Passing the ID as a String as expected by your ProductDetailsController
                      Get.toNamed(RouteConstants.productDetailsScreen, arguments: item.id);
                    } else {
                      debugPrint("🚀 Navigating to Service Details: ${item.id}");
                      // Assuming you have a similar route for services
                      Get.toNamed(RouteConstants.serviceDetailsScreen, arguments: item.id);
                    }
                  } else {
                    Get.snackbar(
                        "Notice",
                        "Item details are currently unavailable",
                        snackPosition: SnackPosition.BOTTOM
                    );
                  }
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
    });
  }

  Widget _buildStoreItem({
    required String name,
    required String orders,
    required String location,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        // 1. Circular Image
        Container(
          height: 60.r,
          width: 60.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade100,
          ),
          child: ClipOval(
            child: CustomNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover, height: 70, width: 70,
            ),
          ),
        ),
        SizedBox(width: 15.w),
        // 2. Info Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: name, fontSize: 15.sp, fontWeight: FontWeight.bold),
              CustomText(text: "$orders previous orders", fontSize: 11.sp, color: Colors.black54),
              CustomText(text: location, fontSize: 11.sp, color: Colors.black54),
            ],
          ),
        ),
        // 3. Action Button
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: const Color(0xFF8B9467),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: CustomText(
              text: "View Store",
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 60.r, color: Colors.grey),
          SizedBox(height: 10.h),
          const CustomText(text: "No favorites found", color: Colors.grey),
        ],
      ),
    );
  }
}