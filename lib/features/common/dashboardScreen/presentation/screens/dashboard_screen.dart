
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/accountController/account_controller.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/storage/local_storage.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/dialog_helper.dart';
import '../widget/dashboard_drawer.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // 1. Get User Data directly from Local Storage
    final userData = LocalStorage.getUserData();
    final String role = (userData?['role'] ?? 'user').toString().toLowerCase();

    // 2. Define Role Booleans
    final bool isVendor = role.contains('vendor');
    final bool isBeautician = role.contains('beautician');
    final String userName = userData?['name'] ?? "Ada’s Body Shop";

    // 3. Handle Auto-Dialog for Beauticians
    // Note: You can use a simple RxBool in a small 'DashboardController'
    // or just show it once per session.
    if (isBeautician) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // You might want to add a check here to only show once
        // showQuickTipDialog(context);
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
                _buildHeader(context, userData),
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
                _buildStoreBanner(userName),
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

  Widget _buildHeader(BuildContext context, Map<String, dynamic>? userData) {
    final String profileImg = userData?['image'] ?? "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg";

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
                text: "Toronto, ON", // This could also come from LocalStorage if saved
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
              backgroundImage: NetworkImage(profileImg),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreBanner(String name) {
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
                text: name.replaceFirst(' ', '\n'), // Wraps name to two lines
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

  Widget _buildProductsSection(bool isVendor, bool isBeautician, BuildContext context)
  {
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
                _buildAddButton(isBeautician, context),
                _buildProductTile("https://images.pexels.com/photos/4041391/pexels-photo-4041391.jpeg"),
                _buildProductTile("https://images.pexels.com/photos/3762882/pexels-photo-3762882.jpeg"),
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget _buildAddButton(bool isBeautician, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isBeautician) {
          showQuickTipDialog(context);
        } else {
          Get.toNamed(RouteConstants.addProductsScreen);
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

  Widget _buildAddProductTile(BuildContext context) {
    final AccountController accountCtrl = Get.find<AccountController>();

    return GestureDetector(
      onTap: () {
        // 1. Check if the user is a Beautician first
        if (accountCtrl.isBeautician) {
          showQuickTipDialog(context);
          return; // Exit here so other logic doesn't run
        }

        // 2. Existing flow for Vendors/others
        if (accountCtrl.hasDismissedActionDialog.value) {
          Get.toNamed(RouteConstants.addProductsScreen);
        } else {
          GlobalDialogs.showActionRequiredDialog(
              onVerifyTap: () {
                accountCtrl.dismissDialog();
                Get.toNamed(RouteConstants.businessScreen);
              },
              onFulfillmentTap: () {
                accountCtrl.dismissDialog();
                Get.toNamed(RouteConstants.orderFullFillMent);
              },
              onClose: () {
                accountCtrl.dismissDialog();
              }
          );
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

  // --- Revenue Section ---
  Widget _buildRevenueSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Color(0XFF3F592B),
        // color: AppColors.background, // Dark forest green background
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

  void showQuickTipDialog(BuildContext context) {
    final AccountController accountCtrl = Get.find<AccountController>();

    showDialog(
      context: context,
      barrierDismissible: false, // Force interaction
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
                      accountCtrl.dismissDialog(); // MARK AS DISMISSED
                      Navigator.pop(context);
                      Get.toNamed(RouteConstants.addProductsScreen); // Go to Add Products
                    },
                    child: Icon(Icons.close, color: const Color(0xFF1D3826), size: 24.sp),
                  ),
                ),
                SizedBox(height: 10.h),
                Text("Quick Tip", style: TextStyle(color: Color(0xFF6B8E23), fontSize: 28.sp, fontWeight: FontWeight.bold)),
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
                      accountCtrl.dismissDialog(); // MARK AS DISMISSED
                      Navigator.pop(context);
                      Get.toNamed(RouteConstants.businessScreen); // Go to Certifications
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B7E50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                    ),
                    child: Text("Add Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}