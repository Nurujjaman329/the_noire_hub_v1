import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../bottomNavBar/vendor/vendor_main_controller.dart';

class DashboardDrawer extends StatelessWidget {
  final bool isVendor;
  final bool isBeautician;

  const DashboardDrawer({
    super.key,
    required this.isVendor,
    required this.isBeautician,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.65,
      child: Drawer(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ClipPath(
          clipper: DrawerClipper(),
          child: Container(
            color: const Color(0XFFCADA9F),
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 60.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: CircleAvatar(
                    backgroundColor: AppColors.primaryDark.withOpacity(0.1),
                    child: Icon(Icons.close, color: AppColors.primaryDark),
                  ),
                ),
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: CustomText(
                    text: isVendor ? "Manage Store" : "Manage Services",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 30.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _drawerItem(
                          Icons.person_outline,
                          "Account",
                              () => Get.toNamed(RouteConstants.profileScreen),
                        ),
                        _drawerItem(
                          Icons.visibility_outlined,
                          "View Store",
                              () => Get.find<VendorMainController>().goToTab(2),
                        ),
                        _drawerItem(
                          Icons.bar_chart,
                          "Business",
                              () => Get.toNamed(RouteConstants.businessScreen),
                        ),
                        _drawerItem(
                          isVendor ? Icons.description_outlined : Icons.calendar_today_outlined,
                          isVendor ? "Orders" : "Bookings",
                              () => Get.find<VendorMainController>().goToTab(1),
                        ),
                        _drawerItem(
                          Icons.payment,
                          "Add Billings",
                              () => Get.toNamed(RouteConstants.vendorBillingSection),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================== Drawer Item Widget ==================
  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: () {
        // Close drawer and run action
        Get.back();
        onTap();
      },
      leading: Icon(icon, size: 22.sp, color: AppColors.primaryDark),
      title: CustomText(
        text: title,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xB2000000),
        textAlign: TextAlign.start,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
    );
  }
}

// ================== Drawer Clipper ==================
class DrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveDepth = 70.r;

    path.lineTo(0, 0);
    path.lineTo(size.width - curveDepth, 0);

    path.cubicTo(
      size.width, 0,
      size.width, 0,
      size.width, curveDepth,
    );

    path.lineTo(size.width, size.height - curveDepth);

    path.cubicTo(
      size.width, size.height,
      size.width, size.height,
      size.width - curveDepth, size.height,
    );

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

