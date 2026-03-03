import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/route_constants.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/custom_text.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../../data/customer_booking_list_response_model.dart';
import '../../controller/customer_booking_list_controller.dart';


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
    final listController = Get.find<CustomerBookingListController>();
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
                          color: Colors.black.withOpacity(0.7)),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                      text: "Time: ${booking.appointmentTime}",
                      fontSize: 10.sp,
                      color: Colors.black.withOpacity(0.7)),
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

  // --- CANCELLATION DIALOG WITH REASON ---
  void _showCancelDialog(BuildContext context, CustomerBookingListController controller) {
    final reasonController = TextEditingController();

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r)),
              ),
            ),
            SizedBox(height: 20.h),
            CustomText(text: "Cancel Booking", fontSize: 18.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 10.h),
            CustomText(text: "Please provide a reason for canceling this appointment.", fontSize: 13.sp, color: Colors.grey),
            SizedBox(height: 20.h),

            TextField(
              controller: reasonController,
              maxLines: 3,
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: "Enter reason here...",
                hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 25.h),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
                    ),
                    onPressed: () => Get.back(),
                    child: CustomText(text: "Back", color: Colors.black),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000),
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
                    ),
                    onPressed: controller.isCanceling.value
                        ? null
                        : () {
                      if (reasonController.text.trim().isEmpty) {
                        Get.snackbar("Required", "Please enter a reason", snackPosition: SnackPosition.BOTTOM);
                        return;
                      }
                      Get.back(); // Close bottom sheet
                      controller.cancelBooking(booking.id, reasonController.text.trim());
                    },
                    child: controller.isCanceling.value
                        ? SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    )
                        : CustomText(text: "Confirm Cancel", color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
                        _statusBadge(tabStatus, const Color(0xFF2D3E2F), const Color(0xFFC4C99A).withOpacity(0.4)),
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


  void _showCompleteDialog(BuildContext context, CustomerBookingListController controller) {
    Get.defaultDialog(
      title: "Complete Service",
      middleText: "Are you sure you want to mark this service as completed?",
      titleStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF2D3E2F)),
      middleTextStyle: TextStyle(fontSize: 14.sp),
      backgroundColor: Colors.white,
      radius: 20.r,
      contentPadding: EdgeInsets.all(20.w),
      // Cancel Button
      textCancel: "No",
      cancelTextColor: Colors.black54,
      onCancel: () => Get.back(),
      // Confirm Button
      textConfirm: "Yes, Completed",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF3F592B),
      onConfirm: () {
        Get.back(); // Close dialog
        controller.completeBooking(booking.id);
      },
    );
  }

  Widget _buildActionButton(BuildContext context, CustomerBookingListController controller) {
    switch (tabStatus) {
      case "Pending":
        return GestureDetector(
          onTap: () => _showCancelDialog(context, controller),
          child: _statusBadge("Cancel", const Color(0xFFFF0000), const Color(0xFFFF0000).withOpacity(0.1)),
        );
      case "In Progress":
        return GestureDetector(
          // 👈 Trigger the alert here
          onTap: () => _showCompleteDialog(context, controller),
          child: _statusBadge("Complete", const Color(0xFF3F592B), const Color(0xFFCADA9F).withOpacity(0.3)),
        );
      case "Complete":
        return GestureDetector(
          onTap: () => Get.toNamed(RouteConstants.rateServiceScreen, arguments: booking.id),
          child: _statusBadge("Review", const Color(0xFF2D3E2F), const Color(0xFFC4C99A)),
        );
      case "Canceled":
        return CustomText(text: "Canceled", fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.red);
      default:
        return const SizedBox.shrink();
    }
  }


  Widget _statusBadge(String label, Color textColor, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20.r)),
      child: CustomText(text: label, fontSize: 11.sp, fontWeight: FontWeight.w600, color: textColor),
    );
  }
}