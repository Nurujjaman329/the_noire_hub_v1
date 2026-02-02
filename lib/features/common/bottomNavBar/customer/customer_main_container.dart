import 'package:flutter/material.dart';
import '../../../../core/navigationController/app_navigation_controller.dart';
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
    final navCtrl = Get.find<AppNavigationController>();
    final List<Widget> pages = [
      const CustomerServiceScreen(),
      const CustomerProductsScreen(),
      const CustomerBookingsList(),
      const MultiVendorCartScreen(),
    ];

    return Obx(() => Scaffold(
      extendBody: true,
      // Use IndexedStack to keep the scroll position of your pages
      body: IndexedStack(
        index: navCtrl.customerIndex.value,
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: navCtrl.customerIndex.value,
        onTap: navCtrl.changeCustomerIndex,
      ),
    ));
  }
}