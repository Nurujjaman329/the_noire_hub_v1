import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/customer_deals_promos_service.dart';
import '../controller/customer_deals_promos_controller.dart';

class CustomerDealsPromosBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<CustomerDealsPromosService>(
            () => CustomerDealsPromosService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<CustomerDealsPromosController>(
            () => CustomerDealsPromosController(Get.find<CustomerDealsPromosService>())
    );
  }
}