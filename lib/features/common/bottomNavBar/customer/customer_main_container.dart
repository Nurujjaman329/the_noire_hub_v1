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
import 'customer_main_controller.dart';

class CustomerMainContainer extends StatelessWidget {
  const CustomerMainContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // final RxInt currentIndex = (Get.arguments?['initialTab'] ?? 0).obs;
    final currentIndex = RxInt(Get.arguments?['initialTab'] ?? 0);
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
