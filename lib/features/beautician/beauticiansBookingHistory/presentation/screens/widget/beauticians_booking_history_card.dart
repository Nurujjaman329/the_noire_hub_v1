import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/custom_text.dart';
import '../../../data/beautician_booking_history_response_model.dart';
import '../../controller/beautician_booking_history_controller.dart';


class BeauticiansBookingHistoryCard extends StatelessWidget {
  final BeauticianBookingDoc booking;
  final String tabStatus;

  const BeauticiansBookingHistoryCard({
    super.key,
    required this.booking,
    required this.tabStatus,
  });

  @override
  Widget build(BuildContext context) {
    final listController = Get.find<BeauticianBookingHistoryController>();
    String formattedDate = booking.appointmentDate != null
        ? DateFormat('dd/MM/yyyy').format(booking.appointmentDate!)
        : "N/A";

    return GestureDetector(
      onTap: () => _showBookingDetails(context, formattedDate),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.only(bottom: 15.h),
        decoration: const BoxDecoration(
          color: Colors.transparent,
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
                          color: Colors.black.withValues(alpha: 0.7)),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                      text: "Time: ${booking.appointmentTime}",
                      fontSize: 10.sp,
                      color: Colors.black.withValues(alpha: 0.7)),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "\$${booking.totalAmount.toStringAsFixed(2)}",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3F592B).withValues(alpha: 0.8),
                      ),
                      _buildActionButton(context, listController),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ACCEPT DIALOG (Yes/No) ---
  void _showAcceptDialog(BuildContext context, BeauticianBookingHistoryController controller) {
    Get.defaultDialog(
      title: "Accept Booking",
      middleText: "Do you want to accept this booking request?",
      titleStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      middleTextStyle: TextStyle(fontSize: 14.sp),
      radius: 15.r,
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.all(20.w),
      textCancel: "No",
      cancelTextColor: Colors.black54,
      onCancel: () => Get.back(),
      textConfirm: "Yes, Accept",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF3F592B),
      onConfirm: () {
        Get.back();
        controller.acceptBooking(booking.id);
      },
    );
  }

  // --- ACTION BUTTON BUILDER ---
  Widget _buildActionButton(BuildContext context, BeauticianBookingHistoryController controller) {
    switch (tabStatus) {
      case "Pending":
        return GestureDetector(
          onTap: () => _showAcceptDialog(context, controller),
          child: _statusBadge("Accept", const Color(0xFF3F592B), const Color(0xFFCADA9F).withValues(alpha: 0.3)),
        );

      case "In Progress":
        return CustomText(
            text: "In Progress",
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF3F592B)
        );

      case "Complete":
        return CustomText(
            text: "Completed",
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D3E2F)
        );

      case "Canceled":
        return CustomText(
            text: "Canceled",
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: Colors.red
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // --- DETAILS MODAL ---
  void _showBookingDetails(BuildContext context, String date) {
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r)),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: CustomNetworkImage(
                      imageUrl: booking.service?.image ?? "",
                      height: 80.h,
                      width: 80.w,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: booking.service?.name ?? "Booking Details", fontSize: 18.sp, fontWeight: FontWeight.bold),
                        SizedBox(height: 5.h),
                        _statusBadge(tabStatus, const Color(0xFF2D3E2F), const Color(0xFFC4C99A).withValues(alpha: 0.4)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              _detailRow("Booking ID", "#${booking.id.substring(booking.id.length - 8)}"),
              _detailRow("Date", date),
              _detailRow("Time", booking.appointmentTime),
              _detailRow("Payment", booking.paymentStatus.toUpperCase()),
              Divider(height: 30.h, color: Colors.grey[200]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(text: "Total Amount", fontSize: 16.sp, fontWeight: FontWeight.bold),
                  CustomText(
                    text: "\$${booking.totalAmount.toStringAsFixed(2)}",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3F592B),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D3E2F),
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
                  ),
                  onPressed: () => Get.back(),
                  child: CustomText(text: "Close", color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: label, fontSize: 14.sp, color: Colors.grey[600]),
          CustomText(text: value, fontSize: 14.sp, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  Widget _statusBadge(String label, Color textColor, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20.r)),
      child: CustomText(text: label, fontSize: 11.sp, fontWeight: FontWeight.w600, color: textColor),
    );
  }
}