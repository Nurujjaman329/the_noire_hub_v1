import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/services/cache_service.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../data/beautician_store_response_model.dart';
import '../controller/beautician_store_service_controller.dart';


class BeauticianStoreScreen extends GetView<BeauticianStoreServiceController> {
  const BeauticianStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Dynamic Business Info from CacheService
    final String businessName = CacheService.businessName.isNotEmpty
        ? CacheService.businessName
        : "My Shop";
    final String profileImg = CacheService.userImage;
    final String businessBio = CacheService.bio.isNotEmpty
        ? CacheService.bio
        : "Welcome to our professional beautician services.";

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (controller.isLoading.value && controller.services.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF707E5F)));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchServices(isRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                _buildHeaderBackground(),
                Column(
                  children: [
                    SizedBox(height: 160.h),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.r),
                          topRight: Radius.circular(50.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          Transform.translate(
                            offset: Offset(0, -60.h),
                            child: _buildFloatingProfileImage(profileImg),
                          ),
                          Transform.translate(
                            offset: Offset(0, -40.h),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                children: [
                                  _buildStoreInfo(businessName, businessBio),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15.h),
                                    child: Divider(color: AppColors.geryColor.withValues(alpha: 0.2), thickness: 1),
                                  ),
                                  _buildTextButtonsToggle(),
                                  SizedBox(height: 10.h),

                                  // 4. Simplified Service List (No automatic grouping)
                                  if (controller.services.isEmpty && !controller.isLoading.value)
                                    _buildEmptyState()
                                  else
                                    _buildProductSection("All Services", controller.services),

                                  if (controller.isLoading.value && controller.services.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20.h),
                                      child: const CircularProgressIndicator(color: Color(0xFF707E5F)),
                                    ),

                                  SizedBox(height: 100.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // --- Simplified Section Builder (Matches Vendor Style) ---
  Widget _buildProductSection(String title, List<ServiceModel> services) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25.h, bottom: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: title, fontSize: 18.sp, fontWeight: FontWeight.bold),
              GestureDetector(
                onTap: () => Get.toNamed(RouteConstants.addProductsScreen),
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, size: 18.sp, color: const Color(0xFF707E5F)),
                    CustomText(
                      text: "Add Service",
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF707E5F),
                      left: 5.w,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 15.w,
            mainAxisSpacing: 15.h,
          ),
          itemBuilder: (context, index) => _buildServiceCard(services[index]),
        ),
      ],
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
    final String storeName = CacheService.businessName.isNotEmpty ? CacheService.businessName : "My Salon";
    final String fullImageUrl = service.images.isNotEmpty ? "${ApiConstants.imageUrl}${service.images[0]}" : "";

    return GestureDetector(
      onTap: () => Get.toNamed(
        RouteConstants.serviceDetailsScreen,
        arguments: service.id,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0XFFF9F9D3),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                    child: CustomNetworkImage(
                      imageUrl: fullImageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.all(.01.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: _buildActionMenu(service),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: CustomText(text: storeName, fontSize: 12.sp, fontWeight: FontWeight.w500, maxLines: 1)),
                      Flexible(child: CustomText(text: service.name, fontSize: 12.sp, fontWeight: FontWeight.bold, maxLines: 1)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: "7 km away", fontSize: 10.sp, color: Colors.black54),
                          Row(
                            children: [
                              CustomText(text: "${service.rating} ", fontSize: 10.sp, color: const Color(0XFF707E5F), fontWeight: FontWeight.bold),
                              Icon(Icons.star, color: const Color(0XFF707E5F), size: 10.sp),
                              CustomText(text: " (${service.totalReviews})", fontSize: 10.sp, color: const Color(0XFF707E5F)),
                            ],
                          ),
                        ],
                      ),
                      CustomText(text: "\$${service.price}", fontSize: 15.sp, fontWeight: FontWeight.bold),
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

  // --- Helper Components ---
  Widget _buildFloatingProfileImage(String imageUrl) {
    return Container(
      padding: EdgeInsets.all(5.r),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: CustomNetworkImage(imageUrl: imageUrl, height: 110.r, width: 110.r, boxShape: BoxShape.circle),
    );
  }

  Widget _buildStoreInfo(String name, String bio) {
    return Column(
      children: [
        CustomText(text: name, fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0XFF1D3826)),
        SizedBox(height: 10.h),
        CustomText(text: bio, textAlign: TextAlign.center, fontSize: 11.sp, color: const Color(0x80000000)),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _infoTile("Home Service: ${controller.services.any((s) => s.homeService) ? "Yes" : "No"}"),
              _infoDivider(),
              _infoTile("Verified"),
              _infoDivider(),
              _infoTile("Beautician"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionMenu(ServiceModel service) {
    return PopupMenuButton<String>(
      color: const Color(0XFF627E4C),
      // Ensure 18.sp is working, or use a fixed double like 18.0
      icon: Icon(Icons.more_vert, size: 18.r, color: AppColors.geryColor),
      onSelected: (value) {
        if (value == 'edit') {
          Get.toNamed(RouteConstants.editServiceScreen, arguments: service);
        } else if (value == 'delete') {
          _showDeleteConfirmation(service);
        }
      },
      itemBuilder: (context) => [
        _buildMenuItem('edit', Icons.edit, "Edit", const Color(0XFFF1F0B2)),
        _buildMenuItem('delete', Icons.delete, "Delete", Colors.red),
      ],
    );
  }

  Widget _buildHeaderBackground() {
    return SizedBox(
      height: 240.h,
      child: Stack(
        children: [
          CustomNetworkImage(imageUrl: AppAssets.vendorStoreTop, height: 240.h, width: double.infinity, borderRadius: BorderRadius.zero, fit: BoxFit.cover),
          Positioned(top: 0, right: 0, child: CustomNetworkImage(imageUrl: AppAssets.vendorStoreShadow, height: 140.h, width: 220.w)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 50.h),
        child: Column(
          children: [
            Icon(Icons.spa_outlined, size: 50.sp, color: AppColors.geryColor),
            SizedBox(height: 10.h),
            CustomText(text: "No services listed yet.", color: AppColors.geryColor),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String val, IconData icon, String text, Color color) {
    return PopupMenuItem(
      value: val,
      height: 35.h,
      child: Row(
        mainAxisSize: MainAxisSize.min, // Added safety
        children: [
          Icon(icon, size: 14.r, color: color), // Changed .sp to .r for icons often helps
          SizedBox(width: 8.w),
          CustomText(text: text, fontSize: 12.sp, color: color),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(ServiceModel service) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Service"),
        content: Text("Are you sure you want to delete '${service.name}'?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.back();
              controller.removeService(service.id);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButtonsToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: "Service Inventory", color: const Color(0XFFB5B475), fontSize: 14.sp, fontWeight: FontWeight.bold),
        CustomText(text: "Preview", color: const Color(0XFFB5B475), fontSize: 14.sp, fontWeight: FontWeight.bold),
      ],
    );
  }

  Widget _infoTile(String text) => CustomText(text: text, fontSize: 9.sp, color: const Color(0XFFB5B475), fontWeight: FontWeight.w500);
  Widget _infoDivider() => Padding(padding: EdgeInsets.symmetric(horizontal: 8.w), child: CustomText(text: "|", fontSize: 10.sp, color: AppColors.geryColor.withValues(alpha:0.5)));
}