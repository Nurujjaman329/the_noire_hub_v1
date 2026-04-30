import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:the_noire_hub_v1/core/constants/app_colors.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/custom_text.dart';
import '../../../data/vendor_order_response_model.dart';
import '../../controller/vendor_order_controller.dart';


class VendorOrderHistoryCard extends StatelessWidget {
  final VendorOrderDoc order;
  final String tabStatus;

  const VendorOrderHistoryCard({
    super.key,
    required this.order,
    required this.tabStatus,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VendorOrderController>();

    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final String imageUrl = firstItem?.productImage ?? "";
    final String productName = firstItem?.productName ?? "Product Order";
    final String vendorName = order.vendor?.businessName ?? "Studio";

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.only(bottom: 15.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CustomNetworkImage(
              imageUrl: imageUrl,
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
                      child: CustomText(text: vendorName, fontSize: 14.sp, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                    ),
                    CustomText(
                      text: DateFormat('dd/MM/yyyy').format(DateTime.parse(order.createdAt)),
                      fontSize: 12.sp,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: productName + (order.items.length > 1 ? " (+${order.items.length - 1} more)" : ""),
                  fontSize: 11.sp,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "\$${order.totalAmount.toStringAsFixed(2)}",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3F592B),
                    ),
                    _buildActionButton(context, controller),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, VendorOrderController controller) {
    switch (tabStatus) {
      case "Pending":
        return GestureDetector(
          // Trigger simple confirmation instead of reason dialog
          onTap: () => _showStatusConfirmDialog(context, controller, "in-progress"),
          child: _statusBadge("Accept Order", const Color(0xFF3F592B), const Color(0xFFCADA9F)),
        );
      case "In Progress":
        return CustomText(text: "In-Progress", fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColors.background);
      case "Completed":
        return _statusBadge("Finished", const Color(0xFF2D3E2F), const Color(0xFFF5F5F5));
      case "Canceled":
        return CustomText(text: "Canceled", fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.red);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Simple Confirmation BottomSheet for Status Updates (No Reason Required)
  void _showStatusConfirmDialog(BuildContext context, VendorOrderController controller, String nextStatus) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            CustomText(
                text: "Update Order Status",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold
            ),
            SizedBox(height: 15.h),
            CustomText(
                text: "Are you sure you want to mark this order as ${nextStatus.replaceAll('-', ' ')}?",
                fontSize: 14.sp,
                textAlign: TextAlign.center,
                color: Colors.black54
            ),
            SizedBox(height: 25.h),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 48.h,
              child: controller.isStatusUpdating.value
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF3F592B)))
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F592B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))
                ),
                onPressed: () {
                  Get.back(); // Close bottom sheet
                  controller.updateStatus(order.id, nextStatus);
                },
                child: Text("Confirm ${nextStatus.capitalizeFirst}"),
              ),
            )),
            SizedBox(height: 10.h),
            TextButton(
                onPressed: () => Get.back(),
                child: const CustomText(text: "Cancel", color: Colors.grey)
            ),
            SizedBox(height: 10.h),
          ],
        ),
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