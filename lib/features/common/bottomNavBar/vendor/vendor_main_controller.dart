import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../beautician/beauticanStoreScreen/presentation/screens/beautician_store_screen.dart';
import '../../../beautician/beauticiansBookingHistory/presentation/screens/beauticians_bookings_history_screen.dart';
import '../../../vendor/vendorOrderScreen/presentation/screens/vendor_order_screen.dart';
import '../../../vendor/vendorStoreScreen/presentation/screens/vendor_store_screen.dart';
import '../../dashboardScreen/presentation/screens/dashboard_screen.dart';
import '../../profile/presentation/profile_screen.dart';

import '../../../../core/services/cache_service.dart';

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
    // 1. Try to get role from navigation arguments (Fastest)
    final args = Get.arguments;
    if (args is Map && args.containsKey('role')) {
      userRole.value = args['role'].toString().toLowerCase();
      debugPrint("✅ Role set from Arguments: ${userRole.value}");
      return;
    }

    // 2. Fallback: Use your new static CacheService (No more LocalStorage!)
    // This is just a simple String lookup now.
    final storedRole = CacheService.role.toLowerCase();

    if (storedRole.isNotEmpty) {
      userRole.value = storedRole;
      debugPrint("🏠 Role set from CacheService: ${userRole.value}");
    } else {
      userRole.value = 'vendor'; // Absolute fallback
      debugPrint("⚠️ No role found, falling back to: vendor");
    }
  }

  // ===== Role helpers =====
  Role get role {
    if (userRole.value.contains('vendor')) return Role.vendor;
    if (userRole.value.contains('beautician')) return Role.beautician;
    return Role.vendor;
  }

  bool get isVendor => role == Role.vendor;
  bool get isBeautician => role == Role.beautician;

  // ===== Navigation =====
  void changeIndex(int index) => currentIndex.value = index;

  void goToTab(int index) {
    currentIndex.value = index;
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