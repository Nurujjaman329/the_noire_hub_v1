
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_noire_hub_v1/features/vendor/vendorOrderScreen/presentation/screens/widget/vendor_order_history_card.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../controller/vendor_order_controller.dart';

class VendorOrdersScreen extends StatelessWidget {
  const VendorOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the service is injected if not done in binding
    final controller = Get.find<VendorOrderController>();

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
                    return VendorOrderHistoryCard(
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

  Widget _buildOrderTabs(VendorOrderController controller) {
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

  Widget _tabButton(String title, VendorOrderController controller) {
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