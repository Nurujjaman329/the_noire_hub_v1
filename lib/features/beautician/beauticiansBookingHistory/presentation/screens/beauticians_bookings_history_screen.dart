import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_noire_hub_v1/features/beautician/beauticiansBookingHistory/presentation/screens/widget/beauticians_booking_history_card.dart';
import 'package:the_noire_hub_v1/features/beautician/beauticiansBookingHistory/presentation/screens/widget/beauticians_cancel_booking_list.dart';
import 'package:the_noire_hub_v1/features/beautician/beauticiansBookingHistory/presentation/screens/widget/beauticians_complete_booking_list.dart';
import 'package:the_noire_hub_v1/features/beautician/beauticiansBookingHistory/presentation/screens/widget/beauticians_inProgress_booking_list.dart';
import 'package:the_noire_hub_v1/features/beautician/beauticiansBookingHistory/presentation/screens/widget/beauticians_pending_booking_list.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_text.dart';
import 'package:get/get.dart';

import '../controller/beautician_booking_history_controller.dart';


class BeauticianBookingHistoryScreen extends StatelessWidget {
  const BeauticianBookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listController = Get.find<BeauticianBookingHistoryController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 50.h),
        child: Column(
          children: [
            _buildHeader(),
            _buildStatusTabs(listController),
            Expanded(
              child: Obx(() {
                if (listController.isLoading.value && listController.bookings.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFC4C99A)));
                }

                String selectedTab = listController.selectedTab.value;
                // Note: Since API now filters by status, we use listController.bookings directly
                var displayList = listController.bookings;

                return RefreshIndicator(
                  onRefresh: () => listController.onRefresh(),
                  child: displayList.isEmpty
                      ? ListView(children: [SizedBox(height: 200.h), Center(child: CustomText(text: "No $selectedTab bookings found"))])
                      : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
                    itemCount: displayList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: CustomText(text: "$selectedTab Bookings", fontSize: 18.sp, fontWeight: FontWeight.bold),
                        );
                      }
                      return BeauticiansBookingHistoryCard(booking: displayList[index - 1], tabStatus: selectedTab);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTabs(BeauticianBookingHistoryController controller) {
    List<String> tabs = ["Pending", "In Progress", "Complete", "Canceled"];
    return Container(
      height: 55.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(30.r)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.map((tab) => Obx(() => GestureDetector(
            onTap: () => controller.changeTab(tab), // Triggers refetch in controller
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: "My Bookings", fontSize: 24.sp, fontWeight: FontWeight.bold),
          GestureDetector(
            onTap: () => Get.offAllNamed(RouteConstants.customerMainContainer, arguments: {'initialTab': 0}),
            child: CustomText(text: "Start New Booking", fontSize: 12.sp, color: const Color(0xFFC4C99A), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
