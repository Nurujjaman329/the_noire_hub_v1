import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:the_noire_hub_v1/features/customer/customerOrderScreen/presentation/screen/widget/cancel_order_list.dart';
import 'package:the_noire_hub_v1/features/customer/customerOrderScreen/presentation/screen/widget/complete_order_list.dart';
import 'package:the_noire_hub_v1/features/customer/customerOrderScreen/presentation/screen/widget/inProgress_order_list.dart';
import 'package:the_noire_hub_v1/features/customer/customerOrderScreen/presentation/screen/widget/pending_order_list.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../controller/customer_orders_controller.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerOrdersController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Order History", showBackButton: true),
      body: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Column(
          children: [
            _buildOrderTabs(controller),
            Expanded(
              child: Obx(() {
                switch (controller.selectedTab.value) {
                  case 0:
                    return const PendingOrderList();
                  case 1:
                    return const InprogressOrderList();
                  case 2:
                    return const CompletedOrdersList();
                  case 3:
                    return const CancelOrderList();
                  default:
                    return const PendingOrderList();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTabs(CustomerOrdersController controller) {
    return Obx(() => Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          _tabButton("Pending", 0, controller),
          _tabButton("In Progress", 1, controller),
          _tabButton("Completed", 2, controller),
          _tabButton("Canceled", 3, controller),
        ],
      ),
    ));
  }

  Widget _tabButton(String title, int index, CustomerOrdersController controller) {
    bool isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
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
            color: isSelected ? const Color(0xFF000000) : Color(0xB2000000),
            fontSize: 12.sp, // Slightly smaller to fit 3 tabs comfortably
          ),
        ),
      ),
    );
  }
}