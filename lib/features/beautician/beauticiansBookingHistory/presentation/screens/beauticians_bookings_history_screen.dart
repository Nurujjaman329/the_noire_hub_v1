import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_noire_hub_v1/features/beautician/beauticiansBookingHistory/presentation/screens/widget/beauticians_cancel_booking_list.dart';
import 'package:the_noire_hub_v1/features/beautician/beauticiansBookingHistory/presentation/screens/widget/beauticians_complete_booking_list.dart';
import 'package:the_noire_hub_v1/features/beautician/beauticiansBookingHistory/presentation/screens/widget/beauticians_inProgress_booking_list.dart';
import 'package:the_noire_hub_v1/features/beautician/beauticiansBookingHistory/presentation/screens/widget/beauticians_pending_booking_list.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_text.dart';


class BeauticianBookingHistoryScreen extends StatefulWidget {
  const BeauticianBookingHistoryScreen({super.key});

  @override
  State<BeauticianBookingHistoryScreen> createState() => _BeauticianBookingHistoryScreenState();
}

class _BeauticianBookingHistoryScreenState extends State<BeauticianBookingHistoryScreen> {
  // Local state to track selected tab
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Booking History",),
      body: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Column(
          children: [
            _buildBookingTabs(),
            Expanded(
              child: _buildBookingList(),
            ),
          ],
        ),
      ),
    );
  }

  // Logic to switch between views based on local state
  Widget _buildBookingList() {
    switch (selectedTabIndex) {
      case 0:
        return const BeauticiansPendingBookingList();
      case 1:
        return const BeauticiansInprogressBookingList();
      case 2:
        return const BeauticiansCompleteBookingList();
      case 3:
        return const BeauticiansCancelBookingList();
      default:
        return const BeauticiansPendingBookingList();
    }
  }

  Widget _buildBookingTabs() {
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