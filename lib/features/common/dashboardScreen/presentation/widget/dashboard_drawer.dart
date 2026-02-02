import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../../../../../core/accountController/account_controller.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/navigationController/app_navigation_controller.dart';
import '../../../../../core/widgets/custom_text.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final accountCtrl = Get.find<AccountController>();
    debugPrint("Dashboard Drawer - Current User Type: ${accountCtrl.userType.value}, "
               "isCustomer: ${accountCtrl.isCustomer}, "
               "isVendor: ${accountCtrl.isVendor}, "
               "isBeautician: ${accountCtrl.isBeautician}");

    final bool isVendor = accountCtrl.isVendor;
    final bool isBeautician = accountCtrl.isBeautician;

    return SizedBox(
      width: Get.width * 0.65,
      child: Drawer(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        child: ClipPath(
          clipper: DrawerClipper(),
          child: Container(
            color: Color(0XFFCADA9F),
            // color: AppColors.primary,
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 60.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close button
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
                        _drawerItem(Icons.person_outline, "Account", () => Get.toNamed(RouteConstants.profileScreen)),

                        // Adaptive Store/Profile View
                        _drawerItem(
                          Icons.visibility_outlined,
                          "View Store",
                                () {
                                  Get.back(); // Close the drawer
                                  // Set the index to 1 to show orders/bookings
                                  Get.find<AppNavigationController>().changeVendorIndex(2);
                                }
                        ),

                        _drawerItem(Icons.bar_chart, "Business", () => Get.toNamed(RouteConstants.businessScreen)),

                        // IMPORTANT: Adaptive Navigation for Orders/Bookings
                        _drawerItem(
                            isVendor ? Icons.description_outlined : Icons.calendar_today_outlined,
                            isVendor ? "Orders" : "Bookings",
                                () {
                              // Close the drawer and set index to 1 (orders/bookings tab)
                              Get.back(); // Close the drawer
                              // Set the index to 1 to show orders/bookings
                              Get.find<AppNavigationController>().changeVendorIndex(1);
                            }
                        ),

                        _drawerItem(Icons.payment, "Add Billings", () => Get.toNamed(RouteConstants.vendorBillingSection)),
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


  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: () {
        // FIX: Use Get.back() to close drawer before navigating
        Get.back();
        onTap();
      },
      leading: Icon(icon, size: 22.sp, color: AppColors.primaryDark),
      title: CustomText(
        text: title,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: Color(0xB2000000),
        // color: AppColors.primaryDark,
        textAlign: TextAlign.start,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
    );
  }
}

class DrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveDepth = 70.r; // How far the curve pulls in

    path.lineTo(0, 0); // Start Top-Left
    path.lineTo(size.width - curveDepth, 0); // Top edge

    // TOP RIGHT CURVE
    // cubicTo(controlPoint1X, controlPoint1Y, controlPoint2X, controlPoint2Y, endPointX, endPointY)
    path.cubicTo(
      size.width, 0, // First control point (at the very corner)
      size.width, 0, // Second control point
      size.width, curveDepth, // Ends 60px down the side
    );

    // RIGHT SIDE LINE
    path.lineTo(size.width, size.height - curveDepth);

    // BOTTOM RIGHT CURVE
    path.cubicTo(
      size.width, size.height, // Control point
      size.width, size.height, // Control point
      size.width - curveDepth, size.height, // Ends 60px in from the right edge
    );

    path.lineTo(0, size.height); // Back to bottom-left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}