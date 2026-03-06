import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:the_noire_hub_v1/features/customer/customerOrderScreen/presentation/screen/widget/order_history_tab.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../controller/customer_orders_controller.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the service is injected if not done in binding
    final controller = Get.find<CustomerOrderController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Order History", showBackButton: true),
      body: Column(
        children: [
          _buildOrderTabs(controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.orders.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFC4C99A)));
              }

              return RefreshIndicator(
                onRefresh: () => controller.onRefresh(),
                child: controller.orders.isEmpty
                    ? _buildEmptyState(controller.selectedTab.value)
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    return OrderHistoryCard(
                      order: controller.orders[index],
                      tabStatus: controller.selectedTab.value,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String tab) {
    return ListView(
      children: [
        SizedBox(height: 200.h),
        Center(child: CustomText(text: "No $tab orders found", color: Colors.grey)),
      ],
    );
  }

  Widget _buildOrderTabs(CustomerOrderController controller) {
    final tabs = ["Pending", "In Progress", "Completed", "Canceled"];
    return Obx(() => Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      height: 48.h,
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(30.r)),
      child: Row(
        children: tabs.map((tab) => _tabButton(tab, controller)).toList(),
      ),
    ));
  }

  Widget _tabButton(String title, CustomerOrderController controller) {
    bool isSelected = controller.selectedTab.value == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(title),
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
            color: isSelected ? Colors.black : Colors.black54,
            fontSize: 11.sp,
          ),
        ),
      ),
    );
  }
}