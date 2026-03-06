import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/service_details_service.dart';
import '../controller/service_details_controller.dart';

class ServiceDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceDetailsService(Get.find<ApiClient>()));

    // Retrieve the ID passed from Get.toNamed(..., arguments: id)
    final String serviceId = Get.arguments as String;

    Get.lazyPut(() => ServiceDetailsController(
      Get.find<ServiceDetailsService>(),
      serviceId: serviceId,
    ));
  }
}