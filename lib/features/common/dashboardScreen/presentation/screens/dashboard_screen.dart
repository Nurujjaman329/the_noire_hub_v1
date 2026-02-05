
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:the_noire_hub_v1/core/constants/api_constants.dart';
import 'package:the_noire_hub_v1/core/widgets/custom_network_image.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/storage/local_storage.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../authentication/login/data/login_response_model.dart';
import '../widget/dashboard_drawer.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // 1. Get the Strongly-Typed Model (The "Pro" Way)
    final user = LocalStorage.getUserModel();

    // 2. Extract logic directly from the object
    final String role = user?.role.toLowerCase() ?? 'user';
    final bool isVendor = role.contains('vendor');
    final bool isBeautician = role.contains('beautician');
    final String businessName = user?.businessName ?? "Ada’s Body Shop";

    // 3. Handle Auto-Dialog for Beauticians
    if (isBeautician) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // You could also add a check here like: if (!LocalStorage.getTipDismissed()) ...
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: DashboardDrawer(isVendor: isVendor, isBeautician: isBeautician),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, user), // Pass the full user object
                SizedBox(height: 20.h),
                Center(
                  child: CustomText(
                    text: "Dashboard",
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFF000000),
                  ),
                ),
                SizedBox(height: 25.h),
                _buildStoreBanner(businessName),
                SizedBox(height: 25.h),
                _buildProductsSection(isVendor, isBeautician, context),
                SizedBox(height: 25.h),
                _buildRevenueSection(),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildHeader(BuildContext context, UserModel? user) {

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
              Icon(Icons.location_on, size: 18.sp, color: AppColors.textPrimary),
              SizedBox(width: 5.w),
              CustomText(
                // You could pull this from user?.addresses.first.city if needed
                text: "Toronto, ON",
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              Icon(Icons.keyboard_arrow_down, size: 18.sp, color: AppColors.textPrimary),
            ],
          ),
          GestureDetector(
            onTap: () => Get.toNamed(RouteConstants.profileScreen),
            child: CircleAvatar(
              radius: 22.r,
              backgroundColor: AppColors.primary.withOpacity(0.1), // Nice soft background
              // 1. Use NetworkImage (ImageProvider) instead of a Widget
              backgroundImage: user != null && user.fullProfileImageUrl.isNotEmpty
                  ? NetworkImage(user.fullProfileImageUrl)
                  : null,
              // 2. Show Icon only if image is missing
              child: (user == null || user.fullProfileImageUrl.isEmpty)
                  ? Icon(Icons.person, size: 24.sp, color: AppColors.primaryDark)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreBanner(String name) {
    // Logic for splitting name if it's too long
    final displayName = name.contains(' ') ? name.replaceFirst(' ', '\n') : name;

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
            child: Icon(Icons.eco_outlined, size: 80.sp, color: AppColors.primaryDark.withOpacity(0.3)),
          )
        ],
      ),
    );
  }

  Widget _buildProductsSection(bool isVendor, bool isBeautician, BuildContext context) {
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
                _buildProductTile("https://images.pexels.com/photos/4041391/pexels-photo-4041391.jpeg"),
                _buildProductTile("https://images.pexels.com/photos/3762882/pexels-photo-3762882.jpeg"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddButton(bool isBeautician, bool isVendor, BuildContext context) {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
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
                    child: Icon(Icons.close, color: const Color(0xFF1D3826), size: 24.sp),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                    ),
                    child: const Text(
                      "Add Now",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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


  Widget _buildProductTile(String url) {
    return Container(
      width: 100.w,
      height: 110.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: AppColors.white, width: 4),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
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
                    color: AppColors.white.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => CustomText(
                        text: '${value.toInt()}K',
                        color: AppColors.white.withOpacity(0.6),
                        fontSize: 10.sp,
                      ),
                      reservedSize: 30,
                    ),
                  ),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                      color: AppColors.primary.withOpacity(0.1),
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

  // 🔥 AccountController removed from here
  // void showQuickTipDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: true, // Set to true if you don't need the controller to "dismiss" it permanently
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
  //         child: Container(
  //           padding: EdgeInsets.all(24.r),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Align(
  //                 alignment: Alignment.topRight,
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     Get.toNamed(RouteConstants.addProductsScreen);
  //                   },
  //                   child: Icon(Icons.close, color: const Color(0xFF1D3826), size: 24.sp),
  //                 ),
  //               ),
  //               SizedBox(height: 10.h),
  //               Text("Quick Tip", style: TextStyle(color: const Color(0xFF6B8E23), fontSize: 28.sp, fontWeight: FontWeight.bold)),
  //               SizedBox(height: 20.h),
  //               Text(
  //                 "Add beautician certifications to attract more customers",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 18.sp),
  //               ),
  //               SizedBox(height: 30.h),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     Get.toNamed(RouteConstants.businessScreen);
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: const Color(0xFF6B7E50),
  //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
  //                   ),
  //                   child: const Text("Add Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}