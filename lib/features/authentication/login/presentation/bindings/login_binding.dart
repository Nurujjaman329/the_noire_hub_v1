import 'package:get/get.dart';
import '../../../../../core/api/api_client.dart';
import '../../data/login_service.dart';
import '../controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Find the existing ApiClient, then inject LoginService
    Get.lazyPut(() => LoginService(Get.find<ApiClient>()), fenix: true);

    Get.lazyPut<LoginController>(
          () => LoginController(Get.find<LoginService>()),
      fenix: true,
    );
  }
}