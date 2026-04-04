import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/terms_of_service.dart';
import '../controller/terms_of_service_controller.dart';

class TermsOfServiceBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<TermsOfService>(
            () => TermsOfService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<TermsOfServiceController>(
            () => TermsOfServiceController(Get.find<TermsOfService>())
    );
  }
}