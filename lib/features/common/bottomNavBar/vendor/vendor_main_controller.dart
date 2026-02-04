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
    // 1. Try to get role from navigation arguments (fastest/safest)
    final args = Get.arguments;
    if (args is Map && args.containsKey('role')) {
      userRole.value = args['role'];
      debugPrint("✅ Role set from Arguments: ${userRole.value}");
      return;
    }

    // 2. Fallback: Get from Local Storage if Arguments are missing
    final userData = LocalStorage.getUserData();
    if (userData != null && userData['role'] != null) {
      userRole.value = userData['role'].toString().toLowerCase();
      debugPrint("🏠 Role set from Local Storage: ${userRole.value}");
    } else {
      // 3. Last resort fallback
      userRole.value = 'vendor';
      debugPrint("⚠️ Role fallback used: vendor");
    }
  }

  bool get isVendor => userRole.value == 'vendor';

  void changeIndex(int index) => currentIndex.value = index;

  List<Widget> getPages() {
    // We use the reactive userRole.value here
    return [
      DashboardScreen(),
      isVendor ? const VendorOrdersScreen() : const BeauticianBookingHistoryScreen(),
      isVendor ? VendorStoreScreen() : BeauticianStoreScreen(),
      const ProfileScreen(),
    ];
  }
}