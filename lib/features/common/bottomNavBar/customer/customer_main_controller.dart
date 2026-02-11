// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
//
// import '../../../customer/customerBookingList/presentation/screen/customer_bookings_list.dart';
// import '../../../customer/customerProducts/presentation/customer_products_screen.dart';
// import '../../../customer/customerServices/presentation/customer_service_screen.dart';
// import '../../../customer/multiVendorCartScreen/presentation/screen/multi_vendor_cart_screen.dart';
//
//
// class CustomerMainController extends GetxController {
//   var currentIndex = 0.obs;
//
//   // Centralized navigation
//   void goToTab(int index) {
//     currentIndex.value = index;
//     if (Get.isOverlaysOpen) Get.back();
//   }
//
//   // Pages
//   List<Widget> get pages => [
//     const CustomerServiceScreen(),
//     const CustomerProductsScreen(),
//     const CustomerBookingsList(),
//     const MultiVendorCartScreen(),
//   ];
// }
