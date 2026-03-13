import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/help_service.dart';
import '../controller/help_controller.dart';

class HelpBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<HelpService>(
            () => HelpService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<HelpController>(
            () => HelpController(Get.find<HelpService>())
    );
  }
}