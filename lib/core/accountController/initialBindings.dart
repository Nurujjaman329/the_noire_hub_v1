import 'package:get/get.dart';

import '../navigationController/app_navigation_controller.dart';
import 'account_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountController(), permanent: true);
    // Put other global controllers here
    Get.put(AppNavigationController(), permanent: true);
  }
}