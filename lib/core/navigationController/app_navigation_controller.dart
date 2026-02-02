

import 'package:get/get.dart';

class AppNavigationController extends GetxController {
  // Observables for both panels
  var customerIndex = 0.obs;
  var vendorIndex = 0.obs;

  void changeCustomerIndex(int index) {
    customerIndex.value = index;
  }

  void changeVendorIndex(int index) {
    vendorIndex.value = index;
  }
}