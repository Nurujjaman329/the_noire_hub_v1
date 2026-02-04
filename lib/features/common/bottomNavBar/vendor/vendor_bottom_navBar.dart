import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VendorBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isVendor; // Added this parameter

  const VendorBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isVendor, // Added to constructor
  });

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
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
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
              icon: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: const Icon(Icons.home_filled),
              ),
              label: 'Dashboard',
            ),

            // Adaptive Tab: Logic now uses the passed isVendor boolean
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