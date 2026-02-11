

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_noire_hub_v1/features/vendor/vendorOrderScreen/presentation/screens/widget/vendor_cancel_order_list.dart';
import 'package:the_noire_hub_v1/features/vendor/vendorOrderScreen/presentation/screens/widget/vendor_complete_order_list.dart';
import 'package:the_noire_hub_v1/features/vendor/vendorOrderScreen/presentation/screens/widget/vendor_inProgress_order_list.dart';
import 'package:the_noire_hub_v1/features/vendor/vendorOrderScreen/presentation/screens/widget/vendor_pending_order_list.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_text.dart';

class VendorOrdersScreen extends StatefulWidget {
  const VendorOrdersScreen({super.key});

  @override
  State<VendorOrdersScreen> createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<VendorOrdersScreen> {
  // Local state to track selected tab
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Order History",),
      body: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Column(
          children: [
            _buildOrderTabs(),
            Expanded(
              child: _buildOrderList(),
            ),
          ],
        ),
      ),
    );
  }

  // Logic to switch between views based on local state
  Widget _buildOrderList() {
    switch (selectedTabIndex) {
      case 0:
        return const VendorPendingOrderList();
      case 1:
        return const VendorInprogressOrderList();
      case 2:
        return const VendorCompleteOrderList();
      case 3:
        return const VendorCancelOrderList();
      default:
        return const VendorPendingOrderList();
    }
  }

  Widget _buildOrderTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          _tabButton("Pending", 0),
          _tabButton("In Progress", 1),
          _tabButton("Completed", 2),
          _tabButton("Canceled", 3),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    bool isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFCADA9F) : Colors.transparent,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: CustomText(
            text: title,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFF000000) : const Color(0xB2000000),
            fontSize: 10.sp, // Reduced slightly to ensure 4 tabs fit on smaller screens
          ),
        ),
      ),
    );
  }
}