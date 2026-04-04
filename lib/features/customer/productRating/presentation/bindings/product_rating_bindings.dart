import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/product_rating_service.dart';
import '../controller/product_rating_controller.dart';


class ProductRatingBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<ProductRatingService>(
            () => ProductRatingService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<ProductRatingController>(
            () => ProductRatingController(Get.find<ProductRatingService>())
    );
  }
}