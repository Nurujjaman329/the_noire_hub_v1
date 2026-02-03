

import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/sub_categories_service.dart';
import '../controller/sub_categories_controller.dart';

class SubCategoryBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Service: Finds the global ApiClient and injects it
    Get.lazyPut<SubCategoryService>(
          () => SubCategoryService(Get.find<ApiClient>()),
    );

    // 2. Controller: Injects the service into the controller
    Get.lazyPut<SubCategoryController>(
          () => SubCategoryController(Get.find<SubCategoryService>()),
    );
  }
}