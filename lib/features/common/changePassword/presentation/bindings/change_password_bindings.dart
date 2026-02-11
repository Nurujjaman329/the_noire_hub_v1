

import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/change_password_service.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    // Inject Service
    Get.lazyPut<ChangePasswordService>(() => ChangePasswordService(Get.find<ApiClient>()));

    // Inject Controller
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController(Get.find<ChangePasswordService>()));
  }
}