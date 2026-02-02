import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              CustomText(
                text: "Bookings",
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: ListView(
                  children: [
                    _buildBookingCard(
                      "Hair Appointment",
                      "Braids By Mia",
                      "Jan 15, 2026 • 2:00 PM",
                      "Confirmed",
                      Colors.green,
                    ),
                    _buildBookingCard(
                      "Makeup Session",
                      "Beauty Studio",
                      "Jan 20, 2026 • 11:00 AM",
                      "Pending",
                      Colors.orange,
                    ),
                    _buildBookingCard(
                      "Nail Service",
                      "Nail Paradise",
                      "Feb 5, 2026 • 3:30 PM",
                      "Cancelled",
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(String service, String business, String dateTime, String status, Color statusColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: CustomText(
                  text: service,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: CustomText(
                  text: status,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: statusColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          CustomText(
            text: business,
            fontSize: 14.sp,
            color: Colors.grey,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.access_time, size: 14.sp, color: Colors.grey),
              SizedBox(width: 5.w),
              CustomText(
                text: dateTime,
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryDark),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
                child: CustomText(
                  text: "View Details",
                  fontSize: 12.sp,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}