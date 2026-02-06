import 'package:get/get.dart';
import '../api/api_client.dart';
import '../../features/authentication/login/data/login_service.dart';
import '../../features/authentication/login/presentation/controller/login_controller.dart';
import '../../features/common/category/data/category_service.dart';
import '../../features/common/category/presentation/controller/category_controller.dart';
import '../../features/common/subCategories/data/sub_categories_service.dart';
import '../../features/common/subCategories/presentation/controller/sub_categories_controller.dart';
import '../../features/vendor/vendorStoreScreen/data/vendor_products_service.dart';
import '../../features/vendor/vendorStoreScreen/presentation/controller/vendor_product_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Auth
    Get.lazyPut<LoginService>(() => LoginService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<LoginController>(() => LoginController(Get.find<LoginService>()), fenix: true);

    // Categories
    Get.lazyPut<CategoryService>(() => CategoryService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<CategoryController>(() => CategoryController(Get.find<CategoryService>()), fenix: true);

    // SubCategories
    Get.lazyPut<SubCategoryService>(() => SubCategoryService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<SubCategoryController>(() => SubCategoryController(Get.find<SubCategoryService>()), fenix: true);

    // Vendor Products
    Get.lazyPut<VendorProductService>(() => VendorProductService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<VendorProductController>(() => VendorProductController(Get.find<VendorProductService>()), fenix: true);
  }
}
