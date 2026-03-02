import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../../customerProducts/data/customer_products_service.dart';
import '../controller/product_details_controller.dart';

class ProductDetailsBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<CustomerProductsService>(
            () => CustomerProductsService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<ProductDetailsController>(
            () => ProductDetailsController(Get.find<CustomerProductsService>())
    );
  }
}