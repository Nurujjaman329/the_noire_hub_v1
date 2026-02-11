import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/vendor_product_details_service.dart';
import '../controller/vendor_product_details_controller.dart';

class VendorProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VendorProductDetailsService(Get.find<ApiClient>()));
    Get.lazyPut(() => VendorProductDetailsController(Get.find<VendorProductDetailsService>()));
  }
}