import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/services/cache_service.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../beautician/beauticanStoreScreen/presentation/controller/beautician_store_service_controller.dart';
import '../../../../vendor/vendorStoreScreen/presentation/controller/vendor_product_controller.dart';
import '../widget/dashboard_drawer.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Find both controllers
  final vendorController = Get.find<VendorProductController>();
  final beauticianController = Get.find<BeauticianStoreServiceController>();

  @override
  Widget build(BuildContext context) {
    final String role = CacheService.role.toLowerCase();
    final bool isVendor = role.contains('vendor');
    final bool isBeautician = role.contains('beautician');

    final String businessName = CacheService.businessName.isNotEmpty
        ? CacheService.businessName
        : "Ada’s Body Shop";

    final image = CacheService.userImage;
    final fullImageUrl = image.isNotEmpty ? ApiConstants.baseImageUrl + image : null;

    return Scaffold(
      key: _scaffoldKey,
      drawer: DashboardDrawer(isVendor: isVendor, isBeautician: isBeautician),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: RefreshIndicator(
          // Inside build method -> RefreshIndicator
          onRefresh: () async {
            if (isVendor) {
              await vendorController.refreshProducts();
            } else if (isBeautician) {
              await beauticianController.fetchServices(isRefresh: true);
            } else {
              debugPrint("⚠️ Unknown role: $role. No data to refresh.");
            }
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, fullImageUrl: fullImageUrl),
                  SizedBox(height: 20.h),
                  Center(
                    child: CustomText(text: "Dashboard", fontSize: 28.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 25.h),
                  _buildStoreBanner(businessName),
                  SizedBox(height: 25.h),

                  // Dynamic Section
                  Obx(() => _buildItemsSection(isVendor, isBeautician, context)),

                  SizedBox(height: 25.h),
                  _buildRevenueSection(),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---


  Widget _buildItemsSection(bool isVendor, bool isBeautician, BuildContext context) {
    // 1. Guard against unexpected roles
    if (!isVendor && !isBeautician) {
      return _buildErrorState("Unauthorized Role", "Please contact support.");
    }

    // 2. Select the active controller based on role
    final bool isLoading = isVendor
        ? vendorController.isLoading.value
        : beauticianController.isLoading.value;

    final List items = isVendor
        ? vendorController.productList
        : beauticianController.services;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: const Color(0XFF9BB575),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: CustomText(
              text: isVendor ? "Your Products" : "Your Services",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0XFF1D3826),
            ),
          ),
          SizedBox(height: 15.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildAddButton(isBeautician, isVendor, context),

                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                else if (items.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(20.r),
                    child: CustomText(text: "No items found", color: Colors.white70),
                  )
                else
                  ...items.take(5).map((item) {
                    String imageUrl = "";
                    String id = item.id ?? "";
                    String route = isVendor
                        ? RouteConstants.vendorProductDetailScreen
                        : RouteConstants.serviceDetailsScreen;

                    // Dynamic Image Path based on Role
                    if (isVendor) {
                      imageUrl = item.images.isNotEmpty
                          ? "${ApiConstants.baseImageUrl}${item.images[0]}"
                          : "";
                    } else {
                      imageUrl = item.images.isNotEmpty
                          ? "${ApiConstants.imageUrl}${item.images[0]}"
                          : "";
                    }

                    return _buildItemTile(imageUrl, id, route);
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Simple error helper
  Widget _buildErrorState(String title, String sub) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(25.r)),
      child: Column(
        children: [
          Icon(Icons.lock_person, color: Colors.red),
          CustomText(text: title, fontWeight: FontWeight.bold),
          CustomText(text: sub, fontSize: 12.sp),
        ],
      ),
    );
  }


  Widget _buildItemTile(String url, String id, String route) {
    return GestureDetector(
      onTap: () => Get.toNamed(route, arguments: id),
      child: Container(
        width: 100.w,
        height: 110.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: AppColors.white, width: 4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: CustomNetworkImage( 
            imageUrl: url,
            fit: BoxFit.cover, height: 70, width: 70,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {String? fullImageUrl}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Icon(Icons.menu, size: 28.sp, color: AppColors.geryColor),
          ),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 18.sp,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: 5.w),
              CustomText(
                text: "Toronto, ON",
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 18.sp,
                color: AppColors.textPrimary,
              ),
            ],
          ),

          GestureDetector(
            onTap: () => Get.toNamed(RouteConstants.profileScreen),
            child: Container(
              height: 44.r,
              width: 44.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: ClipOval(
                child: fullImageUrl != null && fullImageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: fullImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 25.sp,
                          color: AppColors.primary,
                        ),
                      )
                    : Icon(Icons.person, size: 25.sp, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreBanner(String name) {
    // Logic for splitting name if it's too long
    final displayName = name.contains(' ')
        ? name.replaceFirst(' ', '\n')
        : name;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0XFFCADA9F),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: displayName,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF1D3826),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 15.h),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(
              Icons.eco_outlined,
              size: 80.sp,
              color: AppColors.primaryDark.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAddButton(
    bool isBeautician,
    bool isVendor,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        if (isBeautician) {
          // Show Tip first for Beauticians
          showQuickTipDialog(context);
        } else if (isVendor) {
          // Direct navigation for Vendors
          Get.toNamed(RouteConstants.vendorAddProductScreen);
        }
      },
      child: Container(
        width: 100.w,
        height: 110.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: AppColors.white, width: 4),
        ),
        child: Icon(Icons.add, size: 35.sp, color: AppColors.primaryDark),
      ),
    );
  }

  void showQuickTipDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close Dialog
                      // Navigate to Beautician Service Screen
                      Get.toNamed(RouteConstants.beauticiansAddServiceScreen);
                    },
                    child: Icon(
                      Icons.close,
                      color: const Color(0xFF1D3826),
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Quick Tip",
                  style: TextStyle(
                    color: const Color(0xFF6B8E23),
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Add beautician certifications to attract more customers",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.sp),
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // This leads to the Business Profile/Certifications section
                      Get.toNamed(RouteConstants.businessScreen);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B7E50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: const Text(
                      "Add Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductTile(String url, String prodcutId) {
    return GestureDetector(
      onTap: () => Get.toNamed(RouteConstants.vendorProductDetailScreen, arguments: prodcutId),
      child: Container(
        width: 100.w,
        height: 110.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: AppColors.white, width: 4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r), // Match border radius minus border width
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(child: Icon(Icons.image, color: Colors.white)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0XFF3F592B),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "This Week’s Revenue",
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
          SizedBox(height: 30.h),
          SizedBox(
            height: 200.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.white.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => CustomText(
                        text: '${value.toInt()}K',
                        color: AppColors.white.withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                      reservedSize: 30,
                    ),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 20),
                      const FlSpot(2, 45),
                      const FlSpot(4, 35),
                      const FlSpot(6, 75),
                      const FlSpot(8, 60),
                      const FlSpot(10, 85),
                    ],
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
