import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/route_constants.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/custom_text.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../../data/customer_booking_list_response_model.dart';

class BookingCard extends StatelessWidget {
  final BookingDoc booking;
  final String tabStatus;

  const BookingCard({
    super.key,
    required this.booking,
    required this.tabStatus,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = booking.appointmentDate != null
        ? DateFormat('dd/MM/yyyy').format(booking.appointmentDate!)
        : "N/A";

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.only(bottom: 15.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.r),
            child: CustomNetworkImage(
              imageUrl: booking.service?.image ?? "",
              height: 70.h,
              width: 70.w,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: booking.service?.name ?? "Service",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CustomText(
                        text: formattedDate,
                        fontSize: 12.sp,
                        color: Colors.black.withOpacity(0.7)
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                CustomText(
                    text: "Time: ${booking.appointmentTime}",
                    fontSize: 10.sp,
                    color: Colors.black.withOpacity(0.7)
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "\$${booking.totalAmount.toStringAsFixed(2)}",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3F592B).withOpacity(0.8),
                    ),
                    _buildActionButton(context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    switch (tabStatus) {
      case "Pending":
        return GestureDetector(
          onTap: () => _showActionDialog(context, "Cancel Booking", "Are you sure you want to cancel?"),
          child: _statusBadge("Cancel", const Color(0xFFFF0000), const Color(0xFFFF0000).withOpacity(0.1)),
        );
      case "In Progress":
        return _statusBadge("Processing", const Color(0xFF3F592B), const Color(0xFFCADA9F).withOpacity(0.3));
      case "Complete":
        return GestureDetector(
          onTap: () => Get.toNamed(RouteConstants.rateServiceScreen, arguments: booking.id),
          child: _statusBadge("Review", const Color(0xFF2D3E2F), const Color(0xFFC4C99A)),
        );
      case "Canceled":
        return CustomText(
          text: "Canceled",
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _statusBadge(String label, Color textColor, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        text: label,
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  void _showActionDialog(BuildContext context, String title, String content) {
    Get.defaultDialog(
      title: title,
      middleText: content,
      textConfirm: "Confirm",
      textCancel: "Back",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF3F592B),
      onConfirm: () {
        Get.back();
        // Trigger cancel API call here via listController if needed
      },
    );
  }
}