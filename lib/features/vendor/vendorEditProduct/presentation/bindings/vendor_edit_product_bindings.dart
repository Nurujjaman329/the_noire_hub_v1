import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/vendor_edit_product_service.dart';
import '../controller/vendor_edit_product_controller.dart';


class VendorEditProductBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VendorEditProductService(Get.find<ApiClient>()));
    Get.lazyPut(() => VendorEditProductController(Get.find<VendorEditProductService>()));
  }
}