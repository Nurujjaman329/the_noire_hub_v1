import 'package:flutter/material.dart';
import '../../../../core/navigationController/app_navigation_controller.dart';
import '../../../customer/customerBookingList/presentation/screen/customer_bookings_list.dart';
import '../../../customer/customerProducts/presentation/customer_products_screen.dart';
import '../../../customer/customerServices/presentation/customer_service_screen.dart';
import '../../../customer/multiVendorCartScreen/presentation/screen/multi_vendor_cart_screen.dart';
import 'custom_bottom_navBar.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../customer/customerBookingList/presentation/screen/customer_bookings_list.dart';
import '../../../customer/customerProducts/presentation/customer_products_screen.dart';
import '../../../customer/customerServices/presentation/customer_service_screen.dart';
import '../../../customer/multiVendorCartScreen/presentation/screen/multi_vendor_cart_screen.dart';
import 'custom_bottom_navBar.dart';

class CustomerMainContainer extends StatelessWidget {
  const CustomerMainContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Define a local reactive index
    final RxInt currentIndex = 0.obs;

    final List<Widget> pages = [
      const CustomerServiceScreen(),
      const CustomerProductsScreen(),
      const CustomerBookingsList(),
      const MultiVendorCartScreen(),
    ];

    return Obx(() => Scaffold(
      extendBody: true,
      // IndexedStack prevents pages from rebuilding when switching tabs
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