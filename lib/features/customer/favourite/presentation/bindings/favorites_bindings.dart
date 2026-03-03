import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/favorites_service.dart';
import '../controller/favorites_controller.dart';

class FavoritesBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<CustomerFavoritesService>(
            () => CustomerFavoritesService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<CustomerFavoritesController>(
            () => CustomerFavoritesController(Get.find<CustomerFavoritesService>())
    );
  }
}