import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/customer_service_book_service.dart';
import '../controller/customer_service_controller.dart';

class CustomerServiceBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<CustomerServiceBookService>(
            () => CustomerServiceBookService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<CustomerServiceController>(
            () => CustomerServiceController(Get.find<CustomerServiceBookService>())
    );
  }
}