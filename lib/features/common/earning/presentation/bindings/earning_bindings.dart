import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/earning_service.dart';
import '../controller/earning_controller.dart';

class EarningsBindings extends Bindings {
  @override
  void dependencies() {
    // Inject Service with the existing ApiClient
    Get.lazyPut(() => EarningService(Get.find<ApiClient>()));

    // Inject Controller
    Get.lazyPut(() => EarningsController(Get.find<EarningService>()));
  }
}