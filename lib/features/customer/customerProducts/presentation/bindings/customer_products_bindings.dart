import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/customer_products_service.dart';
import '../controller/customer_products_controller.dart';

class CustomerProductsBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<CustomerProductsService>(
            () => CustomerProductsService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<CustomerProductsController>(
            () => CustomerProductsController(Get.find<CustomerProductsService>())
    );
  }
}