import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/service_rating_service.dart';
import '../controller/service_rating_controller.dart';


class ServiceRatingBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<ServiceRatingService>(
            () => ServiceRatingService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<ServiceRatingController>(
            () => ServiceRatingController(Get.find<ServiceRatingService>())
    );
  }
}