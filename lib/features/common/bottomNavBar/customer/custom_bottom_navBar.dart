import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';


class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.r),
          topRight: Radius.circular(50.r),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Color(0XFF1D3826),
          // backgroundColor: AppColors.background,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.primary.withOpacity(0.6),
          showUnselectedLabels: true,

          // Adjusting the font size and height pushes labels down
          selectedLabelStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            fontFamily: "Outfit",
            height: 1.5, // Adds space between icon and text
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12.sp,
            fontFamily: "Outfit",
            height: 1.5,
          ),

          items: [
            BottomNavigationBarItem(
              // Padding on top pushes both icon and text lower
              icon: Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: const Icon(Icons.home_filled),
              ),
              label: 'Service',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: const Icon(Icons.inventory_2_outlined),
              ),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: const Icon(Icons.calendar_month),
              ),
              label: 'Book',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Cart',
            ),
          ],
        ),
      ),
    );
  }
}