import 'package:get/get.dart';
import '../../../../../core/api/api_client.dart';
import '../../data/login_service.dart';
import '../controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Create the API client instance
    final apiClient = ApiClient();
    
    // Create the login service with the API client
    Get.lazyPut<LoginService>(() => LoginService(apiClient));
    
    // Create the login controller with the login service
    Get.lazyPut<LoginController>(() => LoginController(Get.find<LoginService>()));
  }
}