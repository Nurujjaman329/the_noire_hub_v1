import 'package:get/get.dart';

import '../../features/common/category/data/category_service.dart';
import '../../features/common/category/presentation/controller/category_controller.dart';
import '../api/api_client.dart';


class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Add these here so they are available everywhere
    Get.lazyPut<CategoryService>(() => CategoryService(Get.find<ApiClient>()));
    Get.lazyPut<CategoryController>(() => CategoryController(Get.find<CategoryService>()));
  }
}