import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/storage/local_storage.dart';
import '../../../beautician/beauticanStoreScreen/presentation/screens/beautician_store_screen.dart';
import '../../../beautician/beauticiansBookingHistory/presentation/screens/beauticians_bookings_history_screen.dart';
import '../../../vendor/vendorOrderScreen/presentation/screens/vendor_order_screen.dart';
import '../../../vendor/vendorStoreScreen/presentation/screens/vendor_store_screen.dart';
import '../../dashboardScreen/presentation/screens/dashboard_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class VendorMainController extends GetxController {
  var currentIndex = 0.obs;
  var userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _determineRole();
  }

  void _determineRole() {
    // 1. Try to get role from navigation arguments
    final args = Get.arguments;
    if (args is Map && args.containsKey('role')) {
      userRole.value = args['role'].toString().toLowerCase();
      debugPrint("✅ Role set from Arguments: ${userRole.value}");
      return;
    }

    // 2. Fallback: Use the strongly-typed getUserModel() from our new LocalStorage
    final user = LocalStorage.getUserModel();
    if (user != null) {
      userRole.value = user.role.toLowerCase();
      debugPrint("🏠 Role set from LocalStorage (UserModel): ${userRole.value}");
    } else {
      // 3. Last resort fallback
      userRole.value = 'vendor';
      debugPrint("⚠️ Role fallback used: vendor");
    }
  }

  // Helpers for cleaner UI logic
  bool get isVendor => userRole.value.contains('vendor');
  bool get isBeautician => userRole.value.contains('beautician');

  void changeIndex(int index) => currentIndex.value = index;

  List<Widget> getPages() {
    return [
      DashboardScreen(),
      // Dynamic screens based on role
      isVendor ? const VendorOrdersScreen() : const BeauticianBookingHistoryScreen(),
      isVendor ? VendorStoreScreen() : BeauticianStoreScreen(),
      const ProfileScreen(),
    ];
  }
}