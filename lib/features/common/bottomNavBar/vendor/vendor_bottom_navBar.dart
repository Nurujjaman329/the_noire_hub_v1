import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_noire_hub_v1/features/common/bottomNavBar/vendor/vendor_main_controller.dart';
import 'package:get/get.dart';

class VendorBottomNavbar extends StatelessWidget {
  final VendorMainController controller;

  const VendorBottomNavbar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
        child: Obx(
              () => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeIndex,
            backgroundColor: const Color(0XFF1D3826),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0XFFF1F0B2),
            unselectedItemColor: Colors.white.withOpacity(0.6),
            showUnselectedLabels: true,
            iconSize: 24.sp,
            selectedLabelStyle: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              height: 1.8,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 11.sp,
              height: 1.8,
            ),
            items: [
              BottomNavigationBarItem(
                icon: _navIcon(Icons.home_filled),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: _navIcon(controller.isVendor
                    ? Icons.assignment_outlined
                    : Icons.calendar_month_outlined),
                label: controller.isVendor ? 'Orders' : 'Bookings',
              ),
              BottomNavigationBarItem(
                icon: _navIcon(Icons.storefront_outlined),
                label: 'Store',
              ),
              BottomNavigationBarItem(
                icon: _navIcon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _navIcon(IconData icon) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Icon(icon),
    );
  }
}