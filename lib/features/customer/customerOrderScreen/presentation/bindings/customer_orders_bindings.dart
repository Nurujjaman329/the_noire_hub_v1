import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/customer_orders_service.dart';
import '../controller/customer_orders_controller.dart';

class CustomerOrdersBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<CustomerOrdersService>(
            () => CustomerOrdersService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<CustomerOrderController>(
            () => CustomerOrderController(Get.find<CustomerOrdersService>())
    );
  }
}