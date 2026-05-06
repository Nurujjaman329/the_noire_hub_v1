import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/route_constants.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/custom_text.dart';
import '../../../data/customer_orders_response_model.dart';
import '../../controller/customer_orders_controller.dart';


class OrderHistoryCard extends StatelessWidget {
  final OrderDoc order;
  final String tabStatus;

  const OrderHistoryCard({
    super.key,
    required this.order,
    required this.tabStatus,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerOrderController>();

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

  Widget _buildActionButton(BuildContext context, CustomerOrderController controller) {
    switch (tabStatus) {
      case "Pending":
        return GestureDetector(
          onTap: () => _showCancelDialog(context, controller),
          child: _statusBadge("Cancel", const Color(0xFFFF0000), const Color(0xFFFF0000).withValues(alpha: 0.1)),
        );
      case "In Progress":
        return GestureDetector(
          onTap: () => _showCompleteDialog(context, controller),
          child: _statusBadge("Complete", Colors.white, const Color(0xFF2D3E2F)),
        );
      case "Completed":
        return GestureDetector(
          onTap: () => Get.toNamed(RouteConstants.productRatingScreen, arguments: order),
          child: _statusBadge("Review", const Color(0xFF2D3E2F), const Color(0xFFC4C99A)),
        );
      case "Canceled":
        return CustomText(text: "Canceled", fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.red);
      default:
        return const SizedBox.shrink();
    }
  }

  void _showCompleteDialog(BuildContext context, CustomerOrderController controller) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, size: 48.sp, color: const Color(0xFF2D3E2F)),
              SizedBox(height: 16.h),
              CustomText(text: "Confirm Order Received", fontSize: 16.sp, fontWeight: FontWeight.bold),
              SizedBox(height: 8.h),
              CustomText(
                text: "Have you received your order? This action cannot be undone.",
                fontSize: 12.sp,
                color: Colors.black54,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2D3E2F)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: const Text("Cancel", style: TextStyle(color: Color(0xFF2D3E2F))),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed: controller.isCompleting.value ? null : () {
                        Get.back();
                        controller.handleComplete(order.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D3E2F),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: controller.isCompleting.value
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("Confirm", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, CustomerOrderController controller) {
    final reasonController = TextEditingController();

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, MediaQuery.of(context).viewInsets.bottom + 20.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(text: "Cancel Order", fontSize: 18.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 15.h),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                  hintText: "Reason for cancellation...",
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none)
              ),
            ),
            SizedBox(height: 20.h),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 48.h,
              child: controller.isCanceling.value
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF3F592B)))
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0000),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))
                ),
                onPressed: () {
                  if(reasonController.text.trim().isEmpty) {
                    Get.snackbar("Required", "Please provide a reason", snackPosition: SnackPosition.BOTTOM);
                    return;
                  }
                  Get.back(); // Close bottom sheet
                  controller.handleCancel(order.id, reasonController.text.trim());
                },
                child: const Text("Confirm Cancellation"),
              ),
            )),
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