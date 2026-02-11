import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:the_noire_hub_v1/features/customer/customerBookingList/presentation/screen/widget/canceled_bookings.dart';
import 'package:the_noire_hub_v1/features/customer/customerBookingList/presentation/screen/widget/complete_bookings.dart';
import 'package:the_noire_hub_v1/features/customer/customerBookingList/presentation/screen/widget/in_progress_bookings.dart';
import 'package:the_noire_hub_v1/features/customer/customerBookingList/presentation/screen/widget/pending_bookings.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../controller/customer_booking_list_tab_controller.dart';

class CustomerBookingsList extends StatelessWidget {
  const CustomerBookingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingTabController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 50.h),
        child: Column(
          children: [
            _buildHeader(),
            _buildStatusTabs(controller),
            Expanded(
              child: Obx(() {
                switch (controller.selectedTab.value) {
                  case "Pending": return const PendingBookings();
                  case "In Progress": return const InProgressBookings();
                  case "Complete": return const CompletedBookings();
                  case "Canceled": return const CanceledBookings();
                  default: return const CompletedBookings();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: "My Bookings", fontSize: 24.sp, fontWeight: FontWeight.bold),
          GestureDetector(
            onTap: () =>  Get.offAllNamed(
              RouteConstants.customerMainContainer,
              arguments: {'initialTab': 0},
            ),
            child: CustomText(
              text: "Start New Booking",
              fontSize: 12.sp,
              color: const Color(0xFFC4C99A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTabs(BookingTabController controller) {
    List<String> tabs = ["Pending", "In Progress", "Complete", "Canceled"];
    return Container(
      height: 55.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          children: tabs.map((tab) => Obx(() => GestureDetector(
            onTap: () => controller.changeTab(tab),
            child: _tabItem(tab, controller.selectedTab.value == tab),
          ))).toList(),
        ),
      ),
    );
  }

  Widget _tabItem(String title, bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFC4C99A) : Colors.transparent,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: CustomText(
        text: title,
        fontSize: 12.sp,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        color: isActive ? const Color(0xFF2D3E2F) : Colors.grey,
      ),
    );
  }
}