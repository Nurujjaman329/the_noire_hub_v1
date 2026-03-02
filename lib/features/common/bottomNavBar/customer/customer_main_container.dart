import 'package:flutter/material.dart';
import '../../../customer/customerBookingList/presentation/screen/customer_bookings_list.dart';
import '../../../customer/customerProducts/presentation/customer_products_screen.dart';
import '../../../customer/customerServices/presentation/customer_service_screen.dart';
import '../../../customer/multiVendorCartScreen/presentation/screen/multi_vendor_cart_screen.dart';
import 'custom_bottom_navBar.dart';
import 'package:get/get.dart';

class CustomerMainContainer extends StatelessWidget {
  const CustomerMainContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get the arguments safely
    final args = Get.arguments;
    int initialTab = 0;

    // 2. Check if arguments is actually a Map before accessing 'initialTab'
    if (args is Map<String, dynamic> || args is Map) {
      initialTab = args['initialTab'] ?? 0;
    } else if (args is int) {
      // Handle cases where only an integer is passed
      initialTab = args;
    }

    final currentIndex = RxInt(initialTab);

    final List<Widget> pages = [
      const CustomerServiceScreen(),
      const CustomerProductsScreen(),
      const CustomerBookingsList(),
      const MultiVendorCartScreen(),
    ];

    return Obx(() => Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex.value,
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: currentIndex.value,
        onTap: (index) => currentIndex.value = index,
      ),
    ));
  }
}