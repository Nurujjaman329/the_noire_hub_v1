import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/storage/local_storage.dart';
import '../../../beautician/beauticanStoreScreen/presentation/screens/beautician_store_screen.dart';
import '../../../beautician/beauticiansBookingHistory/presentation/screens/beauticians_bookings_history_screen.dart';
import '../../../vendor/vendorOrderScreen/presentation/screens/vendor_order_screen.dart';
import '../../../vendor/vendorStoreScreen/presentation/screens/vendor_store_screen.dart';
import '../../dashboardScreen/presentation/screens/dashboard_screen.dart';
import '../../profile/presentation/profile_screen.dart';

enum Role { vendor, beautician }

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

    // 2. Fallback: Use LocalStorage
    final user = LocalStorage.getUserModel();
    userRole.value = user?.role.toLowerCase() ?? 'vendor';
    debugPrint("🏠 Role set from LocalStorage or fallback: ${userRole.value}");
  }

  // ===== Role helpers =====
  Role get role {
    if (userRole.value.contains('vendor')) return Role.vendor;
    if (userRole.value.contains('beautician')) return Role.beautician;
    return Role.vendor; // fallback
  }

  bool get isVendor => role == Role.vendor;
  bool get isBeautician => role == Role.beautician;

  // ===== Navigation =====
  void changeIndex(int index) => currentIndex.value = index;

  // ===== Centralized tab navigation =====
  void goToTab(int index) {
    currentIndex.value = index;

    // Close drawer or overlay if open
    if (Get.isOverlaysOpen) Get.back();
  }

  // ===== Pages =====
  List<Widget> getPages() {
    return [
      DashboardScreen(),
      isVendor
          ? const VendorOrdersScreen()
          : const BeauticianBookingHistoryScreen(),
      isVendor ? VendorStoreScreen() : BeauticianStoreScreen(),
      const ProfileScreen(),
    ];
  }
}
