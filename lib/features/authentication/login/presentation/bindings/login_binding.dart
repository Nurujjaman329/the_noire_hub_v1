import 'package:get/get.dart';
import '../../../../../core/api/api_client.dart';
import '../../data/login_service.dart';
import '../controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginService(Get.find<ApiClient>()), fenix: true);

    Get.lazyPut<LoginController>(
          () => LoginController(Get.find<LoginService>()),
      fenix: true, // <--- important!
    );
  }
}
