import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/registration_service.dart';
import '../controller/registration_controller.dart';


class RegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistrationService>(() => RegistrationService(Get.find<ApiClient>()));
    Get.lazyPut<RegistrationController>(() => RegistrationController(Get.find<RegistrationService>()));
  }
}