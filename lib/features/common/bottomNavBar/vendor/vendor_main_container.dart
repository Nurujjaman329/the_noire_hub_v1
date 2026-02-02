import 'package:flutter/material.dart';
import 'package:the_noire_hub_v1/features/common/bottomNavBar/vendor/vendor_bottom_navBar.dart';
import '../../../../core/accountController/account_controller.dart';
import '../../../../core/navigationController/app_navigation_controller.dart';
import '../../../beautician/beauticanStoreScreen/presentation/screens/beautician_store_screen.dart';
import '../../../beautician/beauticiansBookingHistory/presentation/screens/beauticians_bookings_history_screen.dart';
import '../../../vendor/vendorOrderScreen/presentation/screens/vendor_order_screen.dart';
import 'package:get/get.dart';

import '../../../vendor/vendorStoreScreen/presentation/screens/vendor_store_screen.dart';
import '../../dashboardScreen/presentation/screens/dashboard_screen.dart';
import '../../profile/presentation/profile_screen.dart';



class VendorMainContainer extends StatelessWidget {
  const VendorMainContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.put(AppNavigationController());
    // 1. Access the Account Controller
    final accountCtrl = Get.find<AccountController>();

    debugPrint("Vendor Main Container - Current User Type: ${accountCtrl.userType.value}, "
               "isCustomer: ${accountCtrl.isCustomer}, "
               "isVendor: ${accountCtrl.isVendor}, "
               "isBeautician: ${accountCtrl.isBeautician}");

    // 2. Define pages dynamically based on account type
    final List<Widget> _pages = [
       DashboardScreen(),

      // LOGIC: If vendor, show Orders. If beautician, show Booking History.
      accountCtrl.isVendor
          ? const VendorOrdersScreen()
          : const BeauticianBookingHistoryScreen(),

      accountCtrl.isVendor
           ? VendorStoreScreen()
           : BeauticianStoreScreen(),
      const ProfileScreen(),
    ];

    return Obx(() => Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: navCtrl.vendorIndex.value,
        children: _pages,
      ),
      bottomNavigationBar: VendorBottomNavbar(
        currentIndex: navCtrl.vendorIndex.value,
        onTap: navCtrl.changeVendorIndex,
      ),
    ));
  }
}