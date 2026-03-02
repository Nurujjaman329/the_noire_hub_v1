import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/customer_booking_list_service.dart';
import '../controller/customer_booking_list_controller.dart';

class CustomerBookingListBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<CustomerBookingListService>(
            () => CustomerBookingListService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<CustomerBookingListController>(
            () => CustomerBookingListController(Get.find<CustomerBookingListService>())
    );
  }
}