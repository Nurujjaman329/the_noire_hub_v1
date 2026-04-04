import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/about_us_service.dart';
import '../controller/about_us_controller.dart';

class AboutUsBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<AboutUsService>(
            () => AboutUsService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<AboutUsController>(
            () => AboutUsController(Get.find<AboutUsService>())
    );
  }
}