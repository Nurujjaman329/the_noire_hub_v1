import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/category_service.dart';
import '../controller/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    // Use Get.find to get the global ApiClient you set in main.dart
    Get.lazyPut<CategoryService>(() => CategoryService(Get.find<ApiClient>()));

    // Inject the controller
    Get.lazyPut<CategoryController>(() => CategoryController(Get.find<CategoryService>()));
  }
}