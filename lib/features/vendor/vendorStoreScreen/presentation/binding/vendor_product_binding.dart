import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/vendor_products_service.dart';
import '../controller/vendor_product_controller.dart';

class VendorProductBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Inject Service (passing existing ApiClient)
    Get.lazyPut(() => VendorProductList(Get.find<ApiClient>()));

    // 2. Inject Controller
    Get.lazyPut(() => VendorProductController(Get.find<VendorProductList>()));
  }
}