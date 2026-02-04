import 'package:get/get.dart';

import '../../features/common/category/data/category_service.dart';
import '../../features/common/category/presentation/controller/category_controller.dart';
import '../../features/common/subCategories/data/sub_categories_service.dart';
import '../../features/common/subCategories/presentation/controller/sub_categories_controller.dart';
import '../api/api_client.dart';


class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Categories - Added fenix: true
    Get.lazyPut<CategoryService>(() => CategoryService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<CategoryController>(() => CategoryController(Get.find<CategoryService>()), fenix: true);

    // SubCategories - Added fenix: true
    Get.lazyPut<SubCategoryService>(() => SubCategoryService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<SubCategoryController>(() => SubCategoryController(Get.find<SubCategoryService>()), fenix: true);
  }
}