import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/reset_password_service.dart';
import '../controller/reset_password_controller.dart';


class ResetPasswordBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Find the existing ApiClient and pass it to the service
    Get.lazyPut<ResetPasswordService>(() => ResetPasswordService(Get.find<ApiClient>()));

    // 2. Pass the service to the controller
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController(Get.find<ResetPasswordService>()));
  }
}