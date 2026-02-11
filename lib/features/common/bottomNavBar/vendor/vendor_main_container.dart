import 'package:flutter/material.dart';
import 'package:the_noire_hub_v1/features/common/bottomNavBar/vendor/vendor_bottom_navBar.dart';
import 'package:the_noire_hub_v1/features/common/bottomNavBar/vendor/vendor_main_controller.dart';
import 'package:get/get.dart';

import '../../../beautician/beauticanStoreScreen/presentation/screens/beautician_store_screen.dart';
import '../../../beautician/beauticiansBookingHistory/presentation/screens/beauticians_bookings_history_screen.dart';
import '../../../vendor/vendorOrderScreen/presentation/screens/vendor_order_screen.dart';
import '../../../vendor/vendorStoreScreen/presentation/screens/vendor_store_screen.dart';
import '../../dashboardScreen/presentation/screens/dashboard_screen.dart';
import '../../profile/presentation/profile_screen.dart';



class VendorMainContainer extends StatelessWidget {
  const VendorMainContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorMainController());

    return Obx(() {
      // Show loader if role is not yet determined
      if (controller.userRole.value.isEmpty) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            DashboardScreen(),
            controller.isVendor
                ? const VendorOrdersScreen()
                : const BeauticianBookingHistoryScreen(),
            controller.isVendor ? VendorStoreScreen() : BeauticianStoreScreen(),
            const ProfileScreen(),
          ],
        ),
        bottomNavigationBar: VendorBottomNavbar(controller: controller),
      );
    });
  }
}