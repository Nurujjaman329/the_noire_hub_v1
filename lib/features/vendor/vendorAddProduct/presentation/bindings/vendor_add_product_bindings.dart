import 'package:get/get.dart';
import '../../../../../core/api/api_client.dart';
import '../../data/vendor_add_product_service.dart';
import '../controller/vendor_add_product_controller.dart';

class VendorAddProductBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VendorAddProductService(Get.find<ApiClient>()));
    Get.lazyPut(() => VendorAddProductController(Get.find<VendorAddProductService>()));
  }
}