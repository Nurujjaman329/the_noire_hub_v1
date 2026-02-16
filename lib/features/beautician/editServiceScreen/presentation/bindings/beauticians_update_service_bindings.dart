import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/beauticians_update_service.dart';
import '../controller/beauticians_update_service_controller.dart';

class BeauticiansUpdateServiceBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject Service (passing existing ApiClient)
    Get.lazyPut(() => BeauticiansUpdateService(Get.find<ApiClient>()));

    // 2. Inject Controller
    Get.lazyPut(() => BeauticiansUpdateServiceController(Get.find<BeauticiansUpdateService>()));
  }
}