import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/vendor_order_service.dart';
import '../controller/vendor_order_controller.dart';

class VendorOrderBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<VendorOrderService>(
            () => VendorOrderService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<VendorOrderController>(
            () => VendorOrderController(Get.find<VendorOrderService>())
    );
  }
}