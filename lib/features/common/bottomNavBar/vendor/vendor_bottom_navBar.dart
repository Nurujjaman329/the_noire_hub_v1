import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/accountController/account_controller.dart';

class VendorBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const VendorBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Access the Account Controller to check the type
    final accountCtrl = Get.find<AccountController>();
    debugPrint("Vendor Bottom Nav - Current User Type: ${accountCtrl.userType.value}, "
               "isCustomer: ${accountCtrl.isCustomer}, "
               "isVendor: ${accountCtrl.isVendor}, "
               "isBeautician: ${accountCtrl.isBeautician}");

    final bool isVendor = accountCtrl.isVendor;
    final bool isBeautician = accountCtrl.isBeautician;

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
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Color(0XFF1D3826),
          // backgroundColor: const Color(0xFF1E2D1F),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0XFFF1F0B2),
          // selectedItemColor: const Color(0xFFD9E0A3),
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
              icon: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: const Icon(Icons.home_filled),
              ),
              label: 'Dashboard',
            ),

            // 2. Adaptive Tab: Orders vs Bookings
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Icon(
                  isVendor ? Icons.assignment_outlined : Icons.calendar_month_outlined,
                ),
              ),
              label: isVendor ? 'Orders' : 'Bookings',
            ),

            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: const Icon(Icons.storefront_outlined),
              ),
              label: 'Store',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: const Icon(Icons.person),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}