import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/multi_vendor_cart_service.dart';
import '../controller/multi_vendor_cart_controller.dart';

class MultiVendorCartBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<MultiVendorCartService>(
            () => MultiVendorCartService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<MultiVendorCartController>(
            () => MultiVendorCartController(Get.find<MultiVendorCartService>())
    );
  }
}