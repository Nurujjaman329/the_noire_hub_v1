import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../../customerServices/data/customer_service_book_service.dart';
import '../controller/service_booking_details_controller.dart';


class ServiceBookingDetailsBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<CustomerServiceBookService>(
            () => CustomerServiceBookService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<ServiceBookingDetailsController>(
            () => ServiceBookingDetailsController(Get.find<CustomerServiceBookService>())
    );
  }
}