import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/route_constants.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/custom_text.dart';


class OrderHistoryCard extends StatelessWidget {
  final String studioName;
  final String serviceName;
  final String date;
  final String status; // "Pending", "In Progress", "Complete", "Canceled"

  const OrderHistoryCard({
    super.key,
    required this.studioName,
    required this.serviceName,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
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
              imageUrl: "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=200",
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
                    CustomText(text: studioName, fontSize: 14.sp, fontWeight: FontWeight.bold),
                    CustomText(
                        text: "05/10/2020",
                        fontSize: 12.sp,
                        color: const Color(0xFF000000).withValues(alpha:0.7)
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                CustomText(
                    text: serviceName,
                    fontSize: 10.sp,
                    color: const Color(0xFF000000).withValues(alpha:0.7)
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "\$175.89",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3F592B).withValues(alpha:0.8),
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
    switch (status) {
      case "Pending":
        return GestureDetector(
          onTap: () => _showActionDialog(context, "Cancel Order", "Are you sure you want to cancel?"),
          child: _statusBadge("Cancel", const Color(0xFFFF0000), const Color(0xFFFF0000).withValues(alpha:0.25)),
        );
      case "In Progress":
        return GestureDetector(
          onTap: () => _showActionDialog(context, "Mark as Complete", "Is the service finished?"),
          child: _statusBadge("Complete", const Color(0xFF3F592B), const Color(0xFFCADA9F)),
        );
      case "Complete":
        return GestureDetector(
          onTap: () {
            Get.toNamed(RouteConstants.rateServiceScreen);
          },
          child: _statusBadge("Review", const Color(0xFF2D3E2F), const Color(0xFFC4C99A)),
        );
      case "Canceled":
        return CustomText(
          text: "Canceled",
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color:  Colors.red,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _statusBadge(String label, Color textColor, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        text: label,
        fontSize: 12.sp,
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
        // Add logic to update status here
      },
    );
  }
}